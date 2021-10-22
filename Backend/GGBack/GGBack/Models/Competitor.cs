using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GGBack.Models
{
    public class Competitor
    {
        public int Id { get; set; }

        [MaxLength(30)]
        public string Name { get; set; }

        [MaxLength(20)]
        public string Email { get; set; }

        public int Age { get; set; }

        public char Gender { get; set; }

        public int Weigth { get; set; }

        public string HealthState { get; set; }

        [MaxLength(30)]
        public string Team { get; set; }

        public List<Competition> Competitions { get; set; }
    }
}
