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

                if (teamsCount % 4 == 0)
                {
                    //TODO
                }
                else
                {
                    List<DateTime> times = new List<DateTime>();
                    string[] teamsArray = teams.ToArray();
                    for (int i = 0; i < teamsCount; i += 2)
                    {
                        List<Competitor> competitorsPerTwoTeams = competitors
                            .Where(c => 
                                c.Team.Equals(teamsArray[i]) || 
                                c.Team.Equals(teamsArray[i+1]))
                            .ToList();

                        DateTime dt = new DateTime();

                        if (DateTime.UtcNow > competition.StartDate)
                        {
                            times.Add(new DateTime(DateTime.UtcNow.Year,
                                                    DateTime.UtcNow.Month,
                                                    DateTime.UtcNow.Day + 1,
                                                    timeBoundary.Start.Hour - 2,
                                                    timeBoundary.Start.Minute,
                                                    0));
                        }
                        else
                        {
                            times.Add(new DateTime(startDate.Year,
                                                    startDate.Month,
                                                    startDate.Day,
                                                    timeBoundary.Start.Hour - 2,
                                                    timeBoundary.Start.Minute,
                                                    0));
                        }

                        DateTime newDateTime = times.Last().AddHours(2);
                        if (newDateTime < endDate.AddDays(1))
                        {
                            if (newDateTime.AddHours(2) < timeBoundary.End)
                            {
                                dt = newDateTime;
                                times.Add(newDateTime);
                            }
                            else
                            {
                                DateTime temp = new DateTime(newDateTime.Year,
                                    newDateTime.Month,
                                    newDateTime.Day + 1,
                                    timeBoundary.Start.Hour,
                                    timeBoundary.Start.Minute,
                                    0);
                                dt = temp;
                                times.Add(temp);
                            }
                        }
                        else
                        {
                            return BadRequest("Wront end date for competition");
                        }

                        TimetableCell ttCell = new TimetableCell
                        {
                            DateTime = dt,
                            Competitors = competitorsPerTwoTeams,
                            Competition = competition,
                            GridStage = 1
                        };

                        context.TimetableCells.Add(ttCell);
                    }
                }
            }

            await context.SaveChangesAsync();

            return await context.TimetableCells.ToListAsync();
        }
    }
}
