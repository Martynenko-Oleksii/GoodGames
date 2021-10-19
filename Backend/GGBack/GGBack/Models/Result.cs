using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Models
{
    public class Result
    {
        public int Id { get; set; }

        public List<Competitor> Competitors { get; set; }

        //public int CompetitorTwoID { get; set; }

        public Competition Competition { get; set; }

        public string Text { get; set; }
    }
}
