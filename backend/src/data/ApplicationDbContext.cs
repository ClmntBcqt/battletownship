using Clementbq.BattleTownship.Models;
using Microsoft.EntityFrameworkCore;

namespace Clementbq.BattleTownship.Data;

public class ApplicationDbContext(
    DbContextOptions<ApplicationDbContext> options) : DbContext(options)
{
    public DbSet<Township> Townships => Set<Township>();
}