using GGBack.Data;
using GGBack.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public class NewsAssembler
    {
        public static IEnumerable<News> AssembleNews(ServerDbContext context, User user = null)
        {
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
            return null;
        }

        private static string AssembleNewsHeader(RawNews rawNews)
        {
            return null;
        }

        private static string AssembleNewsBody(RawNews rawNews)
        {
            return null;
        }

        private static string GetNewsTemplate(string path)
        {
            return null;
        }
    }
}
