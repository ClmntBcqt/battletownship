using Microsoft.EntityFrameworkCore;
using Clementbq.BattleTownship.Data;
using Clementbq.BattleTownship.Services;
using Clementbq.BattleTownship.Exceptions;

var builder = WebApplication.CreateBuilder(args);


builder.Services.AddExceptionHandler<ExceptionHandler>();
builder.Services.AddProblemDetails();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy => policy
        .AllowAnyOrigin()
        .AllowAnyMethod()
        .AllowAnyHeader());
});

builder.Services.AddControllers();

builder.Services.AddDbContext<ApplicationDbContext>(
    options => options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"))
);

builder.Services.AddSingleton<GeoDataService>();

var app = builder.Build();

app.UseExceptionHandler();

app.UseHttpsRedirection();

if (app.Environment.IsDevelopment())
{
    app.UseCors("AllowAll");
}

app.MapControllers();

app.Run();
