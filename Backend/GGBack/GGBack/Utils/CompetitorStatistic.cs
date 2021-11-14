using GGBack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public class CompetitorStatistic
    {
        public static int GetWinCount(List<Competitor> competitorsByOneEmail)
        {
            int winCount = 0;
            foreach (Competitor competitor in competitorsByOneEmail)
            {
                int finalStage = competitor.Competitions.ElementAt(0).TimetableCells
                    .Select(tc => tc.GridStage)
                    .Max();
                TimetableCell finalCell = competitor.Competitions.ElementAt(0).TimetableCells
                    .Where(tc => tc.GridStage == finalStage).FirstOrDefault();
                if (finalCell == null)
                {
                    return 0;
                }

                if (finalCell.WinResult != null)
                {
                    if (competitor.Team.Equals(finalCell.WinResult.TeamOne) ||
                        competitor.Team.Equals(finalCell.WinResult.TeamTwo))
                    {
                        string[] results = finalCell.WinResult.Score.Split(',');

                        if (Int32.Parse(results[0]) > Int32.Parse(results[1]) &&
                            competitor.Team.Equals(finalCell.WinResult.TeamOne))
                        {
                            winCount++;
                        }
                        else if (Int32.Parse(results[0]) < Int32.Parse(results[1]) &&
                            competitor.Team.Equals(finalCell.WinResult.TeamTwo))
                        {
                            winCount++;
                        }
                    }
                }
            }

            return winCount;
        }
    }
}
