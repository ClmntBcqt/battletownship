using System.ComponentModel.DataAnnotations;
using Microsoft.Extensions.Options;

namespace Clementbq.BattleTownship.Configuration;

public class AppConfiguration
{
    public const string SectionName = "App";

    [Required]
    public required string FrontendUrl { get; set; }

    [Required]
    [ValidateObjectMembers]
    public required SecurityConfiguration Security { get; set; }
}

public class SecurityConfiguration
{
    [Required]
    public required CookieSecurePolicy CookieSecurePolicy { get; set; }

    [Required]
    public required String AuthCookieName { get; set; }
}