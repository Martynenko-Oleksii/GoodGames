using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Models
{
    public class RawNews
    {
        public int Id { get; set; }

        public string HeaderData { get; set; }

        public string BodyData { get; set; }
    
        public string TemplatePath { get; set; }

        public DateTime Date { get; set; }

        public Competition Competition { get; set; }
    }
}
