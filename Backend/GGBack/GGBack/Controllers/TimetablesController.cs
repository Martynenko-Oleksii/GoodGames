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
    [ApiController]
    public class TimetablesController : ControllerBase
    {
        private ServerDbContext context;

        public TimetablesController(ServerDbContext context)
        {
            this.context = context;
        }

        [Route("api/timetables/{competitionId}")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TimetableCell>>> Get(int competitionId)
        {
            return await context.TimetableCells
                .Include(t => t.Competitors)
                .Include(t => t.Competition)
                .Include(t => t.WinResult)
                .Where(t => t.Competition.Id == competitionId)
                .ToListAsync();
        }

        [Route("api/timetables/create/{competitionId}")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TimetableCell>>> Create(int competitionId)
        {
            Competition competition = context.Competitions
                .Include(c => c.Sport)
                .Include(c => c.Competitors)
                .Where(c => c.Id == competitionId)
                .FirstOrDefault();

            List<Competitor> competitors = competition.Competitors;
            List<string> teams = competition.Competitors
                .Select(c => c.Team)
                .Distinct()
                .ToList();

            int competitorsCount = competitors.Count;
            int teamsCount = teams.Count;

            bool hasTeam = competition.Sport.HasTeam;
            bool ghasGrid = competition.Sport.HasGrid;
            int minCompetitorsCount = competition.Sport.MinCompetitorsCount;
            int minTeamsCount = competition.Sport.MinTeamsCount;
            int teamSize = competition.Sport.TeamSize;

            if (hasTeam)
            {
                if (competitorsCount % teamSize != 0 || 
                    competitorsCount < minCompetitorsCount)
                {
                    return BadRequest("Wrong competitors count");
                }

                if (teamsCount < minTeamsCount)
                {
                    return BadRequest("Wrong teams count");
                }

                if (teamsCount % 2 != 0)
                {
                    return BadRequest("teams count % 2 != 0");
                }

                if (competitorsCount - teamsCount * teamSize != 0)
                {
                    return BadRequest("Wrong competitors count per team");
                }

                foreach (string team in teams)
                {
                    int competitorsCountPerTeam = competitors
                        .Where(c => c.Name.Equals(team))
                        .ToList().Count();

                    if (competitorsCountPerTeam != teamSize)
                    {
                        return BadRequest($"Wrong competitors count in team {team}");
                    }
                }
            }

            return Ok("WIP");
        }
    }
}
