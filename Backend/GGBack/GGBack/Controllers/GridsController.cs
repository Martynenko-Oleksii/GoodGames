﻿using GGBack.Data;
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

            for (int i = 0; i < count; i++)
            {
                string[] teamsArray = cells.Where(c => c.GridStage == 1)
                        .ElementAt(i).Competitors
                        .Select(c => c.Team).Distinct()
                        .ToArray();

                StringBuilder gridCell = new StringBuilder();
                if (teamsArray.Length == 2)
                {
                    gridCell.Append("[\"" + teamsArray[0] + "\", \"" + teamsArray[1] + "\"]");
                }
                else if (teamsArray.Length == 1)
                {
                    gridCell.Append("[\"" + teamsArray[0] + "\",null]");
                }

                if (i != count - 1)
                {
                    gridCell.Append(",");
                }

                teams.Insert(teams.Length - 2, gridCell);
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
                for (int j = 0; j < count; j++)
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
