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

        [Route("api/competitions")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Competition>>> Get()
        {
            return await context.Competitions.ToListAsync();
        }

        [Route("api/competitions/{competitionId}")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Competition>>> GetCompetition(int competitionId)
        {
            return await context.Competitions
                .Include(c => c.User)
                .Include(c => c.Sport)
                .Include(c => c.Competitors)
                .Include(c => c.TimetableCells)
                .Where(c => c.Id == competitionId)
                .Select(c => new Competition
                {
                    Id = c.Id,
                    Title = c.Title,
                    Description = c.Description,
                    IsOpen = c.IsOpen,
                    Sport = c.Sport,
                    AgeLimit = c.AgeLimit,
                    City = c.City,
                    StartDate = c.StartDate,
                    EndDate = c.EndDate,
                    IsPublic = c.IsPublic,
                    Competitors = c.Competitors,
                    User = new User
                    {
                        Id = c.User.Id,
                        Login = c.User.Login
                    },
                    StreamUrl = c.StreamUrl,
                    State = c.State,
                    TimetableCells = c.TimetableCells
                })
                .ToListAsync();
        }

        [Route("api/competitions/users/{userId}")]
        [HttpGet]
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

        [Route("api/competitions/delete/{competitionId}")]
        [HttpGet]
        public async Task<ActionResult<Competition>> Get(int competitionId)
        {
            if (competitionId == 0)
            {
                return BadRequest("invalid competition id");
            }

            Competition competiotion = context.Competitions
                .FirstOrDefault(c => c.Id == competitionId);

            if (competiotion == null)
            {
                return NotFound("Competition does not exist");
            }

            context.Competitions.Remove(competiotion);
            await context.SaveChangesAsync();

            return Ok(competiotion);
        }

        [Route("api/competitions/create")]
        [HttpPost]
        public async Task<ActionResult<Competition>> PostNewCompetition(Competition competition)
        {
            try
            {
                competition.User = context.Users.Find(competition.User.Id);
                competition.Sport = context.Sports.Find(competition.Sport.Id);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.InnerException);
            }

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

            Competition res = new Competition { Id = competition.Id, Title = competition.Title };

            try
            {

                context.Competitions.Add(competition);
                await context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.InnerException);
            }

            return Ok(res);
        }
    }
}
