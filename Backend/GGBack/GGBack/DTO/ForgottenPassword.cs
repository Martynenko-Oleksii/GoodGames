using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public class ForgottenPassword
    {
        public string Token { get; set; }

        public string Email { get; set; }

        public string NewPassword { get; set; }
    }
}
