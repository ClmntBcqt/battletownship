using Clementbq.BattleTownship.Data;
using Clementbq.BattleTownship.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RouteAttribute = Microsoft.AspNetCore.Mvc.RouteAttribute;

namespace Clementbq.BattleTownship.Controllers;

[ApiController]
[Route("[controller]")]
public class ReportController(
    ApplicationDbContext dbContext,
    UserManager<User> userManager
) : ControllerBase
{
    [Authorize]
    [HttpPost("{scanId}")]
    public async Task<IActionResult> ReportScan([FromRoute] Guid scanId)
    {
        var user = await userManager.GetUserAsync(User);
        if (user == null) return Unauthorized();

        var scan = await dbContext.Scans.FindAsync(scanId);
        if (scan == null) return NotFound();

        var reportExists = await dbContext.Reports.AnyAsync(r => r.Author == user && r.Scan == scan);
        if (reportExists) return Created();

        var newReport = new Report
        {
            Author = user,
            Scan = scan
        };

        await dbContext.Reports.AddAsync(newReport);

        await dbContext.SaveChangesAsync();

        return Created();
    }
}
