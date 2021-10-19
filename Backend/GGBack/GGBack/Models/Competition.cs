using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GGBack.Models
{
    public class Competition
    {
        public int Id { get; set; }

        [Required]
        public string Title { get; set; }

        public bool IsOpen { get; set; }

        public Sport Sport { get; set; }

        public string AgeLimit { get; set; }

        public string City { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public bool IsPublic { get; set; }

        public List<Competitor> Competitors { get; set; }

        // Owner
        public User User { get; set; }

        [MaxLength(120)]
        public string StreamUrl { get; set; }

        public string State { get; set; } // (“заплановане”, “проходить”, “завершене”)

        //public TournamentGrid TournamentGrid { get; set; }
    }
}
