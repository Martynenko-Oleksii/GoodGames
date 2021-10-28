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
        public async Task<ActionResult<IEnumerable<TimetableCell>>> Create(TimeBoundary timeBoundary)
        {
            Competition competition = context.Competitions
                .Include(c => c.Sport)
                .Include(c => c.Competitors)
                .Where(c => c.Id == timeBoundary.Id)
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

            DateTime startDate = competition.StartDate;
            DateTime endDate = competition.EndDate;

            DateTime startTime = timeBoundary.Start;
            DateTime endTime = timeBoundary.End;

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
                        .ToList().Count;

                    if (competitorsCountPerTeam != teamSize)
                    {
                        return BadRequest($"Wrong competitors count in team {team}");
                    }
                }

                if (timeBoundary.End.Hour - timeBoundary.Start.Hour < 2)
                {
                    return BadRequest("Wrong time for games");
                }

                List<TimetableCell> cells = ScheduleGenerator
                    .GenerateForTeamSports(teams, 
                        competitors, competition, 
                        startDate, endDate, 
                        startTime, endTime);

                if (cells == null)
                {
                    return BadRequest("Wront end date for competition");
                }

                context.TimetableCells.AddRange(cells);
            }
            else
            {

            }

            await context.SaveChangesAsync();

            return await context.TimetableCells.ToListAsync();
        }
    }
}
