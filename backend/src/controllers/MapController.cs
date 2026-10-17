using Clementbq.BattleTownship.Data;
using Clementbq.BattleTownship.Data.Models;
using Clementbq.BattleTownship.Services;
using Microsoft.AspNetCore.Mvc;

namespace Clementbq.BattleTownship.Controllers;

[Route("[controller]")]
[ApiController]
public class MapController(
    ApplicationDbContext dbContext,
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
    public async Task<IActionResult> GetAllTownship()
    {
        var towns = dbContext.Townships.ToList();

        return Ok(towns.Select(t => new { t.Name, t.Geojson }));
    }

    [HttpPost]
    public async Task<IActionResult> AddTownShip([FromBody] string requestedName)
    {
        var geojson = geoDataService.FindFromOsm(requestedName);

        var newTownShip = new Township
        {
            Name = geojson.GetProperty("properties").GetProperty("name").GetString()!,
            Geojson = geojson
        };

        dbContext.Townships.Add(newTownShip);

        dbContext.SaveChanges();

        return Created();
    }
}
