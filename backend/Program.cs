using Microsoft.EntityFrameworkCore;
using Clementbq.BattleTownship.Data;
using Clementbq.BattleTownship.Services;
using Clementbq.BattleTownship.Exceptions;
using Clementbq.BattleTownship.Data.Models;
using Microsoft.AspNetCore.Identity;
using Clementbq.BattleTownship.Configuration;

var builder = WebApplication.CreateBuilder(args);


builder.Services.AddOptions<AppConfiguration>()
    .Bind(builder.Configuration.GetSection(AppConfiguration.SectionName))
    .ValidateDataAnnotations()
    .ValidateOnStart();
var appConfig = builder.Configuration.GetSection(AppConfiguration.SectionName).Get<AppConfiguration>()!;

builder.Services.AddExceptionHandler<ExceptionHandler>();
builder.Services.AddProblemDetails();

builder.Services.AddCors(options =>
{
    options.AddPolicy("Frontend", policy => policy
        .WithOrigins(appConfig.FrontendUrl)
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials());
});

builder.Services
    .AddIdentity<User, IdentityRole<Guid>>(options =>
        {
            options.User.RequireUniqueEmail = true;

            options.Password.RequiredLength = 8;
            options.Password.RequireNonAlphanumeric = false;

            options.Lockout.MaxFailedAccessAttempts = 10;
        })
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();

builder.Services.ConfigureApplicationCookie(options =>
{
    options.Cookie.Name = "__Host-BattleTownship.Auth";
    options.Cookie.HttpOnly = true;
    // in development : use SameAsRequest for local
    options.Cookie.SecurePolicy = appConfig.Security.CookieSecurePolicy;
    options.Cookie.SameSite = SameSiteMode.Strict;
    options.Cookie.Path = "/";

    options.ExpireTimeSpan = TimeSpan.FromDays(7);
    options.SlidingExpiration = true;
});

builder.Services.AddAuthorization();

builder.Services.AddControllers();

builder.Services.AddDbContext<ApplicationDbContext>(
    options => options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"))
);

builder.Services.AddSingleton<GeoDataService>();

var app = builder.Build();

app.UseExceptionHandler();

app.UseHttpsRedirection();

app.UseCors("Frontend");

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.Run();
