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
using System.Net.Http.Headers;
using System.IO;
using Microsoft.AspNetCore.Hosting;
using GGBack.DTO;

namespace GGBack.Controllers
{
    [ApiController]
    public class UsersController : ControllerBase
    {
        private ServerDbContext context;
        private readonly IWebHostEnvironment env;

        public UsersController(ServerDbContext context, IWebHostEnvironment env)
        {
            this.context = context;
            this.env = env;
        }

        [Route("api/users")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> Get()
        {
            return await context.Users.ToListAsync();
        }

        [Route("api/users/{userId}")]
        [HttpGet]
        public async Task<ActionResult<User>> Get(int userId)
        {
            try
            {
                return await context.Users
                    .Include(u => u.Subscription)
                    .Include(u => u.Sports)
                    .Where(u => u.Id == userId)
                    .Select(u => new User
                    {
                        Id = u.Id,
                        AvatarPath = u.AvatarPath,
                        Login = u.Login,
                        Email = u.Email,
                        Subscription = u.Subscription,
                        Sports = u.Sports
                    })
                    .FirstOrDefaultAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }
        }

        [Route("api/admins/{competitionId}")]
        [HttpGet]
        public ActionResult<IEnumerable<User>> GetAdmins(int competitionId)
        {
            try
            {
                Competition competition = context.Competitions
                    .Include(c => c.Users)
                    .Where(c => c.Id == competitionId)
                    .FirstOrDefault();
                if (competition == null)
                {
                    return BadRequest("Conpetition not found");
                }

                return Ok(competition.Users
                    .Select(u => new User
                    {
                        Id = u.Id,
                        Login = u.Login,
                        AvatarPath = u.AvatarPath
                    }));
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }
        }

        [Route("api/users/reg")]
        [HttpPost]
        public async Task<ActionResult<User>> PostForRegistration(User user)
        {
            if (user == null)
            {
                return BadRequest("null");
            }

            if (context.Users.Any(u => u.Email == user.Email))
            {
                return BadRequest("email");
            }

            if (context.Users.Any(e => e.Login == user.Login))
            {
                return BadRequest("login");
            }

            context.Users.Add(user);
            await context.SaveChangesAsync();

            return Ok(user);
        }

        [Route("api/users/login")]
        [HttpPost]
        public ActionResult<User> PostForLogin(User user)
        {
            if (user == null)
            {
                return BadRequest("null");
            }

            User findedUser =  context.Users
                .Include(u => u.Subscription)
                .Include(u => u.Sports)
                .Where(u => u.Email == user.Email)
                .First();

            if (findedUser == null)
            {
                return NotFound();
            }
            else if (!user.Password.Equals(findedUser.Password))
            {
                return BadRequest("password");
            }

            return Ok(findedUser);
        }

        [Route("api/users/change/image/{userId}")]
        [HttpPost]
        public async Task<ActionResult<string>> UpdateProfileImage([FromRoute] int userId, [FromForm(Name = "image")] IFormFile image)
        {
            string filename;
            string imagePath;
            try
            {
                if (userId == 0)
                {
                    return BadRequest(userId);
                }

                if (image == null)
                {
                    return BadRequest("Image is null");
                }

                filename = ContentDispositionHeaderValue
                    .Parse(image.ContentDisposition)
                    .FileName.Trim('"');

                filename = ImageSaver.EnsureCorrectFilename(filename);

                imagePath = ImageSaver.GetPathAndFilename(filename, env);
                using (FileStream output = System.IO.File.Create(imagePath))
                {
                    await image.CopyToAsync(output);
                }

                User dbUser = context.Users.Find(userId);
                dbUser.AvatarPath = $"/avatars/{filename}";
                await context.SaveChangesAsync();

                imagePath = dbUser.AvatarPath;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }

            return Ok(imagePath);
        }

        [Route("api/users/change/deleteimage/{userId}")]
        [HttpGet]
        public async Task<ActionResult> DeleteProfileImage(int userId)
        {
            try
            {
                User dbUser = context.Users.Find(userId);
                string avatarPath = dbUser.AvatarPath;
                string path = 
                    $"C:\\HostingSpaces\\user16437\\goodgames.kh.ua\\wwwroot\\avatars\\{avatarPath.Substring(avatarPath.LastIndexOf("/") + 1)}";
                System.IO.File.Delete(path);

                dbUser.AvatarPath = null;
                await context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }

            return Ok();
        }

        [Route("api/users/change/login")]
        [HttpPost]
        public async Task<ActionResult<User>> UpdateLogin(User user)
        {
            User dbUser = context.Users.Find(user.Id);

            if (!dbUser.Login.Equals(user.Login))
            {
                dbUser.Login = user.Login;
            }
            else
            {
                return BadRequest("Logins are the same");
            }

            await context.SaveChangesAsync();

            return Ok(dbUser);
        }

        [Route("api/users/change/email")]
        [HttpPost]
        public async Task<ActionResult<User>> UpdateEmail(User user)
        {
            if (context.Users.Any(u => u.Email == user.Email))
            {
                return BadRequest("email");
            }

            User dbUser = context.Users.Find(user.Id);

            if (!dbUser.Email.Equals(user.Email))
            {
                dbUser.Email = user.Email;
            }
            else
            {
                return BadRequest("Emails are the same");
            }

            await context.SaveChangesAsync();

            return Ok(dbUser);
        }

        [Route("api/users/change/password")]
        [HttpPost]
        public async Task<ActionResult<User>> UpdatePassword(User user)
        {
            User dbUser = context.Users.Find(user.Id);

            if (!dbUser.Password.Equals(user.Password))
            {
                dbUser.Password = user.Password;
            }
            else
            {
                return BadRequest("Passwords are the same");
            }

            await context.SaveChangesAsync();

            return Ok(dbUser);
        }

        [Route("api/users/token")]
        [HttpPost]
        public async Task<ActionResult<User>> GetToken(User user)
        {
            User dbUser = context.Users
                .Where(u => u.Email.Equals(user.Email))
                .FirstOrDefault();

            if (dbUser == null)
            {
                return BadRequest("Wrong email");
            }

            Random rand = new Random();
            int token = rand.Next(100000, 999999);
            dbUser.Token = token.ToString();
            await context.SaveChangesAsync();

            string result = PostEmail.SendToken(dbUser.Token, dbUser.Email);
            if (!result.Equals("true"))
            {
                return BadRequest(result);
            }

            return Ok(new User { Token = dbUser.Token });
        }

        [Route("api/users/change/forgotten")]
        [HttpPost]
        public async Task<ActionResult<User>> ChangeForgottenPassword(ForgottenPassword fp)
        {
            User dbUser = context.Users
                .Where(u => u.Email.Equals(fp.Email))
                .FirstOrDefault();

            if (dbUser == null)
            {
                return BadRequest("Wrong email");
            }

            if (!dbUser.Token.Equals(fp.Token))
            {
                return BadRequest("Wrong token");
            }

            dbUser.Password = fp.NewPassword;
            dbUser.Token = null;
            await context.SaveChangesAsync();

            return Ok(dbUser);
        }

        [Route("api/users/newstoken")]
        [HttpPost]
        public async Task<ActionResult<NewsToken>> PostNewsToken(NewsToken token)
        {
            if (token == null)
            {
                return BadRequest("null");
            }

            User dbUser = context.Users.Find(token.UserId);
            if (dbUser == null)
            {
                return BadRequest("User Not Found");
            }

            dbUser.DeviceToken = token.Token;
            await context.SaveChangesAsync();

            return Ok(token);
        }
    }
}
