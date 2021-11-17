using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.DTO
{
    public class MessageDto
    {
        public NotificationDto notification { get; set; }

        public List<string> registration_ids { get; set; }
    }
}
