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

            for (int i = 0; i < cells.Where(c => c.GridStage == 1).ToList().Count; i++)
            {
                string[] teamsArray = cells.Where(c => c.GridStage == 1)
                    .ElementAt(i).Competitors
                    .Select(c => c.Team).Distinct()
                    .ToArray();

                string gridCell = "[\"" + teamsArray[0] + "\", " + teamsArray[1] + "\"],";
                teams.Insert(teams.Length-1, gridCell);
            }

            for (int i = 0; i < cells.Count; i++)
            {
                if (cells.ElementAt(i).WinResult != null)
                {
                    //TODO
                }
            }

            StringBuilder tournamentGrid = new StringBuilder();

            return tournamentGrid.Append(teams).Append(results).ToString();
        }
    }
}
