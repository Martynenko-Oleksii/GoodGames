using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Text.Json;
using GGBack.Utils;
using GGBack.Data;
using GGBack.Models;
using Microsoft.EntityFrameworkCore;

namespace GGBack.Controllers
{
    [ApiController]
    public class SportsController : ControllerBase
    {
        private static JsonSerializerOptions options = new JsonSerializerOptions { IgnoreNullValues = true };

        private ServerDbContext context;

        public SportsController(ServerDbContext context)
        {
            this.context = context;
        }

        [Route("api/sports")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Sport>>> Get()
        {
            return await context.Sports.ToListAsync();
        }

        [Route("api/spotrs/add")]
        [HttpPost]
        public async Task<ActionResult<Sport>> PostNewSport(Sport sport)
        {
            if (sport == null)
            {
                return BadRequest("null");
            }

            if (sport.Title == null)
            {
                return BadRequest("no title");
            }

            if (context.Sports.Any(s => s.Title == sport.Title))
            {
                return BadRequest("title collision");
            }

            context.Sports.Add(sport);
            await context.SaveChangesAsync();

            return Ok(sport);
        }

        // GET: SportsController
        public ActionResult Index()
        {
            return View();
        }

        // GET: SportsController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: SportsController/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: SportsController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: SportsController/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: SportsController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: SportsController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: SportsController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }
    }
}
