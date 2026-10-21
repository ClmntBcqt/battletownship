namespace Clementbq.BattleTownship.Dtos;

public record CreateScanRequest(
    string TownshipName,
    byte[] Picture
);