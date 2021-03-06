using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using GGBack.Utils;
using GGBack.Data;
using GGBack.Models;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using System.Net.Mail;
using System.Net;
using Microsoft.AspNetCore.Hosting;

namespace GGBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PostController : Controller
    {
        private ServerDbContext context;
        private readonly IWebHostEnvironment env;

        public PostController(ServerDbContext context, IWebHostEnvironment env)
        {
            this.context = context;
            this.env = env;
        }

        [HttpPost]
        public ActionResult<string> PostNewInvition(Post post)
        {
            if (post.Equals(null))
            {
                return BadRequest("object is null");
            }

            string result = PostEmail.SendInvitation(post, context, env);
            if (!result.Equals("true"))
            {
                return BadRequest(result);
            }

            return Ok("ok");
        }
    }
}