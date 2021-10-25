using GGBack.Data;
using GGBack.Models;
using GGBack.Utils;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace GGBack.Controllers
{
    [ApiController]
    public class SubsController : ControllerBase
    {
        private ServerDbContext context;

        public SubsController(ServerDbContext context)
        {
            this.context = context;
        }

        [Route("api/subs")]
        [HttpPost]
        public async Task<ActionResult<string>> CheckPayment([FromForm] SubResult result)
        {
            const string privateKey = "sandbox_zUieTCma1qGVtkevC26yIzKJ4aRi5oIZzWVIufmg";
            string data = result.Data;
            string signature = result.Signature;

            string createdSignature;
            using (SHA1 sha1Hash = SHA1.Create())
            {
                byte[] sourceBytes = Encoding.UTF8.GetBytes(privateKey + data + privateKey);
                byte[] hashBytes = sha1Hash.ComputeHash(sourceBytes);
                createdSignature = Convert.ToBase64String(hashBytes);
            }

            if (createdSignature.Equals(signature))
            {
                return Ok();
            }
            else
            {
                return BadRequest();
            }
        }

        [Route("api/subs/{userId}")]
        [HttpGet]
        public async Task<ActionResult<string>> GetSub(int userId)
        {
            try
            {
                DateTime start = DateTime.UtcNow;
                DateTime end = start.AddDays(30);

                Subscription sub = new Subscription
                {
                    Level = 1,
                    Start = start,
                    End = end
                };

                context.Subscriptions.Add(sub);

                User dbUser = context.Users
                    .Include(u => u.Subscription)
                    .Where(u => u.Id == userId)
                    .FirstOrDefault();

                if (dbUser == null) return NotFound("user");

                context.Subscriptions.Remove(dbUser?.Subscription);
                dbUser.Subscription = sub;
                await context.SaveChangesAsync();

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }
        }

        /*
        [Route("api/subs")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Subscription>>> Get()
        {
            return await context.Subscriptions.ToListAsync();
        }
        */
    }
}
