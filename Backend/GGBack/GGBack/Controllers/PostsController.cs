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

namespace GGBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PostsController : Controller
    {
        private ServerDbContext context;

        public PostsController(ServerDbContext context)
        {
            this.context = context;
        }

        [HttpPost]
        public ActionResult<string> PostNewInvition(Post post)
        {
            if (post.Equals(null))
            {
                return BadRequest("null");
            }

            if (!PostEmail.SendInvitation(post, context))
            {
                return BadRequest("mail not sent");
            }

            return Ok("ok");
        }
    }
}