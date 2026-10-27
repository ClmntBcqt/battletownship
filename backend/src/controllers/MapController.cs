using Clementbq.BattleTownship.Data;
using Clementbq.BattleTownship.Data.Models;
using Clementbq.BattleTownship.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Clementbq.BattleTownship.Controllers;

[Route("[controller]")]
[ApiController]
public class MapController(ApplicationDbContext dbContext) : ControllerBase
{
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
            ScanId = s.Id,
            s.Township.Name,
            s.Township.Geojson,
            Username = s.User.UserName,
            s.Picture,
            s.CreatedAt
        }));
    }
}
