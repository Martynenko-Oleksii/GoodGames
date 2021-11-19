using GGBack.Data;
using GGBack.DTO;
using GGBack.Models;
using GGBack.Utils;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
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
        public ActionResult<IEnumerable<TimetableCell>> Get(int competitionId)
        {
            try
            {
                return context.TimetableCells
                    .Include(t => t.Competitors)
                    .Include(t => t.WinResult)
                    .Where(t => t.Competition.Id == competitionId && 
                        t.Competitors.Select(c => c.Team).Distinct().ToList().Count == 2)
                    .OrderBy(t => t.DateTime)
                    .ToList();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
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
                    .Include(c => c.RawNewss)
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
                    return BadRequest($"Замало учасників.\nНеобхідно мінімум: {sport.MinCompetitorsCount}");
                }

                if (teams.Count < 2)
                {
                    return BadRequest("Необхідно мінімум 2 команди");
                }

                if (timeBoundary.End.Hour - timeBoundary.Start.Hour < 2)
                {
                    return BadRequest("Необхідно мінімум 2 години на проведення одного матчу");
                }

                List<TimetableCell> cells = new List<TimetableCell>();
                int startCount = 0;
                if (sport.HasTeam)
                {
                    int dayCount = (int)(endDate - startDate).TotalDays + 1;
                    double timePerDay = (endTime - startTime).TotalHours;
                    int playCount = ((int)timePerDay / 2) * dayCount;

                    int startCellsCount = 1;
                    while (teamsCount / 2 > startCellsCount)
                    {
                        startCellsCount *= 2;
                    }

                    int allCellsCount = 1;
                    if (startCellsCount > 1)
                    {
                        allCellsCount = startCellsCount * 2;
                    }

                    if (allCellsCount > playCount)
                    {
                        return BadRequest("Забагато учасників для цього змагання");
                    }

                    if (sport.TeamSize != 0)
                    {
                        foreach (string team in teams)
                        {
                            int competitorsCountPerTeam = competitors
                                .Where(c => c.Team.Equals(team))
                                .ToList().Count;

                            if (competitorsCountPerTeam != sport.TeamSize)
                            {
                                return BadRequest($"Кількість учасників у команді {team} не відповідає правилам");
                            }
                        }

                        if (teamsCount < sport.MinTeamsCount)
                        {
                            return BadRequest($"Замало команд.\nНеобхідно мінімум {sport.MinTeamsCount}");
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
                    return BadRequest("Розклад не вдалось згенерувати :(");
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

                if (competition.IsPublic)
                {
                    RawNews rawNews = await NewsGenerator.SetRawNewsAsync(
                        new string[] { competition.Title },
                        new string[]
                        {
                            competition.Title, 
                            teamsCount.ToString(),
                            competitorsCount.ToString()
                        }, competition, NewsType.CompetitionStarting);

                    context.RawNewss.Add(rawNews);
                    competition.RawNewss.Add(rawNews);

                    List<string> ids = MessageSender.GetIds(context, competition.Sport);
                    MessageDto messageDto = MessageSender.SetMessage(ids, "Початок змагання", competition.Title, competition.Id.ToString());
                    HttpResponseMessage response = await MessageSender.SendMessage(messageDto);
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
