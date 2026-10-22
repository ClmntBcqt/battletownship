using Clementbq.BattleTownship.Data.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Clementbq.BattleTownship.Data;

public class ApplicationDbContext(
    DbContextOptions<ApplicationDbContext> options) : IdentityDbContext<User, IdentityRole<Guid>, Guid>(options)
{
    public DbSet<Township> Townships => Set<Township>();
    public DbSet<Scan> Scans => Set<Scan>();
    public DbSet<Report> Reports => Set<Report>();
}