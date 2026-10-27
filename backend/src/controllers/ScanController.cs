using Clementbq.BattleTownship.Data;
using Clementbq.BattleTownship.Data.Models;
using Clementbq.BattleTownship.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace Clementbq.BattleTownship.Controllers;

[ApiController]
[Route("[controller]")]
public class ScansController(
    ApplicationDbContext dbContext,
    UserManager<User> userManager,
    GeoDataService geoDataService
) : ControllerBase
{

    public record CreateScanRequest(string TownshipName, byte[] Picture);

    [Authorize]
    [HttpPost]
    public async Task<IActionResult> AddScan([FromBody] CreateScanRequest request)
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