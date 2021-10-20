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

            if(competition.User.Equals(null))
            {
                return BadRequest("no owner");
            }

            if (context.Users.Find(competition.User.Id).Equals(null)) 
            {
                return BadRequest("invalid user id");
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
            competition.User = context.Users.Where(u => u.Id == competition.User.Id).First();

            context.Competitions.Add(competition);
            await context.SaveChangesAsync();

            return Ok(competition);
        }

        [Route("api/competition/delete")]
        [HttpPost]
        public async Task<ActionResult<Competition>> PostDeleteCompetition(int competitionId)
        {
            if (competitionId.Equals(null))
            {
                return BadRequest("invalid competition id");
            }

            context.Competitions.Remove( context.Competitions.Find(competitionId) );

            await context.SaveChangesAsync();
            return Ok(competitionId);
        }
    }
}
