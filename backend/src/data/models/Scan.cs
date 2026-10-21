namespace Clementbq.BattleTownship.Data.Models;

public class Scan
{
    public int Id { get; set; }

    public int TownshipId { get; set; }
    required public Township Township { get; set; }

    public string UserId { get; set; }
    required public User User { get; set; }

    required public byte[] Picture { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}