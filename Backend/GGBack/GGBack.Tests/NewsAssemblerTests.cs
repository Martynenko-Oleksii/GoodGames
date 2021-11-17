using GGBack.Models;
using GGBack.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace GGBack.Tests
{
    public class NewsAssemblerTests
    {
        [Fact]
        public void AssempleNewsCompetitionCreating()
        {
            // Arrange
            RawNews rawNews = new RawNews
            {
                Id = 3,
                HeaderData = "123",
                BodyData = "123;Футбол;11/23/2021;11/15/2021;12;qwe;True",
                TemplatePath = "\\competitionCreating.txt",
                Date = DateTime.Now,
                Competition = new Competition
                {
                    Title = "title",
                    Id = 1
                }
            };
            string header = "Створено: 123";
            string body = "Створено змагання 123\r\n" +
                "Вид спорту: Футбол\r\n" +
                "Початок: 11/23/2021\r\n" +
                "Кінець: 11/15/2021\r\n" +
                "Вікове обмеження: 12\r\n" +
                "Місто: qwe\r\n" +
                "Відкрите: так";

            // Act
            News news = NewsAssembler.AssembleFullNews(rawNews);

            // Assert
            Assert.Equal(header, news.Header);
            Assert.Equal(body, news.Body);
        }

        [Fact]
        public void AssempleNewsCompetitionStarting()
        {
            // Arrange
            RawNews rawNews = new RawNews
            {
                Id = 3,
                HeaderData = "Соревнование на скорость",
                BodyData = "Соревнование на скорость;5;5",
                TemplatePath = "\\competitionStarting.txt",
                Date = DateTime.Now,
                Competition = new Competition
                {
                    Title = "title",
                    Id = 1
                }
            };
            string header = "Розпочато: Соревнование на скорость";
            string body = "Змагання Соревнование на скорость почалось\r\n" +
                "Взяли участь 5 команд із усього 5 учасниками";

            // Act
            News news = NewsAssembler.AssembleFullNews(rawNews);

            // Assert
            Assert.Equal(header, news.Header);
            Assert.Equal(body, news.Body);
        }

        [Fact]
        public void AssempleNewsCompetitionEnding()
        {
            // Arrange
            RawNews rawNews = new RawNews
            {
                Id = 3,
                HeaderData = "Соревнование на скорость",
                BodyData = "Соревнование на скорость",
                TemplatePath = "\\competitionEnding.txt",
                Date = DateTime.Now,
                Competition = new Competition
                {
                    Title = "title",
                    Id = 1
                }
            };
            string header = "Завершено: Соревнование на скорость";
            string body = "Змагання Соревнование на скорость було завершено\r\n" +
                "Результати можна переглянути на сторінці змагання, натиснувш кнопку нижче";

            // Act
            News news = NewsAssembler.AssembleFullNews(rawNews);

            // Assert
            Assert.Equal(header, news.Header);
            Assert.Equal(body, news.Body);
        }

        [Fact]
        public void AssempleNewsMatchEnding()
        {
            // Arrange
            RawNews rawNews = new RawNews
            {
                Id = 3,
                HeaderData = "Соревнование на скорость",
                BodyData = "Соревнование на скорость;Team 1;Team 2;2;3;Team 2",
                TemplatePath = "\\matchEnding.txt",
                Date = DateTime.Now,
                Competition = new Competition
                {
                    Title = "title",
                    Id = 1
                }
            };
            string header = "Завершено матч: Соревнование на скорость";
            string body = "У рамках змагання Соревнование на скорость було завершено матч, проведений між командами Team 1 та Team 2\r\n" +
                "Із результатом 2-3 перемогла команда Team 2";

            // Act
            News news = NewsAssembler.AssembleFullNews(rawNews);

            // Assert
            Assert.Equal(header, news.Header);
            Assert.Equal(body, news.Body);
        }
    }
}
