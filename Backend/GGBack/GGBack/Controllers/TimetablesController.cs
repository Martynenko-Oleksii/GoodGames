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
            try
            {
                return await context.TimetableCells
                    .Include(t => t.Competitors)
                    .Include(t => t.WinResult)
                    .Where(t => t.Competition.Id == competitionId)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Route("api/timetables/create")]
        [HttpPost]
        public async Task<ActionResult<IEnumerable<TimetableCell>>> Create(TimeBoundary timeBoundary)
        {
            try
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
                Sport sport = competition.Sport;

                int competitorsCount = competitors.Count;
                int teamsCount = teams.Count;

                DateTime startDate = competition.StartDate;
                DateTime endDate = competition.EndDate;

                DateTime startTime = timeBoundary.Start;
                DateTime endTime = timeBoundary.End;

                if (competitorsCount < sport.MinCompetitorsCount)
                {
                    return BadRequest("Wrong competitors count");
                }

                if (teams.Count < 2)
                {
                    return BadRequest("Wrong teams count");
                }

                if (timeBoundary.End.Hour - timeBoundary.Start.Hour < 2)
                {
                    return BadRequest("Wrong time for games: min 2 hours");
                }

                List<TimetableCell> cells = new List<TimetableCell>();
                int startCount = 0;
                if (sport.HasTeam)
                {
                    if (sport.TeamSize != 0)
                    {
                        foreach (string team in teams)
                        {
                            int competitorsCountPerTeam = competitors
                                .Where(c => c.Name.Equals(team))
                                .ToList().Count;

                            if (competitorsCountPerTeam != sport.TeamSize)
                            {
                                return BadRequest($"Wrong competitors count in team {team}");
                            }
                        }

                        if (competitorsCount % sport.TeamSize != 0)
                        {
                            return BadRequest("Wrong competitors count");
                        }

                        if (teamsCount < sport.MinTeamsCount)
                        {
                            return BadRequest("Wrong teams count");
                        }

                        if (competitorsCount - teamsCount * sport.TeamSize != 0)
                        {
                            return BadRequest("Wrong competitors count per team");
                        }
                    }

                    cells = ScheduleGenerator.GenerateForTeamSports(teams,
                                                competitors, competition,
                                                startDate, endDate,
                                                startTime, endTime, 
                                                out startCount, context);
                }
                else
                {
                    cells = ScheduleGenerator.GenerateForNoTeamSports(
                                                competitors, competition,
                                                startDate, endDate,
                                                startTime, endTime,
                                                out startCount, context);
                }

                if (cells == null)
                {
                    return BadRequest("Error :(");
                }

                competition.State = 1;

                if (startCount > 2)
                {
                    int count = startCount / 4;
                    int gridStage = 3;
                    while (count != 1)
                    {
                        for (int i = 0; i < count; i++)
                        {
                            context.TimetableCells.Add(new TimetableCell
                            {
                                Competition = competition,
                                GridStage = gridStage
                            });
                        }

                        gridStage++;
                        count /= 2;
                    }

                    context.TimetableCells.Add(new TimetableCell
                    {
                        Competition = competition,
                        GridStage = gridStage
                    });
                    context.TimetableCells.Add(new TimetableCell
                    {
                        Competition = competition,
                        GridStage = gridStage
                    });
                }
                await context.SaveChangesAsync();

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }
        }
    }
}
