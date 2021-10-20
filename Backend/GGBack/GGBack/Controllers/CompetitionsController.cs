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

        [HttpGet("{id}")]
        public async Task<ActionResult<IEnumerable<Competition>>> GetCompetitions(int userId)
        {
            return await context.Competitions
                .Include(c => c.User)
                .Where(c => c.User.Id == userId)
                .Select(c => new Competition
                {
                    Id = c.Id,
                    Title = c.Title
                })
                .ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<IEnumerable<Competition>>> GetCompetition(int competitionId)
        {
            return await context.Competitions
                .Include(c => c.Sport)
                .Include(c => c.Competitors)
                .Include(c => c.User)
                .Where(c => c.Id.Equals(competitionId))
                .ToListAsync();
        }
    }
}
