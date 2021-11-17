using GGBack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public class CompetitionForCreateRequest
    {
        public int Id { get; set; }

        public string Title { get; set; }

        public string Description { get; set; }

        public bool IsOpen { get; set; }

        public Sport Sport { get; set; }

        public string AgeLimit { get; set; }

        public string City { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public bool IsPublic { get; set; }

        public List<Competitor> Competitors { get; set; }

        public User User { get; set; }

        public string StreamUrl { get; set; }

        public int State { get; set; }

        public List<TimetableCell> TimetableCells { get; set; }
    }
}
