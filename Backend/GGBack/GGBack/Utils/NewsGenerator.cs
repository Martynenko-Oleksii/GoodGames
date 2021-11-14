using GGBack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Utils
{
    public enum NewsType
    {
        CompetitionCreating,
        CompetitionStarting,
        CompetitionEnding,
        MatchStarting,
        MatchEnding
    }

    public class NewsGenerator
    {
        public static async Task<RawNews> SetRawNewsAsync(string[] headerData, string[] bodyData, Competition competition, NewsType type)
        {
            return await Task.Run(() => SetRawNews(headerData, bodyData, competition, type));
        }

        public static RawNews SetRawNews(string[] headerData, string[] bodyData, Competition competition, NewsType type)
        {
            RawNews rawNews = new RawNews
            {
                HeaderData = String.Join(';', headerData),
                BodyData = String.Join(';', bodyData),
                Date = DateTime.UtcNow
            };
            switch (type)
            {
                case NewsType.CompetitionCreating:
                    rawNews.TemplatePath = "\\competitionCreating.txt";
                    break;
                case NewsType.CompetitionStarting:
                    rawNews.TemplatePath = "\\competitionStarting.txt";
                    break;
                case NewsType.CompetitionEnding:
                    rawNews.TemplatePath = "\\competitionEnding.txt";
                    break;
                case NewsType.MatchStarting:
                    rawNews.TemplatePath = "\\matchStarting.txt";
                    break;
                case NewsType.MatchEnding:
                    rawNews.TemplatePath = "\\matchEnding.txt";
                    break;
                default:
                    return null;
            }

            return rawNews;
        }
    }
}
