using System.Text.Json;
using Clementbq.BattleTownship.Data.Models;
using Clementbq.BattleTownship.Exceptions;
using Microsoft.AspNetCore.WebUtilities;

namespace Clementbq.BattleTownship.Services;

public class GeoDataService
{
    private readonly HttpClient _httpClient;
    private const string GEO_API_URL = "https://geo.api.gouv.fr";

    public GeoDataService()
    {
        _httpClient = new HttpClient
        {
            BaseAddress = new Uri(GEO_API_URL),
        };
    }

    public async Task<Township> FindTownshipAsync(string inseeCode)
    {
        try
        {
            var response = await FetchFromGeoApiAsync(inseeCode);

            return new Township
            {
                InseeCode = inseeCode,
                Name = response.RootElement
                            .GetProperty("properties")
                            .GetProperty("nom")
                            .GetString()!,
                Geojson = response.RootElement,
            };
        }
        catch (HttpRequestException e)
        {
            if (e.StatusCode == System.Net.HttpStatusCode.NotFound)
            {
                throw new TownshipNotFoundException("La commune n'a pas pu être trouvée.");
            }
            else
            {
                throw;
            }
        }
    }



    private async Task<JsonDocument> FetchFromGeoApiAsync(string inseeCode)
    {
        string url = QueryHelpers.AddQueryString("communes/" + inseeCode,
            new Dictionary<string, string?>
            {
                ["fields"] = "nom",
                ["format"] = "geojson",
                ["geometry"] = "contour",
            });

        var response = await _httpClient.GetAsync(url);
        string result = await response.Content.ReadAsStringAsync();

        return JsonDocument.Parse(result);
    }
}