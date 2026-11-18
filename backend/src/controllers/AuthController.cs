using System.Security.Claims;
using Clementbq.BattleTownship.Data;
using Clementbq.BattleTownship.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace Clementbq.BattleTownship.Controllers;

[ApiController]
[Route("[controller]")]
public class AuthController(
    UserManager<User> userManager,
    SignInManager<User> signInManager,
    ApplicationDbContext dbContext
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
    public IActionResult GetUserInfos()
    {
        return Ok(new
        {
            Email = User.FindFirst(ClaimTypes.Email)?.Value,
            Username = User.FindFirst(ClaimTypes.Name)?.Value,
        });
    }

    public record UpdateUserRequest(
        string Username,
        string Email,
        string CurrentPassword,
        string? NewPassword
    );

    [Authorize]
    [HttpPatch("me")]
    public async Task<IActionResult> UpdateUser([FromBody] UpdateUserRequest request)
    {
        User? user = await userManager.GetUserAsync(User);
        if (user == null) return Unauthorized();

        if (!await userManager.CheckPasswordAsync(user, request.CurrentPassword))
        {
            return Forbid();
        }

        await using var transaction = await dbContext.Database.BeginTransactionAsync();

        List<IdentityError> errors = [];

        if (request.Username != user.UserName)
        {
            var result = await userManager.SetUserNameAsync(user, request.Username);
            if (!result.Succeeded) errors.AddRange(result.Errors);
        }

        if (request.Email != user.Email)
        {
            var result = await userManager.SetEmailAsync(user, request.Email);
            if (!result.Succeeded) errors.AddRange(result.Errors);
        }

        if (request.NewPassword != null)
        {
            var result = await userManager.ChangePasswordAsync(user, request.CurrentPassword, request.NewPassword);
            if (!result.Succeeded) errors.AddRange(result.Errors);

        }

        if (errors.Count > 0)
        {
            await transaction.RollbackAsync();

            return BadRequest(new ValidationProblemDetails(new Dictionary<string, string[]>
            {
                [nameof(IdentityErrorDescriber.DuplicateEmail)] = [.. errors
                                .Where(e => e.Code == nameof(IdentityErrorDescriber.DuplicateEmail))
                                .Select(e => e.Description)],
                [nameof(IdentityErrorDescriber.DuplicateUserName)] = [.. errors
                                .Where(e => e.Code == nameof(IdentityErrorDescriber.DuplicateUserName))
                                .Select(e => e.Description)],
                ["other"] = [.. errors
                                .Where(e => e.Code != nameof(IdentityErrorDescriber.DuplicateUserName)
                                    && e.Code != nameof(IdentityErrorDescriber.DuplicateEmail))
                                .Select(e => e.Description)]
            })
            {
                Status = StatusCodes.Status400BadRequest,
                Detail = "Erreur lors de la mise a jour de l'utilisateur"
            });
        }

        await transaction.CommitAsync();

        await signInManager.RefreshSignInAsync(user);

        return Ok();
    }
}