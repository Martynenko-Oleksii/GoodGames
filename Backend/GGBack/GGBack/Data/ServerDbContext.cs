using GGBack.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GGBack.Data
{
    public class ServerDbContext : DbContext
    {
        public DbSet<User> Users { get; set; }
        public DbSet<Subscription> Subscriptions { get; set; }
        public DbSet<Sport> Sports { get; set; }
        public DbSet<Competition> Competitions { get; set; }
        public DbSet<Competitor> Competitors { get; set; }
        public DbSet<TimetableCell> TimetableCells { get; set; }
        public DbSet<WinResult> WinResults { get; set; }

        public ServerDbContext(DbContextOptions<ServerDbContext> options) 
            : base(options)
        {
            Database.EnsureCreated();
        }
    }
}
