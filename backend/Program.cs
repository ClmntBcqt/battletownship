using Microsoft.EntityFrameworkCore;
using Clementbq.BattleTownship.Data;
using Clementbq.BattleTownship.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddDbContext<ApplicationDbContext>(
    options => options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"))
);

builder.Services.AddSingleton<GeoDataService>();

var app = builder.Build();

app.MapControllers();

app.UseHttpsRedirection();

app.Run();
