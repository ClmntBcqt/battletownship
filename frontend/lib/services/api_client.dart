import 'package:dio/dio.dart';
import 'package:frontend/dtos/township.dart';
import 'package:frontend/services/http_client.dart';

class ApiClient {
  static final baseUrl = "http://localhost:5211";
  final httpClient = HttpClient(
    baseOptions: BaseOptions(baseUrl: baseUrl, contentType: 'application/json'),
  );

  Future<String> getGeometryOf(String townshipName) async {
    var response = await httpClient.get("/map/$townshipName");

    return response.data;
  }

  Future<List<TownshipDto>> getAllTownships() async {
    final response = await httpClient.get("/map");

    return (response.data as List)
        .map((json) => TownshipDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> addTownship(String name) async {
    await httpClient.post("/map", name);
  }
}
