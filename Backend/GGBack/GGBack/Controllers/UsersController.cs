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
    }
}
