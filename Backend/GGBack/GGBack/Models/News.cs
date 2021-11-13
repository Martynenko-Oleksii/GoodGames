using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Models
{
    public class News
    {
        public int Id { get; set; }

        public string Header { get; set; }

        public string Body { get; set; }

        public DateTime Date { get; set; }
    
        public string CompetitionTitle { get; set; }

        public int CompetitionId { get; set; }
    }
}
