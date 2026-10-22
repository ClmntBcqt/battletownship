using System.Text.Json;
using Clementbq.BattleTownship.Exceptions;
using Microsoft.AspNetCore.WebUtilities;

namespace Clementbq.BattleTownship.Services;

public class GeoDataService
{
    private readonly HttpClient _httpClient;
    private const string NOMINATIM_URL = "https://nominatim.openstreetmap.org";

    public GeoDataService()
    {
        _httpClient = new HttpClient
        {
            BaseAddress = new Uri(NOMINATIM_URL),
        };
        _httpClient.DefaultRequestHeaders.UserAgent.ParseAdd("com.clementbq.battletownship");
    }

    public JsonElement FindFromOsm(string townshipName)
    {
        var candidates = FetchFromNominatim(townshipName)
            .RootElement
            .GetProperty("features")
            .EnumerateArray();

        if (!candidates.Any())
            throw new TownshipNotFoundException(message: "La commune n'a pas pu être trouvée.");

        return candidates.FirstOrDefault(
            feature =>
                feature.TryGetProperty("properties", out var properties)
                && properties.TryGetProperty("extratags", out var extratags)
                && extratags.TryGetProperty("admin_level", out var adminLevel)
                && adminLevel.ToString() == "8",
            candidates.First()
        );
    }

    private JsonDocument FetchFromNominatim(string townshipName)
    {
        string url = QueryHelpers.AddQueryString("search",
            new Dictionary<string, string?>
            {
                ["city"] = townshipName,
                ["country"] = "France",
                ["extratags"] = "1",
                ["format"] = "geojson",
                ["polygon_geojson"] = "1",
            });

        var response = _httpClient.GetAsync(url).Result;
        string result = response.Content.ReadAsStringAsync().Result;

        return JsonDocument.Parse(result);
    }
}