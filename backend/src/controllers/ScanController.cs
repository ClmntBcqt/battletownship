using Clementbq.BattleTownship.Data;
using Clementbq.BattleTownship.Data.Models;
using Clementbq.BattleTownship.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Clementbq.BattleTownship.Controllers;

[ApiController]
[Route("[controller]")]
public class ScansController(
    ApplicationDbContext dbContext,
    UserManager<User> userManager,
    GeoDataService geoDataService
) : ControllerBase
{

    public record CreateScanRequest(string InseeCode, byte[] Picture);

    [Authorize]
    [HttpPost]
    public async Task<IActionResult> AddScan([FromBody] CreateScanRequest request)
    {
        var user = await userManager.GetUserAsync(User);
        if (user == null) return Unauthorized();

        Township township;
        if (!dbContext.Townships.Any(t => t.InseeCode == request.InseeCode))
        {
            township = await geoDataService.FindTownshipAsync(request.InseeCode);
        }
        else
        {
            township = dbContext.Townships
                .Where(t => t.InseeCode == request.InseeCode)
                .First();
        }


        var newScan = new Scan
        {
            Township = township,
            User = user,
            Picture = request.Picture,
        };

        dbContext.Scans.Add(newScan);

        dbContext.SaveChanges();

        return Created();
    }

    [Authorize]
    [HttpGet("me")]
    public async Task<IActionResult> GetScans()
    {
        var user = await userManager.GetUserAsync(User);

        var scans = dbContext.Scans.Where(s => s.User == user);

        return Ok(scans.Select(s => new
        {
            s.Id,
            s.CreatedAt,
            TownshipName = s.Township.Name,
            hasTownship = !dbContext.Scans.Any(other =>
                other.Township == s.Township &&
                other.CreatedAt > s.CreatedAt),
            reportNumber = dbContext.Reports.Where(r => r.Scan == s).Count(),
            s.Picture,
        }));
    }

    [Authorize]
    [HttpDelete]
    public async Task<IActionResult> DeleteScan(List<Guid> scanIds)
    {
        var user = await userManager.GetUserAsync(User);
        var scans = await dbContext.Scans
            .Where(s => scanIds.Contains(s.Id))
            .ToListAsync();

        if (scans.Count != scanIds.Distinct().Count() || scans.Any(s => s.User != user))
        {
            return NotFound();
        }

        dbContext.Scans.RemoveRange(scans);

        await dbContext.SaveChangesAsync();

        return Ok();
    }
}