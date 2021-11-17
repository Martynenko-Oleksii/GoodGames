using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.DTO
{
    public class MessageDto
    {
        public NotificationDto Notification { get; set; }

        public List<string> Registration_ids { get; set; }
    }
}
