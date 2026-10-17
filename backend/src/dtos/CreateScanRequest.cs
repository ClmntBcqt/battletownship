namespace Clementbq.BattleTownship.Dtos;

public record CreateScanRequest(
    string TownshipName,
    string Username,
    byte[] Picture
);