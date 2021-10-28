using GGBack.Models;
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
            List<TimetableCell> timetableCells = new List<TimetableCell>();

            if (teams.Count % 4 == 0)
            {
                //TODO
            }
            else
            {
                List<DateTime> times = new List<DateTime>();
                string[] teamsArray = teams.ToArray();
                for (int i = 0; i < teams.Count; i += 2)
                {
                    List<Competitor> competitorsPerTwoTeams = competitors
                        .Where(c =>
                            c.Team.Equals(teamsArray[i]) ||
                            c.Team.Equals(teamsArray[i + 1]))
                        .ToList();

                    DateTime dt = new DateTime();

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

                    TimetableCell ttCell = new TimetableCell
                    {
                        DateTime = dt,
                        Competitors = competitorsPerTwoTeams,
                        Competition = competition,
                        GridStage = 1
                    };

                    timetableCells.Add(ttCell);
                }
            }

            return timetableCells;
        }
    }
}
