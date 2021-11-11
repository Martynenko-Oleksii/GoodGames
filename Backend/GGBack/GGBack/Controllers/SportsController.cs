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
    [ApiController]
    public class SportsController : ControllerBase
    {
        private ServerDbContext context;

        public SportsController(ServerDbContext context)
        {
            this.context = context;
        }

        [Route("api/sports")]
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

        [Route("api/sports/{userId}")]
        [HttpGet]
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

        [Route("api/addsport/{userId}")]
        [HttpPost]
        public async Task<ActionResult<IEnumerable<Sport>>> AddSport([FromRoute] int userId, [FromBody] Sport sport)
        {
            if (sport == null)
            {
                return BadRequest("Sport is null");
            }

            Sport dbSport = context.Sports.Find(sport.Id);
            if (dbSport == null)
            {
                return BadRequest("Sport not found");
            }

            User user = context.Users
                .Include(u => u.Sports)
                .Where(u => u.Id == userId)
                .FirstOrDefault();
            if (user == null)
            {
                return BadRequest("User not found");
            }

            Sport userSport = user.Sports.Find(s => s.Id == dbSport.Id);
            if (userSport != null)
            {
                return BadRequest("Sport already added");
            }

            user.Sports.Add(dbSport);
            await context.SaveChangesAsync();

            return Ok(user.Sports);
        }

        [Route("api/deletesport/{userId}")]
        [HttpPost]
        public async Task<ActionResult<IEnumerable<Sport>>> DeleteSport([FromRoute] int userId, [FromBody] Sport sport)
        {
            if (sport == null)
            {
                return BadRequest("Sport is null");
            }

            User user = context.Users
                .Include(u => u.Sports)
                .Where(u => u.Id == userId)
                .FirstOrDefault();
            if (user == null)
            {
                return BadRequest("User not found");
            }

            try
            {
                Sport removeSport = user.Sports.Find(s => s.Id == sport.Id);
                if (removeSport == null)
                {
                    return BadRequest("Sport not found");
                }

                user.Sports.Remove(removeSport);
                await context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }

            return Ok(user.Sports);
        }

        [Route("api/sports")]
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
