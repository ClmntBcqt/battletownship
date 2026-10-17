import 'dart:convert';

import 'package:frontend/dtos/township.dart';
import 'package:frontend/services/http_client.dart';

class ApiClient {
  static final baseUrl = "http://localhost:5211";
  final httpClient = HttpClient();

  Future<String> getGeometryOf(String townshipName) async {
    var response = await httpClient.get("$baseUrl/map/$townshipName");

    return response.body;
  }

  Future<List<TownshipDto>> getAllTownships() async {
    final response = await httpClient.get("$baseUrl/map");

    final list = jsonDecode(response.body) as List<dynamic>;

    var t = list
        .map((json) => TownshipDto.fromJson(json as Map<String, dynamic>))
        .toList();

    return t;
  }

  Future<void> addTownship(String name) async {
    await httpClient.post("$baseUrl/map", name);
  }
}
