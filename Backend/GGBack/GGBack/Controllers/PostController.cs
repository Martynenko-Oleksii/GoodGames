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
    [ApiController]
    public class PostController : Controller
    {

        private static JsonSerializerOptions options = new JsonSerializerOptions { IgnoreNullValues = true };

        private ServerDbContext context;

        public PostController(ServerDbContext context)
        {
            this.context = context;
        }

        public struct Invition
        {
            public int inviterId,
                       competitionId;
            public string competitorEmail;
        }

        public bool SendInvition(Invition invition)
        {

            //TODO: implement sending from corporate mail
            string fromPost = "vasyantest1@gmail.com";
            string fromName = "Dummy";

            MailAddress from = new MailAddress(fromPost, fromName);

            //context.Users.Find(inviterId).Email

            MailAddress to = new MailAddress(invition.competitorEmail);
            MailMessage message = new MailMessage(from, to);

            message.Subject = "GoodGames приглашает вас принять участие в соревновании";

            message.Body = $"Пользователь под ником {context.Users.Find(invition.inviterId).Login} приглашает вас" +
                $" присоедениться к турниру {context.Competitions.Find(invition.competitionId).Title}," +
                $" время начала - {context.Competitions.Find(invition.competitionId).StartDate}. /ссылка/";

            message.IsBodyHtml = true;
            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.Credentials = new NetworkCredential(fromPost, "mineworker");
            smtp.EnableSsl = true;
            smtp.Send(message);
            Console.Read();

            return true;
        }
        
        [Route("api/invition/add")]
        [HttpPost]
        public async Task<ActionResult<Invition>> PostNewInvition(Invition invition)
        {
            if (invition.Equals(null))
            {
                return BadRequest("null");
            }

            if (context.Users.Find(invition.inviterId).Equals(null))
            {
                return BadRequest("wrong autor Id");
            }

            if (context.Competitions.Find(invition.competitionId).Equals(null))
            {
                return BadRequest("competition not found");
            }

            if (!SendInvition(invition)) 
            {
                return BadRequest("mail not sent");
            }

            await context.SaveChangesAsync();
            return Ok(invition);
        }
    }
}
