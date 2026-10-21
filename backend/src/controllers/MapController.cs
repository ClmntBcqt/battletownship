using Clementbq.BattleTownship.Data;
using Clementbq.BattleTownship.Data.Models;
using Clementbq.BattleTownship.Dtos;
using Clementbq.BattleTownship.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Clementbq.BattleTownship.Controllers;

[Route("[controller]")]
[ApiController]
public class MapController(
    ApplicationDbContext dbContext,
    UserManager<User> userManager,
GeoDataService geoDataService
) : ControllerBase
{
    [HttpGet("{name}")]
    public async Task<IActionResult> GetTownShip(string name)
    {
        var town = dbContext.Townships
            .Where(t => t.Name == name)
            .First();

        if (town == null) return NotFound("Pas trouvé");

        return Ok(town.Geojson);
    }

    [HttpGet]
    [Authorize]
    public async Task<IActionResult> GetAllTownship()
    {
        var towns = dbContext.Scans
            .Include(s => s.Township)
            .Include(s => s.User)
            .ToList()
            .GroupBy(s => s.TownshipId)
            .Select(g => g.OrderByDescending(s => s.CreatedAt).First());

        return Ok(towns.Select(s => new
        {
            s.Township.Name,
            s.Township.Geojson,
            Username = s.User.UserName,
            s.Picture,
            s.CreatedAt
        }));
    }

    [Authorize]
    [HttpPost]
    public async Task<IActionResult> AddTownShip([FromBody]
    CreateScanRequest request)
    {
        var user = await userManager.GetUserAsync(User);
        if (user == null) return Unauthorized();

        var geojson = geoDataService.FindFromOsm(request.TownshipName);

        var name = geojson.GetProperty("properties").GetProperty("name").GetString()!;

        var existingTownship = dbContext.Townships.FirstOrDefault(t => t.Name == name);

        if (existingTownship == null)
        {
            existingTownship = new Township
            {
                Name = name,
                Geojson = geojson
            };
            dbContext.Townships.Add(existingTownship);
        }

        var newScan = new Scan
        {
            Township = existingTownship,
            User = user,
            Picture = request.Picture,
        };
        dbContext.Scans.Add(newScan);

        dbContext.SaveChanges();

        return Created();
    }
}
