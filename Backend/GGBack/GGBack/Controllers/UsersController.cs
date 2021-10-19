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

        [Route("api/users/reg")]
        [HttpPost]
        public async Task<ActionResult<User>> PostForRegistration(User user)
        {
            if (user == null)
            {
                return BadRequest("null");
            }

            if (context.Users.Any(e => e.Email == user.Email))
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
        public async Task<ActionResult<User>> PostForLogin(User user)
        {
            if (user == null)
            {
                return BadRequest("null");
            }

            User findedUser = context.Users.Find(user.Email);

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

        /*
        private User GetWithoutPassword(User user)
        {
            string jsonWithoutPassword = OwnJsonSerializer
                .SerializeWithoutProperties<User>(user, "Password");

            return JsonSerializer.Deserialize<User>(jsonWithoutPassword, options);
        }
        */
    }
}
