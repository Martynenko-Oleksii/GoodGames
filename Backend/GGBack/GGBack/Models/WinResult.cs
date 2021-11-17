using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GGBack.Models
{
    public class WinResult
    {
        public int Id { get; set; }

        public string TeamOne { get; set; }

        public string TeamTwo { get; set; }

        public string Score { get; set; }

        public int TimetableCellId { get; set; }
        [JsonIgnore]
        public TimetableCell TimetableCell { get; set; }
    }
}
