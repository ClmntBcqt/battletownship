namespace Clementbq.BattleTownship.Data.Models;

public class Scan
{
    public Guid Id { get; set; }

    public Guid TownshipId { get; set; }
    required public Township Township { get; set; }

    public Guid UserId { get; set; }
    required public User User { get; set; }

    required public byte[] Picture { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}