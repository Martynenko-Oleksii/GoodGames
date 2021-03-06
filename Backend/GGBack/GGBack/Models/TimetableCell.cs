using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Models
{
    public class TimetableCell
    {
        public int Id { get; set; }

        public DateTime DateTime { get; set; }

        public List<Competitor> Competitors { get; set; }

        public Competition Competition { get; set; }

        public int GridStage { get; set; }

        public WinResult WinResult { get; set; }
    }
}
