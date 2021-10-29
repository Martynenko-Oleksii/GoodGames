using GGBack.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public class PostEmail
    {
        public static string SendInvitation(Post post, ServerDbContext context)
        {
            try
            {
                string fromPost = "goodgames.testing@gmail.com";
                string fromName = context.Users
                    .Where(u => u.Id == post.UserId)
                    .Select(u => u.Login)
                    .FirstOrDefault();
                //string fromName = "Dummy";

                MailAddress from = new MailAddress(fromPost, fromName);

                MailAddress to = new MailAddress(post.Email);
                MailMessage message = new MailMessage(from, to);

                message.Subject = "GoodGames приглашает вас принять участие в соревновании";

                message.Body = $"Пользователь под ником {fromName} приглашает вас" +
                    $" присоедениться к турниру {context.Competitions.Find(post.CompetitionId).Title}," +
                    $" время начала - {context.Competitions.Find(post.CompetitionId).StartDate}. /ссылка/";

                message.IsBodyHtml = false;
                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.Credentials = new NetworkCredential(fromPost, "frick4224");
                smtp.EnableSsl = true;
                smtp.Send(message);
            }
            catch (Exception ex)
            {
                return ex.Message + "\n" + ex.InnerException;
            }

            return "true";
        }
    }

    public class Post
    {
        public int UserId { get; set; }

        public int CompetitionId { get; set; }

        public string Email { get; set; }
    }
}
