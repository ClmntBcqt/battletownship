namespace Clementbq.BattleTownship.Data.Models;

public class Report
{
    public Guid Id { get; set; }

    public Guid AuthorId { get; set; }
    required public User Author { get; set; }

    public Guid ScanId { get; set; }
    required public Scan Scan { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}