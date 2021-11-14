using GGBack.Data;
using GGBack.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public class NewsAssembler
    {
        private static string rootFolderPath;

        public static IEnumerable<News> AssembleNews(ServerDbContext context, string rootPath, User user = null)
        {
            rootFolderPath = rootPath;

            if (user == null)
            {
                return AssembleAllNewsHeader(context.RawNewss.ToList());
            }
            else
            {
                return AssembleAllNewsHeader(context.RawNewss
                    .Include(rn => rn.Competition)
                        .ThenInclude(c => c.Sport)
                    .Where(rn => user.Sports.Contains(rn.Competition.Sport))
                    .ToList());

            }
        }

        public static News AssembleFullNews(RawNews rawNews)
        {
            return new News
            {
                Id = rawNews.Id,
                Header = AssembleNewsHeader(rawNews),
                Body = AssembleNewsBody(rawNews),
                Date = rawNews.Date,
                CompetitionTitle = rawNews.Competition.Title,
                CompetitionId = rawNews.Competition.Id
            };
        }

        private static IEnumerable<News> AssembleAllNewsHeader(List<RawNews> rawNews)
        {
            List<News> news = new List<News>();
            foreach (RawNews rn in rawNews)
            {
                news.Add(new News
                {
                    Id = rn.Id,
                    Header = AssembleNewsHeader(rn)
                });
            }

            return news;
        }

        private static string AssembleNewsHeader(RawNews rawNews)
        {
            string template = GetNewsTemplate(rawNews.TemplatePath);
            int lastIndex = template.IndexOf("<header>");

            StringBuilder header = new StringBuilder(template.Substring(0, lastIndex));
            string[] headerData = rawNews.HeaderData.Split(';', StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < headerData.Length; i++)
            {
                header.Replace("{h" + i + "}", headerData[i]);
            }

            return header.ToString();
        }

        private static string AssembleNewsBody(RawNews rawNews)
        {
            string template = GetNewsTemplate(rawNews.TemplatePath);
            int lastIndex = template.IndexOf("<header>");

            StringBuilder body = new StringBuilder(template.Substring(lastIndex + 8));
            string[] bodyData = rawNews.BodyData.Split(';', StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < bodyData.Length; i++)
            {
                body.Replace("{b" + i + "}", bodyData[i]);
            }

            return body.ToString();
        }

        private static string GetNewsTemplate(string path)
        {
            return null;
        }
    }
}
