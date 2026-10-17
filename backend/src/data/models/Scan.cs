namespace Clementbq.BattleTownship.Data.Models;

public class Scan
{
    public int Id { get; set; }

    public int TownshipId { get; set; }
    required public Township Township { get; set; }

    required public string Username { get; set; }

    required public byte[] Picture { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}