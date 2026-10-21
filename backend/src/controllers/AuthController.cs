using System.Security.Claims;
using Clementbq.BattleTownship.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace Clementbq.BattleTownship.Controllers;

[ApiController]
[Route("[controller]")]
public class AuthController(
    UserManager<User> userManager,
    SignInManager<User> signInManager
) : ControllerBase
{
    public record RegisterRequest(string Email, string Username, string Password);

    [HttpPost("register")]
    [AllowAnonymous]
    public async Task<IActionResult> Register([FromBody] RegisterRequest registerRequest)
    {
        User user = new()
        {
            UserName = registerRequest.Username,
            Email = registerRequest.Email,
        };

        var creationResult = await userManager.CreateAsync(user, registerRequest.Password);

        if (!creationResult.Succeeded)
        {

            return BadRequest(new ValidationProblemDetails(new Dictionary<string, string[]>
            {
                // email and username conflicts are the only errors that should occurs here
                // password and email format are already checked in front
                [nameof(IdentityErrorDescriber.DuplicateEmail)] = [.. creationResult.Errors
                                .Where(e => e.Code == nameof(IdentityErrorDescriber.DuplicateEmail))
                                .Select(e => e.Description)],
                [nameof(IdentityErrorDescriber.DuplicateUserName)] = [.. creationResult.Errors
                                .Where(e => e.Code == nameof(IdentityErrorDescriber.DuplicateUserName))
                                .Select(e => e.Description)],
                ["other"] = [.. creationResult.Errors
                                .Where(e =>
                                    e.Code != nameof(IdentityErrorDescriber.DuplicateEmail)
                                    && e.Code != nameof(IdentityErrorDescriber.DuplicateUserName))
                                .Select(e => e.Description)]
            })
            {
                Status = StatusCodes.Status400BadRequest,
                Detail = "Erreur lors de la création du compte"
            });
        }

        await signInManager.SignInAsync(user, isPersistent: true);

        return Ok();
    }

    public record LoginRequest(string Email, string Password);

    private static ProblemDetails UnauthorizedLoginDetails => new()
    {
        Status = StatusCodes.Status401Unauthorized,
        Detail = "Identifiant et/ou mot de passe incorrects"
    };

    [HttpPost("login")]
    [AllowAnonymous]
    public async Task<IActionResult> Login([FromBody] LoginRequest loginRequest)
    {
        User? user = await userManager.FindByEmailAsync(loginRequest.Email);

        if (user == null)
        {
            return Unauthorized(UnauthorizedLoginDetails);
        }

        var signInResult = await signInManager.PasswordSignInAsync(
            user,
            loginRequest.Password,
            isPersistent: true,
            lockoutOnFailure: true);

        if (signInResult.IsLockedOut)
        {
            string message = "Compte bloqué";
            var lockoutEnd = await userManager.GetLockoutEndDateAsync(user);
            if (lockoutEnd.HasValue)
            {
                var lockoutRemainingTime = lockoutEnd.Value - DateTimeOffset.UtcNow;
                var lockoutRemainingMinutes = (int)Math.Ceiling(lockoutRemainingTime.TotalMinutes);
                message = $"{message} pendant {lockoutRemainingMinutes} minute{(lockoutRemainingMinutes > 1 ? "s" : "")}";
            }

            return Unauthorized(new ProblemDetails
            {
                Status = StatusCodes.Status401Unauthorized,
                Detail = message
            });
        }

        if (!signInResult.Succeeded)
        {
            return Unauthorized(UnauthorizedLoginDetails);
        }

        return Ok();
    }

    [Authorize]
    [HttpGet("me")]
    public async Task<IActionResult> Test()
    {
        return Ok(new
        {
            Email = User.FindFirst(ClaimTypes.Email)?.Value,
            Username = User.FindFirst(ClaimTypes.Name)?.Value,
        });
    }
}