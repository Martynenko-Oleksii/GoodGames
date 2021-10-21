using GGBack.Data;
using GGBack.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CompetitorsController : ControllerBase
    {
        private ServerDbContext context;

        public CompetitorsController(ServerDbContext context)
        {
            this.context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Competitor>>> Get()
        {
            return await context.Competitors.ToListAsync(); 
        }

        [HttpPost]
        public async Task<ActionResult<Competitor>> Post(Competitor competitor)
        {
            if (competitor == null)
            {
                return BadRequest();
            }

            List<Competition> competitions = new List<Competition>();
            foreach (Competition c in competitor.Competitions)
            {
                competitions.Add(context.Competitions.Find(c.Id));
            }

            if (!context.Competitors.Any(c => c.Email == competitor.Email))
            {
                context.Competitors.Add(new Competitor
                {
                    Name = competitor.Name,
                    Email = competitor.Email,
                    Age = competitor.Age,                        
                    Gender = competitor.Gender,
                    Weigth = competitor.Weigth,
                    HealthState = competitor.HealthState,
                    Team = competitor.Team,
                    Competitions = competitions
                });
            }
            else
            {
                Competitor oldCompetitor = context.Competitors
                    .Include(c => c.Competitions)
                    .Where(c => c.Email.Equals(competitor.Email))
                    .ToList().FirstOrDefault();

                if (oldCompetitor != null)
                {
                    try
                    {
                        oldCompetitor.Competitions.AddRange(competitions);
                        oldCompetitor.Name = competitor.Name;
                        oldCompetitor.Age = competitor.Age;
                        oldCompetitor.Gender = competitor.Gender;
                        oldCompetitor.Weigth = competitor.Weigth;
                        oldCompetitor.HealthState = competitor.HealthState;
                        oldCompetitor.Team = competitor.Team;
                    }
                    catch (Exception ex)
                    {
                        return BadRequest(ex.Message + "\n" + ex.InnerException);
                    }
                }
            }

            await context.SaveChangesAsync();

            return Ok();
        }
    }
}
