using GGBack.Data;
using GGBack.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public class ScheduleGenerator
    {
        public static List<TimetableCell> GenerateForTeamSports(List<string> teams,
            List<Competitor> competitors, Competition competition,
            DateTime startDate, DateTime endDate,
            DateTime startTime, DateTime endTime)
        {
            int fullTeamsCount = 2;
            while (teams.Count > fullTeamsCount)
            {
                fullTeamsCount *= 2; ;
            }

            TimetableCell[] timetableCells = new TimetableCell[fullTeamsCount / 2];

            string[] teamsArray = teams.ToArray();

            int step = 1;
            bool isStepForcedChanged = false;
            int teamIndex = 0;
            for (int i = 0; i < timetableCells.Length; i += step)
            {
                if (teamIndex > teamsArray.Length)
                {
                    break;
                }

                List<Competitor> competitorsPerTeam = competitors
                    .Where(c => c.Team.Equals(teamsArray[teamIndex++]))
                    .ToList();
                if (timetableCells[i] == null)
                {
                    timetableCells[i] = new TimetableCell
                    {
                        Competitors = competitorsPerTeam,
                        Competition = competition,
                        GridStage = 1
                    };
                }
                else
                {
                    timetableCells[i].Competitors.AddRange(competitorsPerTeam);
                }

                if (i + step >= timetableCells.Length)
                {
                    if (isStepForcedChanged)
                    {
                        break;
                    }
                    else
                    {
                        i = step - 1;
                    }
                }

                step *= 2;
                if (step > timetableCells.Length / 2)
                {
                    step = timetableCells.Length / 2;
                    isStepForcedChanged = true;
                }
            }

            List<DateTime> times = new List<DateTime>();
            if (DateTime.UtcNow > competition.StartDate)
            {
                DateTime temp = DateTime.UtcNow.AddDays(1);
                times.Add(new DateTime(temp.Year, temp.Month, temp.Day,
                    startTime.Hour - 2, startTime.Minute, 0));
            }
            else
            {
                times.Add(new DateTime(startDate.Year, startDate.Month, startDate.Day,
                    startTime.Hour - 2, startTime.Minute, 0));
            }

            int fullCompetitorsCount = competition.Sport.MinCompetitorsCount;
            List<TimetableCell> cells = new List<TimetableCell>();
            for (int i = 0; i < timetableCells.Length; i++)
            {
                if (timetableCells[i].Competitors.Count == fullCompetitorsCount)
                {
                    DateTime dt = new DateTime();
                    DateTime newDateTime = times.Last().AddHours(2);
                    if (newDateTime < endDate.AddDays(1))
                    {
                        if (newDateTime.AddHours(2) < endTime)
                        {
                            dt = newDateTime;
                            times.Add(newDateTime);
                        }
                        else
                        {
                            DateTime temp = newDateTime.AddDays(1);
                            temp = new DateTime(temp.Year, temp.Month, temp.Day,
                                startTime.Hour, startTime.Minute, 0);

                            dt = temp;
                            times.Add(temp);
                        }
                    }
                    else
                    {
                        return null;
                    }

                    timetableCells[i].DateTime = dt;
                }

                cells.Add(timetableCells[i]);
            }

            return cells;
        }

        public static List<TimetableCell> GenerateForNoTeamSports(
            List<Competitor> competitors, Competition competition,
            DateTime startDate, DateTime endDate,
            DateTime startTime, DateTime endTime)
        {
            int fullCompetitorsCount = 2;
            while (competitors.Count > fullCompetitorsCount)
            {
                fullCompetitorsCount *= 2;
            }

            TimetableCell[] timetableCells = new TimetableCell[fullCompetitorsCount / 2];

            Competitor[] competitorsArray = competitors.ToArray();

            int step = 1;
            bool isStepForcedChanged = false;
            int competitorIndex = 0;
            for (int i = 0; i < timetableCells.Length; i += step)
            {
                if (competitorIndex > competitorsArray.Length)
                {
                    break;
                }

                Competitor competitor = competitorsArray[competitorIndex++];
                List<Competitor> competitorsPerCell = new List<Competitor>();
                competitorsPerCell.Add(competitor);

                if (timetableCells[i] == null)
                {
                    timetableCells[i] = new TimetableCell
                    {
                        Competitors = competitorsPerCell,
                        Competition = competition,
                        GridStage = 1
                    };
                }
                else
                {
                    timetableCells[i].Competitors.AddRange(competitorsPerCell);
                }

                if (i + step >= timetableCells.Length)
                {
                    if (isStepForcedChanged)
                    {
                        break;
                    }
                    else
                    {
                        i = step - 1;
                    }
                }

                step *= 2;
                if (step > timetableCells.Length / 2)
                {
                    step = timetableCells.Length / 2;
                    isStepForcedChanged = true;
                }
            }

            Dictionary<DateTime, int> times = new Dictionary<DateTime, int>();
            if (times.Count == 0)
            {
                if (DateTime.UtcNow > competition.StartDate)
                {
                    DateTime temp = DateTime.UtcNow.AddDays(1);
                    times.Add(new DateTime(temp.Year, temp.Month, temp.Day,
                        startTime.Hour, startTime.Minute, 0), 0);
                }
                else
                {
                    times.Add(new DateTime(startDate.Year, startDate.Month, startDate.Day,
                        startTime.Hour, startTime.Minute, 0), 0);
                }
            }

            int fullCompetitorsPerCell = competition.Sport.MinCompetitorsCount;
            List<TimetableCell> cells = new List<TimetableCell>();
            for (int i = 0; i < timetableCells.Length; i++)
            {
                if (timetableCells[i].Competitors.Count == fullCompetitorsPerCell)
                {
                    DateTime dt = new DateTime();
                    KeyValuePair<DateTime, int> timePair = times.Last();
                    DateTime newDateTime = new DateTime();
                    if (timePair.Value < 3)
                    {
                        newDateTime = timePair.Key;
                        times[newDateTime] += 1;
                    }
                    else
                    {
                        newDateTime = timePair.Key.AddHours(2);
                    }

                    if (newDateTime < endDate.AddDays(1))
                    {
                        if (newDateTime.Hour < endTime.Hour)
                        {
                            dt = newDateTime;

                            if (!times.ContainsKey(newDateTime))
                            {
                                times.Add(newDateTime, 1);
                            }
                        }
                        else
                        {
                            DateTime temp = newDateTime.AddDays(1);
                            temp = new DateTime(temp.Year, temp.Month, temp.Day,
                                startTime.Hour, startTime.Minute, 0);

                            dt = temp;
                            times.Add(temp, 1);
                        }
                    }
                    else
                    {
                        return null;
                    }

                    timetableCells[i].DateTime = dt;
                }

                cells.Add(timetableCells[i]);
            }

            return cells;
        }

        //TODO
        public static bool GenerateForNewResults(TimetableCell cellWithResults, ServerDbContext context)
        {
            TimetableCell lastCell = context.TimetableCells
                .Include(c => c.Competition)
                    .ThenInclude(c => c.Sport)
                .Include(c => c.Competitors)
                .Include(c => c.WinResult)
                .Where(c => c.Competition.Id == cellWithResults.Competition.Id)
                .OrderBy(c => c.Id).Last();

            var lastHour = context.TimetableCells
                .Where(c => c.Competition.Id == cellWithResults.Competition.Id)
                .Select(c => new
                    {
                        Hour = c.DateTime.Hour,
                        Minute = c.DateTime.Minute
                    }).Distinct()
                .LastOrDefault();

            WinResult result = cellWithResults.WinResult;
            int resultOne = Int32.Parse(result.Score.Split(',')[0]);
            int resultTwo = Int32.Parse(result.Score.Split(',')[1]);

            List<Competitor> winCompetitors = new List<Competitor>();
            if (resultOne > resultTwo)
            {
                winCompetitors = cellWithResults.Competitors
                    .GetRange(0, lastCell.Competition.Sport.TeamSize);
            }
            else if (resultOne < resultTwo)
            {
                winCompetitors = cellWithResults.Competitors
                    .GetRange(lastCell.Competition.Sport.TeamSize,
                        lastCell.Competition.Sport.TeamSize);
            }

            if (lastCell.Competitors.Count != lastCell.Competition.Sport.MinCompetitorsCount)
            {
                lastCell.Competitors.AddRange(winCompetitors);
            }
            else if (lastCell.Competitors.Count == lastCell.Competition.Sport.MinCompetitorsCount)
            {
                TimetableCell newCell = new TimetableCell
                {
                    Competitors = winCompetitors,
                    Competition = cellWithResults.Competition,
                    GridStage = cellWithResults.GridStage + 1
                };

                DateTime newCellDateTime = lastCell.DateTime.AddHours(2);
                DateTime endDayBoundary = new DateTime(newCellDateTime.Year,
                    newCellDateTime.Month, newCellDateTime.Day,
                    lastHour.Hour, lastHour.Minute, 0);
                if (newCellDateTime > lastCell.Competition.EndDate ||
                    newCellDateTime > endDayBoundary)
                {
                    return false;
                }
                else
                {
                    newCell.DateTime = newCellDateTime;
                }

                context.TimetableCells.Add(newCell);
            }

            return true;
        }
    }
}
