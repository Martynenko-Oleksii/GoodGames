using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.DTO
{
    public class NotificationDto
    {
        public string title { get; set; }

        public string body { get; set; }

        public string icon { get; set; }

        public string click_action { get; set; }
    }
}
