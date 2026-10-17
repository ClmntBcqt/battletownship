using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json;

namespace Clementbq.BattleTownship.Models;

public class Township
{
    public int Id { get; set; }

    public required string Name { get; set; }

    [Column(TypeName = "jsonb")]
    public required JsonElement Geojson { get; set; }
}