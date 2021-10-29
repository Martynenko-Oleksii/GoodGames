using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GGBack.Models
{
    public class Subscription
    {
        public int Id { get; set; }

        public int Level { get; set; }

        public DateTime Start { get; set; }

        public DateTime End { get; set; }

        [JsonIgnore]
        public List<User> Users { get; set; }
    }
}
