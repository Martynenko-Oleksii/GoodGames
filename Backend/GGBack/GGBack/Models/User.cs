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
        [Key]
        [MaxLength(20)]
        [Required]
        public string Login { get; set; }

        [MaxLength(20)]
        public string Email { get; set; }

        [MaxLength(16)]
        [Required]
        public string Password { get; set; }

        public int SubscriptionId { get; set; }
        public Subscription Subscription { get; set; }

        // Favourite 
        public List<Sport> Sports { get; set; }

        [JsonIgnore]
        public List<Competition> Competitions { get; set; }
    }
}
