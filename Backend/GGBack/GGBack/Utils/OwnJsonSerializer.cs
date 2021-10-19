using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public static class OwnJsonSerializer
    {
        public static string SerializeWithoutProperties<T>(T type, params string[] properties)
        {
            StringBuilder result = new StringBuilder("{");

            foreach (PropertyInfo pi in typeof(T).GetProperties())
            {
                if (Array.IndexOf(properties, pi.Name) < 0)
                {
                    result.Append($"\"{pi.Name}\":");

                    if (pi.PropertyType.Name.Equals("String") ||
                        pi.PropertyType.Name.Equals("Char"))
                    {
                        result.Append($"\"{pi.GetValue(type)}\",");
                    }
                    else
                    {
                        result.Append($"{pi.GetValue(type)},");
                    }
                }
            }

            result.Replace(',', '}', result.Length - 1, 1);

            return result.ToString();
        }
    }
}
