﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GGBack.Models
{
    public class Sport
    {
        public int Id { get; set; }

        public string Title { get; set; }

        public bool HasTeam { get; set; }

        public bool HasGrid { get; set; }

        public int CompetitorsLimit { get; set; }

        public bool HasTeamLimit { get; set; }

        public int TeamLimit { get; set; }

        // Followers
        [JsonIgnore]
        public List<User> Users { get; set; }

        [JsonIgnore]
        public List<Competition> Competitions { get; set; }
    }
}