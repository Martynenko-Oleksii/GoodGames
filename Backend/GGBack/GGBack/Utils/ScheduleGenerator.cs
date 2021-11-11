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
            DateTime startTime, DateTime endTime,
            out int startCount, ServerDbContext context)
        {
            int fullTeamsCount = 2;
            while (teams.Count > fullTeamsCount)
            {
                fullTeamsCount *= 2;
            }

            TimetableCell[] timetableCells = new TimetableCell[fullTeamsCount / 2];
            startCount = timetableCells.Length;
            string[] teamsArray = teams.ToArray();

            int changedStep = 1;
            int step = changedStep;
            int teamIndex = 0;
            for (int i = 0; i < timetableCells.Length; i += step)
            {
                step = changedStep;
                List<Competitor> competitorsPerTeam = competitors
                    .Where(c => c.Team.Equals(teamsArray[teamIndex]))
                    .ToList();
                teamIndex++;

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

                if (teamIndex >= teamsArray.Length)
                {
                    break;
                }

                if (i + step >= timetableCells.Length)
                {
                    i = step - 2;
                    step = 1;
                    changedStep *= 2;
                }

                if (changedStep > timetableCells.Length / 2)
                {
                    changedStep = timetableCells.Length / 2;

                    if (changedStep < 1)
                    {
                        changedStep = 1;
                    }
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

            List<TimetableCell> cells = new List<TimetableCell>(timetableCells);
            context.TimetableCells.AddRange(cells);
            context.SaveChanges();
            SetFullCells(cells, context);

            for (int i = 0; i < cells.Count; i++)
            {
                if (cells.ElementAt(i).Competitors != null)
                {
                    int teamCountPerCell = cells.ElementAt(i).Competitors
                        .Select(c => c.Team).Distinct().ToList().Count;
                    if (teamCountPerCell == 2)
                    {
                        DateTime dt = new DateTime();
                        DateTime newDateTime = times.Last().AddHours(2);
                        if (newDateTime < endDate.AddDays(1))
                        {
                            if (newDateTime.AddHours(2).Hour <= endTime.Hour &&
                                newDateTime.Minute <= endTime.Minute)
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

                        cells.ElementAt(i).DateTime = dt;
                    }
                }
            }

            return cells;
        }

        //TODO
        public static List<TimetableCell> GenerateForNoTeamSports(
            List<Competitor> competitors, Competition competition,
            DateTime startDate, DateTime endDate,
            DateTime startTime, DateTime endTime,
            out int startCount, ServerDbContext  context)
        {
            int fullCompetitorsCount = 2;
            while (competitors.Count > fullCompetitorsCount)
            {
                fullCompetitorsCount *= 2;
            }

            TimetableCell[] timetableCells = new TimetableCell[fullCompetitorsCount / 2];
            startCount = timetableCells.Length;
            Competitor[] competitorsArray = competitors.ToArray();

            int step = 1;
            bool isStepForcedChanged = false;
            int competitorIndex = 0;
            for (int i = 0; i < timetableCells.Length; i += step)
            {
                if (competitorIndex >= competitorsArray.Length)
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
                        i = step - 2;
                    }

                    step *= 2;
                }

                if (step > timetableCells.Length / 2)
                {
                    step = timetableCells.Length / 2;

                    if (step < 1)
                    {
                        step = 1;
                    }

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

        public static bool GenerateForNewResults(TimetableCell cellWithResults, ServerDbContext context)
        {
            List<TimetableCell> stagedCells = context.TimetableCells
                .Include(t => t.WinResult)
                .Include(t => t.Competition)
                .Include(t => t.Competitors)
                .Where(t => t.Competition.Id == cellWithResults.Competition.Id && 
                        t.GridStage == cellWithResults.GridStage)
                .ToList();

            List<TimetableCell> nextStageCells = context.TimetableCells
                .Include(t => t.WinResult)
                .Include(t => t.Competition)
                .Include(t => t.Competitors)
                .Where(t => t.Competition.Id == cellWithResults.Competition.Id && 
                        t.GridStage == cellWithResults.GridStage + 1)
                .ToList();

            if (nextStageCells.Count > 1)
            {
                string[] score = cellWithResults.WinResult.Score.Split(',');
                int scoreOne = Int32.Parse(score[0]);
                int scoreTwo = Int32.Parse(score[1]);

                List<Competitor> winCompetitors = cellWithResults.Competitors
                        .Where(c => c.Team.Equals(cellWithResults.WinResult.TeamOne))
                        .ToList();
                List<Competitor> lostCompetitors = cellWithResults.Competitors
                        .Where(c => c.Team.Equals(cellWithResults.WinResult.TeamTwo))
                        .ToList();

                if (scoreOne < scoreTwo)
                {
                    List<Competitor> temp = winCompetitors;
                    winCompetitors = lostCompetitors;
                    lostCompetitors = temp;
                }

                TimetableCell lastCellWithTime = context.TimetableCells
                                .Include(t => t.Competition)
                                .Where(t => t.Competition.Id == cellWithResults.Competition.Id)
                                .OrderBy(t => t.DateTime).Last();

                int startTime = context.TimetableCells
                    .Include(t => t.Competition)
                    .Where(t => t.Competition.Id == cellWithResults.Competition.Id &&
                                t.DateTime.Hour != 0)
                    .Select(t => t.DateTime.Hour).Min();
                int endTime = context.TimetableCells
                    .Include(t => t.Competition)
                    .Where(t => t.Competition.Id == cellWithResults.Competition.Id &&
                                t.DateTime.Hour != 0)
                    .Select(t => t.DateTime.Hour).Max();

                DateTime dt = GetNextDate(lastCellWithTime, startTime, endTime);

                if (dt == new DateTime())
                {
                    return false;
                }

                int nextStageCellIndex = 0;
                for (int i = 0; i < stagedCells.Count; i += 2)
                {
                    if (stagedCells.ElementAt(i).Id == cellWithResults.Id ||
                        stagedCells.ElementAt(i + 1).Id == cellWithResults.Id)
                    {
                        if (nextStageCells.ElementAt(nextStageCellIndex).Competitors != null &&
                            nextStageCells.ElementAt(nextStageCellIndex).Competitors.Count != 0)
                        {
                            nextStageCells.ElementAt(nextStageCellIndex)
                                .Competitors.AddRange(winCompetitors);

                            nextStageCells.ElementAt(nextStageCellIndex).DateTime = dt;
                        }
                        else
                        {
                            nextStageCells.ElementAt(nextStageCellIndex)
                                .Competitors = winCompetitors;
                        }

                        if (stagedCells.Count == 2)
                        {
                            DateTime secondDt = GetNextDate(nextStageCells.ElementAt(nextStageCellIndex), startTime, endTime);
                            if (nextStageCells.ElementAt(nextStageCellIndex + 1).Competitors != null &&
                            nextStageCells.ElementAt(nextStageCellIndex + 1).Competitors.Count != 0)
                            {
                                nextStageCells.ElementAt(nextStageCellIndex + 1)
                                    .Competitors.AddRange(lostCompetitors);

                                nextStageCells.ElementAt(nextStageCellIndex + 1).DateTime = secondDt;
                            }
                            else
                            {
                                nextStageCells.ElementAt(nextStageCellIndex + 1)
                                    .Competitors = lostCompetitors;
                            }
                        }

                        break;
                    }

                    nextStageCellIndex++;
                }

                context.SaveChanges();
            }

            return true;
        }

        private static void SetFullCells(List<TimetableCell> cells, ServerDbContext context)
        {
            Competition competition = cells.ElementAt(0).Competition;
            int count = cells.Count;

            if (count > 1)
            {
                for (int i = 0; i < count; i += 2)
                {
                    int cellOneTeamsCount = cells.ElementAt(i).Competitors
                        .Select(c => c.Team).Distinct().ToList().Count;
                    int cellTwoTeamsCount = cells.ElementAt(i + 1).Competitors
                        .Select(c => c.Team).Distinct().ToList().Count;

                    TimetableCell temp = new TimetableCell();
                    if (cellOneTeamsCount == 1 && cellTwoTeamsCount == 1)
                    {
                        List<Competitor> fullCompetitors = new List<Competitor>();
                        fullCompetitors.AddRange(cells.ElementAt(i).Competitors);
                        fullCompetitors.AddRange(cells.ElementAt(i + 1).Competitors);

                        temp = new TimetableCell
                        {
                            Competitors = fullCompetitors,
                            Competition = competition,
                            GridStage = 2
                        };
                        cells.Add(temp);

                        context.TimetableCells.Add(temp);
                    }
                    else if (cellTwoTeamsCount == 1)
                    {
                        List<Competitor> halfCompetitors = new List<Competitor>();
                        halfCompetitors.AddRange(cells.ElementAt(i + 1).Competitors);

                        temp = new TimetableCell
                        {
                            Competitors = halfCompetitors,
                            Competition = competition,
                            GridStage = 2
                        };

                        cells.Add(temp);

                        context.TimetableCells.Add(temp);
                    }
                    else if (cellOneTeamsCount == 2 && cellTwoTeamsCount == 2)
                    {
                        temp = new TimetableCell
                        {
                            Competition = competition,
                            GridStage = 2
                        };

                        cells.Add(temp);

                        context.TimetableCells.Add(temp);
                    }

                    context.SaveChanges();

                    if (count == 2)
                    {
                        temp = new TimetableCell
                        {
                            Competition = competition,
                            GridStage = 2
                        };

                        cells.Add(temp);

                        context.TimetableCells.Add(temp);
                    }
                    context.SaveChanges();
                }
            }
        }

        private static DateTime GetNextDate(TimetableCell cell, int startHour, int endHour)
        {
            DateTime dt = new DateTime();
            DateTime newDateTime = cell.DateTime.AddHours(2);
            if (newDateTime < cell.Competition.EndDate.AddDays(1))
            {
                if (newDateTime.AddHours(2).Hour <= endHour)
                {
                    dt = newDateTime;
                }
                else
                {
                    DateTime temp = newDateTime.AddDays(1);
                    temp = new DateTime(temp.Year, temp.Month, temp.Day,
                        startHour, 0, 0);

                    dt = temp;
                }
            }

            return dt;
        }
    }
}
