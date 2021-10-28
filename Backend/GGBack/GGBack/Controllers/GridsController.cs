using GGBack.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GridsController : ControllerBase
    {
        private ServerDbContext context;

        public GridsController(ServerDbContext context)
        {
            this.context = context;
        }

        [HttpGet("{competitionId}")]
    }
}
