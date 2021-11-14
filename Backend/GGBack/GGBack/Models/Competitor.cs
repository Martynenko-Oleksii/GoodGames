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

        public string Name { get; set; }

        public string Email { get; set; }

        public int Age { get; set; }

        public char Gender { get; set; }

        public int Weigth { get; set; }

        public string HealthState { get; set; }

        public string Team { get; set; }

        [JsonIgnore]
        public Competition Competition { get; set; }

        [JsonIgnore]
        public List<TimetableCell> TimetableCells { get; set; }
    }
}
