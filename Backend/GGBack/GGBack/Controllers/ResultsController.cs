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

            TimetableCell cell = context.TimetableCells
                .Include(c => c.Competitors)
                .Include(c => c.Competition)
                    .ThenInclude(c => c.RawNewss)
                .Include(c => c.WinResult)
                .Where(c => c.Id == winResult.Id)
                .ToList().FirstOrDefault();

            if (cell == null)
            {
                return BadRequest("Wrong id");
            }

            if (cell.WinResult == null)
            {
                WinResult actualResult = new WinResult
                {
                    TeamOne = winResult.TeamOne,
                    TeamTwo = winResult.TeamTwo,
                    Score = winResult.Score
                };
                context.WinResults.Add(actualResult);
                cell.WinResult = actualResult;
            }
            else
            {
                cell.WinResult.TeamOne = winResult.TeamOne;
                cell.WinResult.TeamTwo = winResult.TeamTwo;
                cell.WinResult.Score = winResult.Score;
            }
            context.SaveChanges();

            try
            {
                bool isGenerated = await ScheduleGenerator.GenerateForNewResults(cell, 
                    context, cell.Competition);

                if (!isGenerated)
                {
                    return BadRequest("Generating error");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }

            return Ok();
        }
    }
}
