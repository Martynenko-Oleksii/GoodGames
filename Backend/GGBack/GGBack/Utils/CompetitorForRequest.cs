using GGBack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public class CompetitorForRequest
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public string Email { get; set; }

        public int Age { get; set; }

        public char Gender { get; set; }

        public int Weigth { get; set; }

        public string HealthState { get; set; }

        public string Team { get; set; }

        public List<Competition> Competitions { get; set; }
    }
}
