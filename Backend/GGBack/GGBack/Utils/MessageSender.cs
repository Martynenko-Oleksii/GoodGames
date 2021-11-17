using GGBack.Data;
using GGBack.DTO;
using GGBack.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public class MessageSender
    {
        private const string API_KEY = 
            "AAAAM9P_Hbw:APA91bE_Llv8if5EKR-qOtzttBMfjJ_jjMe6kqs-r-Hkxyf89lqa4e_a3Eig8Sqxk1ZfFuQmmbSDSTJwi9-xecI0QKbUnmokg4jhCjfDOVKbGkOe5j7nPTsIcaV_0YorJnKwy8Smzg0w";
        private const string URL = "https://fcm.googleapis.com/fcm/send";
        private const string ICON_URL = "https://www.goodgames.kh.ua/news_templates/message.jpg";
        private const string BASE_ACTION_URL = "https://www.goodgames.kh.ua/game/?id=";

        public static async Task<bool> SendMessage(MessageDto message)
        {
            HttpClient client = GetClient();

            var response = await client.PostAsync(URL, 
                new StringContent(JsonSerializer.Serialize(message), Encoding.UTF8, "application/json"));

            if (response.StatusCode != HttpStatusCode.OK)
            {
                return false;
            }

            return true;
        }

        public static MessageDto SetMessage(List<string> ids, string title, string body, string competitionId)
        {
            return new MessageDto
            {
                Notification = new NotificationDto
                {
                    Title = title,
                    Body = body,
                    Icon = ICON_URL,
                    Click_action = BASE_ACTION_URL + competitionId
                },
                Registration_ids = ids
            };
        }

        public static List<string> GetIds(ServerDbContext dbContext, Sport sport)
        {
            List<User> users = GetUsers(dbContext, sport);

            List<string> ids = new List<string>();
            foreach (User user in users)
            {
                if (user.DeviceToken != null && user.DeviceToken.Length > 0)
                {
                    ids.Add(user.DeviceToken);
                }
            }

            return ids;
        }

        private static List<User> GetUsers(ServerDbContext dbContext, Sport sport)
        {
            return dbContext.Users
                .Include(x => x.Sports)
                .Where(x => x.Sports.Contains(sport))
                .ToList();
        }

        private static HttpClient GetClient()
        {
            HttpClient client = new HttpClient();
            client.DefaultRequestHeaders.Add("Accept", "application/json");
            client.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", $"key={API_KEY}");
            return client;
        }
    }
}
