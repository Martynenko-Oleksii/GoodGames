using GGBack.Data;
using GGBack.Models;
using GGBack.Utils;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ResultsController : ControllerBase
    {
        ServerDbContext context;

        public ResultsController(ServerDbContext context)
        {
            this.context = context;
        }

        [HttpPost]
        public async Task<ActionResult> Post(WinResult winResult)
        {
            if (winResult == null)
            {
                return BadRequest();
            }

            TimetableCell cell = context.TimetableCells.Find(winResult.Id);

            if (cell == null)
            {
                return BadRequest("Wrong id");
            }

            WinResult actualResult = new WinResult
            {
                Score = winResult.Score
            };
            context.WinResults.Add(actualResult);
            cell.WinResult = actualResult;
            await context.SaveChangesAsync();

            bool isGenerated = ScheduleGenerator.GenerateForNewResults(cell);

            if (!isGenerated)
            {
                return BadRequest("Generating error");
            }

            return Ok();
        }
    }
}
