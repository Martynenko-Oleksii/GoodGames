using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Models
{
    public class TournamentGrid
    {
        public int Id { get; set; }

        public int Stage { get; set; }

        //Competitors = champions
        public List<Competitor> Competitors { get; set; }

        public List<int> TimetableCellsID { get; set; }
    }
}
