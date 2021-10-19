using GGBack.Data;
using GGBack.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;

namespace GGBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CompetitionsController : ControllerBase
    {
        private static JsonSerializerOptions options = new JsonSerializerOptions { IgnoreNullValues = true };

        private ServerDbContext context;

        public CompetitionsController(ServerDbContext context)
        {
            this.context = context;
        }

        [HttpGet("{login}")]
        public async Task<ActionResult<IEnumerable<Competition>>> Get(string login)
        {
            return await context.Competitions
                .Where(c => c.UserId.Equals(login))
                .Select(c => new Competition
                {
                    Id = c.Id,
                    Title = c.Title
                })
                .ToListAsync();
        }
    }
}
