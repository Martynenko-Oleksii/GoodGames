using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Text.Json;
using GGBack.Utils;
using GGBack.Data;
using GGBack.Models;
using Microsoft.EntityFrameworkCore;

namespace GGBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SportsController : ControllerBase
    {
        private static JsonSerializerOptions options = new JsonSerializerOptions { IgnoreNullValues = true };

        private ServerDbContext context;

        public SportsController(ServerDbContext context)
        {
            this.context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Sport>>> Get()
        {
            try
            {
                return await context.Sports.ToListAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }
        }

        [HttpGet("{userId}")]
        public ActionResult<IEnumerable<Sport>> Get(int userId)
        {
            User user = context.Users
                .Include(u => u.Sports)
                .Where(u => u.Id == userId)
                .ToList().FirstOrDefault();

            if (user == null)
            {
                return NotFound($"Not found user with id: {userId}");
            }

            return Ok(user.Sports);
        }

        [HttpPost]
        public async Task<ActionResult<Sport>> PostNewSport(Sport sport)
        {
            if (sport == null)
            {
                return BadRequest("null");
            }

            if (sport.Title == null)
            {
                return BadRequest("no title");
            }

            if (context.Sports.Any(s => s.Title == sport.Title))
            {
                return BadRequest("title collision");
            }

            context.Sports.Add(sport);
            await context.SaveChangesAsync();

            return Ok(sport);
        }
    }
}
