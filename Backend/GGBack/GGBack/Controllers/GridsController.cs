using GGBack.Data;
using GGBack.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GGBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GridsController : ControllerBase
    {
        private ServerDbContext context;

        public GridsController(ServerDbContext context)
        {
            this.context = context;
        }

        [HttpGet("{competitionId}")]
        public ActionResult<string> Get(int competitionId)
        {
            List<TimetableCell> cells = context.TimetableCells
                .Include(t => t.Competitors)
                .Include(t => t.Competition)
                .Include(t => t.WinResult)
                .Where(t => t.Competition.Id == competitionId)
                .ToList();

            StringBuilder teams = new StringBuilder("\"teams\":[],");
            StringBuilder results = new StringBuilder("\"results\":[]");

            int count = cells.Where(c => c.GridStage == 1).ToList().Count;

            int cellsCount = 2;
            while (count > cellsCount)
            {
                cellsCount *= 2;
            }

            for (int i = 0; i < cellsCount; i++)
            {
                if (i < count)
                {
                    string[] teamsArray = cells.Where(c => c.GridStage == 1)
                        .ElementAt(i).Competitors
                        .Select(c => c.Team).Distinct()
                        .ToArray();

                    string gridCell = "[\"" + teamsArray[0] + "\", \"" + teamsArray[1] + "\"]";

                    if (i != count - 1)
                    {
                        gridCell += ",";
                    }

                    teams.Insert(teams.Length - 2, gridCell);
                }
                else
                {
                    teams.Insert(teams.Length - 2, ",[null,null]");
                }
            }
            int stagesCount = cells
                .Select(c => c.GridStage)
                .Distinct().ToList().Count;

            for (int i = 1; i <= stagesCount; i++)
            {
                List<TimetableCell> cellsByStage = cells
                    .Where(c => c.GridStage == i).ToList();

                StringBuilder stageResults = new StringBuilder("[]");

                if (i != stagesCount)
                {
                    stageResults.Append(",");
                }

                int cellsByStageCount = cellsByStage.Count;
                for (int j = 0; j < cellsCount; j++)
                {
                    StringBuilder result = new StringBuilder();
                    if (j < cellsByStageCount)
                    {
                        if (cellsByStage.ElementAt(j).WinResult != null)
                        {
                            result.Append($"[{cellsByStage.ElementAt(j).WinResult.Score}],");

                            if (j != cellsByStage.Count - 1)
                            {
                                result.Append(",");
                            }

                            stageResults.Insert(stageResults.Length - 1, result);
                        }
                    }
                }

                if (stageResults.Length > 0)
                    results.Insert(results.Length - 1, stageResults);
            }

            StringBuilder tournamentGrid = new StringBuilder();

            return tournamentGrid.Append(teams).Append(results).ToString();
        }
    }
}
