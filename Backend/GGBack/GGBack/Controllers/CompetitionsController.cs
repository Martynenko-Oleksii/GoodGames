using GGBack.Data;
using GGBack.Models;
using GGBack.Utils;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;

namespace GGBack.Controllers
{
    [ApiController]
    public class CompetitionsController : ControllerBase
    {
        private ServerDbContext context;

        public CompetitionsController(ServerDbContext context)
        {
            this.context = context;
        }

        [Route("api/competitions")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Competition>>> Get()
        {
            return await context.Competitions
                .Include(c => c.Sport).ToListAsync();
        }

        [Route("api/competitions/favourites")]
        [HttpPost]
        public async Task<ActionResult<IEnumerable<Competition>>> GetFavouriteCompetitions(User user)
        {
            if (user == null)
            {
                return BadRequest("User is null");
            }

            try
            {
                return await context.Competitions
                    .Include(c => c.Sport)
                    .Where(c =>
                        user.Sports.Find(s => s.Id == c.Sport.Id) != null)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }
        }

        [Route("api/competitions/{competitionId}")]
        [HttpGet]
        public ActionResult<IEnumerable<CompetitionForCreateRequest>> GetCompetition(int competitionId)
        {
            //TODO: add Users to response
            Competition dbCompetition = context.Competitions
                    .Include(c => c.Users)
                    .Include(c => c.Sport)
                    .Include(c => c.Competitors)
                    .Where(c => c.Id == competitionId)
                    .FirstOrDefault();

            CompetitionForCreateRequest result = new CompetitionForCreateRequest
            {
                Id = dbCompetition.Id,
                Title = dbCompetition.Title,
                Description = dbCompetition.Description,
                IsOpen = dbCompetition.IsOpen,
                Sport = dbCompetition.Sport,
                AgeLimit = dbCompetition.AgeLimit,
                City = dbCompetition.City,
                StartDate = dbCompetition.StartDate,
                EndDate = dbCompetition.EndDate,
                IsPublic = dbCompetition.IsPublic,
                Competitors = dbCompetition.Competitors,
                User = dbCompetition.Users.ElementAt(0),
                StreamUrl = dbCompetition.StreamUrl,
                State = dbCompetition.State,
            };

            List<CompetitionForCreateRequest> results = 
                new List<CompetitionForCreateRequest>();
            results.Add(result);

            return results;
        }

        [Route("api/competitions/users/{userId}")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Competition>>> GetCompetitions(int userId)
        {
            try
            {
                User dbUser = context.Users.Find(userId);

                if (dbUser == null)
                {
                    return BadRequest("Wrong user id");
                }

                return await context.Competitions
                    .Include(c => c.Users)
                    .Include(c => c.Sport)
                    .Where(c => c.Users.Contains(dbUser))
                    .Select(c => new Competition
                    {
                        Id = c.Id,
                        Title = c.Title,
                        StartDate = c.StartDate,
                        EndDate = c.EndDate,
                        State = c.State,
                        Sport  = c.Sport
                    })
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }
        }

        [Route("api/competitions/delete/{competitionId}")]
        [HttpGet]
        public async Task<ActionResult<Competition>> Get(int competitionId)
        {
            if (competitionId == 0)
            {
                return BadRequest("invalid competition id");
            }

            Competition competition = context.Competitions
                .Include(c => c.Competitors)
                .Include(c => c.TimetableCells)
                    .ThenInclude(t => t.Competitors)
                .Where(c => c.Id == competitionId)
                .FirstOrDefault();

            if (competition == null)
            {
                return BadRequest("Competition does not exist");
            }

            try
            {
                competition.Competitors = null;
                foreach (TimetableCell cell in competition.TimetableCells)
                {
                    cell.Competitors = null;
                }
                context.SaveChanges();
                context.TimetableCells.RemoveRange(competition.TimetableCells);
                context.Competitions.Remove(competition);
                await context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }

            return Ok(competition);
        }

        [Route("api/competitions/create")]
        [HttpPost]
        public async Task<ActionResult<IEnumerable<User>>> PostNewCompetition(CompetitionForCreateRequest competitionForCreateRequest)
        {
            if (competitionForCreateRequest == null)
            {
                return BadRequest("Competition is null");
            }

            Competition competition = new Competition
            {
                Title = competitionForCreateRequest.Title,
                Description = competitionForCreateRequest.Description,
                IsOpen = competitionForCreateRequest.IsOpen,
                AgeLimit = competitionForCreateRequest.AgeLimit,
                City = competitionForCreateRequest.City,
                StartDate = competitionForCreateRequest.StartDate,
                EndDate = competitionForCreateRequest.EndDate,
                IsPublic = competitionForCreateRequest.IsPublic,
                Users = new List<User>()
            };

            try
            {
                competition.Users.Add(context.Users.Find(competitionForCreateRequest.User.Id));
                competition.Sport = context.Sports.Find(competitionForCreateRequest.Sport.Id);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }

            competition.State = 0;

            Competition res = new Competition 
            { 
                Id = competition.Id, 
                Title = competition.Title,
                StartDate = competition.StartDate
            };

            try
            {
                context.Competitions.Add(competition);
                await context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.InnerException);
            }

            return Ok(res);
        }

        [Route("api/competitions/addadmin/{competitionId}")]
        [HttpPost]
        public async Task<ActionResult<IEnumerable<User>>> AddAdmin([FromRoute] int competitionId, [FromBody] User user)
        {
            if (user == null)
            {
                return BadRequest("User is null");
            }

            User admin = context.Users.Find(user.Id);
            if (admin == null)
            {
                return BadRequest("User not found");
            }

            Competition competition = context.Competitions
                .Include(c => c.Users)
                .Where(c => c.Id == competitionId)
                .FirstOrDefault();
            if (competition == null)
            {
                return BadRequest("Competition not found");
            }

            User addedAdmin = competition.Users.Find(u => u.Id == admin.Id);
            if (addedAdmin != null)
            {
                return BadRequest("Admin already added");
            }

            try
            {
                competition.Users.Add(user);
                await context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }

            return Ok(competition.Users);
        }

        [Route("api/competitions/deleteadmin/{competitionId}")]
        [HttpPost]
        public async Task<ActionResult<IEnumerable<User>>> DeleteAdmin([FromRoute] int competitionId, [FromBody] User user)
        {
            if (user == null)
            {
                return BadRequest("User is null");
            }

            Competition competition = context.Competitions
                .Include(c => c.Users)
                .Where(c => c.Id == competitionId)
                .FirstOrDefault();
            if (competition == null)
            {
                return BadRequest("Competition not found");
            }

            try
            {
                User removeAdmin = competition.Users.Find(u => u.Id == user.Id);
                if (removeAdmin == null)
                {
                    return BadRequest("Admin not found");
                }

                competition.Users.Remove(removeAdmin);
                await context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }

            return Ok(competition.Users);
        }

        [Route("api/competitions/addstream")]
        [HttpPost]
        public async Task<ActionResult<Competition>> AddStreamUrl(Competition competition)
        {
            if (competition == null)
            {
                return BadRequest("User is null");
            }

            Competition dbCompetition = context.Competitions.Find(competition.Id);
            if (dbCompetition == null)
            {
                return BadRequest("Competition not found");
            }

            try
            {
                dbCompetition.StreamUrl = competition.StreamUrl;
                await context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }

            return Ok(competition.Users);
        }
    }
}
