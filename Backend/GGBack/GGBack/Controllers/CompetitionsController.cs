using GGBack.Data;
using GGBack.DTO;
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
                .Include(c => c.Sport)
                .Where(c => c.IsPublic)
                .ToListAsync();
        }

        [Route("api/competitions/favourites/{userId}")]
        [HttpGet]
        public ActionResult<IEnumerable<Competition>> GetFavouriteCompetitions(int userId)
        {
            User user = context.Users
                .Include(u => u.Sports)
                .Where(u => u.Id == userId)
                .FirstOrDefault();
            if (user == null)
            {
                return BadRequest("User not found");
            }

            try
            {
                List<Competition> favouriteCompetitions = new List<Competition>();

                foreach (Sport sport in user.Sports)
                {
                    List<Competition> competitionsBySport = context.Competitions
                        .Include(c => c.Sport)
                        .Where(c => c.Sport.Id == sport.Id && c.IsPublic)
                        .ToList();
                    favouriteCompetitions.AddRange(competitionsBySport);
                }

                return favouriteCompetitions;
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
            int creatorId = context.CompetitionCreators
                .Where(cc => cc.CompetitionId == competitionId)
                .Select(cc => cc.CreatorId)
                .FirstOrDefault();
            if (creatorId == 0)
            {
                return BadRequest("Creator's id does not exist");
            }

            User creator = context.Users.Find(creatorId);
            if (creator == null)
            {
                return BadRequest("Creator not found");
            }

            Competition dbCompetition = context.Competitions
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
                User = creator,
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

            CompetitionCreator competitionCreator = context.CompetitionCreators
                .Where(cc => cc.CompetitionId == competitionId)
                .FirstOrDefault();
            if (competitionCreator == null)
            {
                return BadRequest("Creator not defined");
            }

            try
            {
                context.Competitions.Remove(competition);
                context.CompetitionCreators.Remove(competitionCreator);
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

            if (context.Competitions.Any(c => c.Title.Equals(competitionForCreateRequest.Title)))
            {
                return BadRequest("Title already exist");
            }

            if (competitionForCreateRequest.StartDate > competitionForCreateRequest.EndDate)
            {
                return BadRequest("Wrong dates");
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

            User creator = context.Users
                .Include(u => u.Subscription)
                .Where(u => u.Id == competitionForCreateRequest.User.Id)
                .FirstOrDefault();
            try
            {
                competition.Users.Add(creator);
                competition.Sport = context.Sports.Find(competitionForCreateRequest.Sport.Id);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }

            competition.State = 0;

            try
            {
                if (creator.Subscription == null)
                {
                    competition.IsPublic = false;
                }

                context.Competitions.Add(competition);
                context.SaveChanges();
                Competition res = context.Competitions
                    .Include(x => x.Sport)
                    .Include(c => c.RawNewss)
                    .Where(c => c.Title.Equals(competition.Title))
                    .First();

                int creatorId = competitionForCreateRequest.User.Id;
                int competitioId = res.Id;
                context.CompetitionCreators.Add(new CompetitionCreator
                {
                    CompetitionId = competitioId,
                    CreatorId = creatorId
                });
                context.SaveChanges();

                if (competition.IsPublic)
                {
                    RawNews rawNews = await NewsGenerator.SetRawNewsAsync(
                        new string[] { competition.Title },
                        new string[]
                        {
                            competition.Title,
                            competition.Sport.Title,
                            competition.StartDate.ToString("d"),
                            competition.EndDate.ToString("d"),
                            competition.AgeLimit.ToString(),
                            competition.City,
                            competition.IsOpen.ToString()
                        }, res, NewsType.CompetitionCreating);

                    context.RawNewss.Add(rawNews);
                    res.RawNewss.Add(rawNews);
                    await context.SaveChangesAsync();

                    List<string> ids = MessageSender.GetIds(context, res.Sport);
                    MessageDto messageDto = MessageSender.SetMessage(ids, "Створено змагання", competition.Title, competitioId.ToString());
                    bool result = await MessageSender.SendMessage(messageDto);
                }

                return Ok(res);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }
        }

        [Route("api/competitions/addadmin/{competitionId}")]
        [HttpPost]
        public async Task<ActionResult<IEnumerable<User>>> AddAdmin([FromRoute] int competitionId, [FromBody] User user)
        {
            if (user == null)
            {
                return BadRequest("User is null");
            }

            User admin = context.Users
                .Where(u => u.Email.Equals(user.Email))
                .FirstOrDefault();
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
                competition.Users.Add(admin);
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

            return Ok(dbCompetition);
        }
    }
}
