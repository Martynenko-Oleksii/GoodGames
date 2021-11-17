using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.DTO
{
    public class NotificationDto
    {
        public string Title { get; set; }

        public string Body { get; set; }

        public string Icon { get; set; }

        public string Click_action { get; set; }
    }
}
