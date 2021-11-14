﻿using GGBack.Data;
using GGBack.Models;
using GGBack.Utils;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Controllers
{
    [ApiController]
    public class NewsController : ControllerBase
    {
        ServerDbContext context;

        public NewsController(ServerDbContext context)
        {
            this.context = context;
        }

        [Route("api/news")]
        [HttpGet]
        public ActionResult<IEnumerable<News>> GetAllNews()
        {
            try
            {
                IEnumerable<News> allNews = NewsAssembler.AssembleNews(context);
                if (allNews != null)
                {
                    return Ok(allNews);
                }
                else
                {
                    return BadRequest("Помилка при отриманні новин :(");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }
        }

        [Route("api/news/{userId}")]
        [HttpGet]
        public ActionResult<IEnumerable<News>> GetFavouriteNews(int userId)
        {
            try
            {
                User user = context.Users
                    .Include(u => u.Sports)
                    .Where(u => u.Id == userId)
                    .FirstOrDefault();
                IEnumerable<News> favouriteNews = NewsAssembler.AssembleNews(context, user);
                if (favouriteNews != null)
                {
                    return Ok(favouriteNews);
                }
                else
                {
                    return BadRequest("Помилка при отриманні новин :(");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }
        }

        [Route("api/news/{newsId}")]
        [HttpGet]
        public ActionResult<News> GetFullNews(int newsId)
        {
            try
            {
                return NewsAssembler.AssembleFullNews(context.RawNewss.Find(newsId));
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + "\n" + ex.InnerException);
            }
        }
    }
}