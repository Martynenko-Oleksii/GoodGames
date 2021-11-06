using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GGBack.Models
{
    public class User
    {
        public int Id { get; set; }

        public string AvatarPath { get; set; }

        public string Login { get; set; }

        public string Email { get; set; }

        public string Password { get; set; }

        public Subscription Subscription { get; set; }

        public List<Sport> Sports { get; set; }

        [JsonIgnore]
        public List<Competition> Competitions { get; set; }

        public string Token { get; set; }
    }
}
