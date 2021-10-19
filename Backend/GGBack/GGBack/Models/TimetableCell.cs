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

        public string State { get; set; }

        //[MaxLength(6)]
        //public int CompetitorOneID { get; set; }
        //
        //[MaxLength(6)]
        //public int CompetitorTwoID { get; set; }

        //[Required]
        public int ResultId { get; set; }
        public Result Result { get; set; }
    }
}
