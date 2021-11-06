using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GGBack.Models
{
    public class Sport
    {
        public int Id { get; set; }

        public string Title { get; set; }

        public int MinCompetitorsCount { get; set; }

        public bool HasTeam { get; set; }

        public int MinTeamsCount { get; set; }

        public int TeamSize { get; set; }

        public bool HasGrid { get; set; }

        // Followers
        [JsonIgnore]
        public List<User> Users { get; set; }
    }
}
