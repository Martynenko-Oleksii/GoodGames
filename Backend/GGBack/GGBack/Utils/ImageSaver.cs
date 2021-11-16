using Microsoft.AspNetCore.Hosting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public class ImageSaver
    {
        public static string EnsureCorrectFilename(string filename)
        {
            if (filename.Contains("\\"))
            {
                filename = filename.Substring(filename.LastIndexOf("\\") + 1);
            }

            return filename;
        }

        public static string GetPathAndFilename(string filename, IWebHostEnvironment hostingEnvironment)
        {
            return hostingEnvironment.WebRootPath + "\\avatars\\" + filename;
        }
    }
}
