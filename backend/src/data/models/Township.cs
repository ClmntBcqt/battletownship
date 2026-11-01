using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;

namespace Clementbq.BattleTownship.Data.Models;

[Index(nameof(InseeCode), IsUnique = true)]
public class Township
{
    public Guid Id { get; set; }

    public required string Name { get; set; }

    public required string InseeCode { get; set; }

    [Column(TypeName = "jsonb")]
    public required JsonElement Geojson { get; set; }
}