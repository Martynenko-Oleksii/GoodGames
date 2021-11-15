using GGBack.Data;
using GGBack.Models;
using GGBack.Utils;
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

        [HttpGet("{competitorId}")]
        public ActionResult<CompetitorInfo> GetCompetitor(int competitorId)
        {
            try
            {
                Competitor competitor = context.Competitors.Find(competitorId);
                if (competitor == null)
                {
                    return BadRequest("Учасника не існує :(");
                }

                List<Competitor> competitorsByOneEmail = context.Competitors
                    .Include(c => c.Competitions)
                        .ThenInclude(c => c.TimetableCells)
                            .ThenInclude(tc => tc.WinResult)
                    .Where(c => c.Email.Equals(competitor.Email) && c.Name.Equals(competitor.Name))
                    .ToList();
                int competitionCount = competitorsByOneEmail.Count;
                int winCount = CompetitorStatistic.GetWinCount(competitorsByOneEmail);

                return Ok(new CompetitorInfo
                {
                    Name = competitor.Name,
                    Team = competitor.Team,
                    Age = competitor.Age,
                    Gender = competitor.Gender,
                    CompetitionCount = competitionCount,
                    WinCount = winCount
                });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }
        }

        [HttpPost]
        public async Task<ActionResult<Competitor>> Post(CompetitorForRequest competitor)
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

            Competitor finalCompetitor = new Competitor
            {
                Name = competitor.Name,
                Email = competitor.Email,
                Age = competitor.Age,
                Gender = competitor.Gender,
                Weigth = competitor.Weigth,
                HealthState = competitor.HealthState,
                Team = competitor.Team,
                Competitions = competitions
            };
            context.Competitors.Add(finalCompetitor);
            await context.SaveChangesAsync();

            return Ok(new Competitor { Id = finalCompetitor.Id, Name = finalCompetitor.Name });
        }
    }
}
