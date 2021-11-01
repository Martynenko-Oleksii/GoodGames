using GGBack.Data;
using GGBack.Models;
using Microsoft.AspNetCore.Hosting;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public class PostEmail
    {
        public static string SendInvitation(Post post, 
            ServerDbContext context, IWebHostEnvironment env)
        {
            try
            {
                string fromPost = "goodgames.testing@gmail.com";
                string fromName = context.Users
                    .Where(u => u.Id == post.UserId)
                    .Select(u => u.Login)
                    .FirstOrDefault();

                MailAddress from = new MailAddress(fromPost, fromName);
                MailAddress to = new MailAddress(post.Email);

                MailMessage message = new MailMessage(from, to);

                message.Subject = "GoodGames запрошує вас прийняти участь у змаганні";

                Competition competition =
                    context.Competitions.Find(post.CompetitionId);
                string body = CreateBody(env, 
                    fromName, competition, post.Email);

                if (body == null)
                {
                    return "CreateBody error";
                }

                message.Body = body;
                message.IsBodyHtml = true;
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

        private static string CreateBody(IWebHostEnvironment env, 
            string login, Competition competition, string email)
        {
            string path = env.WebRootPath;
            DirectoryInfo dirInfo = new DirectoryInfo(path);

            if (!dirInfo.Exists)
            {
                return null;
            }

            string bodyFromFile;
            using (FileStream fs = File.OpenRead($"{path}\\mail\\mail.txt"))
            {
                byte[] array = new byte[fs.Length];
                fs.Read(array, 0, array.Length);
                bodyFromFile = Encoding.Default.GetString(array);
            }

            StringBuilder body = new StringBuilder(bodyFromFile);
            body.Replace("{userLogin}", login);
            body.Replace("{competitionTitle}", competition.Title);
            body.Replace("{competitionCity}", competition.City);
            body.Replace("{startDate}", competition.StartDate.ToString("D"));
            body.Replace("{endDate}", competition.EndDate.ToString("D"));
            body.Replace("{compatitionId}", competition.Id.ToString());
            body.Replace("{competitorEmail}", email);

            return body.ToString();
        }
    }

    public class Post
    {
        public int UserId { get; set; }

        public int CompetitionId { get; set; }

        public string Email { get; set; }
    }
}
