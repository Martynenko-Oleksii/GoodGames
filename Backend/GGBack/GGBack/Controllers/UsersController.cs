using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Text.Json;
using GGBack.Utils;

namespace GGBack.Controllers
{
    [ApiController]
    public class UsersController : ControllerBase
    {
        // DbContext context

        private static JsonSerializerOptions options = new JsonSerializerOptions { IgnoreNullValues = true };

        public UsersController()
        {
            // this.context =  context
        }

        /*
        [Route("api/users")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> Get()
        {
            return await context.Users.ToListAsync();
        }
        */

        /*
        [Route("api/users/reg")]
        [HttpPost]
        public async Task<ActionResult<User>> Post(User user)
        {
            if (user == null)
            {
                return BadRequest();
            }

            if (context.Users.Any(e => e.Email == user.Email))
            {
                return BadRequest();
            }

            context.Users.Add(user);
            await context.SaveChangesAsync();

            return Ok(GetWithoutPassword(user));
        }
        */

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
