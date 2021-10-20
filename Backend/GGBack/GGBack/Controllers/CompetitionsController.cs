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

        [Route("api/competitions")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Competition>>> Get()
        {
            return await context.Competitions.ToListAsync();
        }

        [Route("api/competition/create")]
        [HttpPost]
        public async Task<ActionResult<Competition>> PostNewCompetition(Competition competition)
        {
            if (competition == null)
            {
                return BadRequest("null");
            }

            if(competition.User == null)
            {
                return BadRequest("no owner");
            }

            if (competition.Title == null)
            {
                return BadRequest("no title");
            }

            if (context.Competitions.Any(comp => comp.Title == competition.Title))
            {
                return BadRequest("title collision");
            }

            competition.State = "planned";

            context.Competitions.Add(competition);
            await context.SaveChangesAsync();

            return Ok(competition);
        }
    }
}
