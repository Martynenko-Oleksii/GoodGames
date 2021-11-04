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
    public class UsersController : ControllerBase
    {
        private static JsonSerializerOptions options = new JsonSerializerOptions { IgnoreNullValues = true };

        private ServerDbContext context;

        public UsersController(ServerDbContext context)
        {
            this.context = context;
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
            User dbUser = context.Users.Find(user.Id);

            if (!dbUser.Email.Equals(user.Email))
            {
                dbUser.Email = user.Email;
            }
            else
            {
                return BadRequest("Passwords are the same");
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
        public async Task<ActionResult> GetToken(User user)
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

            return Ok();
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
    }
}
