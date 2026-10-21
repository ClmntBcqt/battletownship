import 'package:dio/dio.dart';
import 'package:frontend/dtos/create_scan_request.dart';
import 'package:frontend/dtos/login_request.dart';
import 'package:frontend/dtos/register_request.dart';
import 'package:frontend/dtos/scan.dart';
import 'package:frontend/dtos/user_infos.dart';
import 'package:frontend/services/http_client.dart';

class ApiClient {
  static final defaultOptions = BaseOptions(
    baseUrl: "https://localhost:7128",
    contentType: 'application/json',
  );

  HttpClient httpClient;

  ApiClient(this.httpClient);

  Future<String> getGeometryOf(String townshipName) async {
    var response = await httpClient.get("/map/$townshipName");

    return response.data;
  }

  Future<List<ScanDto>> getAllTownships() async {
    final response = await httpClient.get("/map");

    return (response.data as List)
        .map((json) => ScanDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> addTownship(CreateScanRequest request) async {
    await httpClient.post("/map", request);
  }

  Future<void> register(RegisterRequest request) async {
    await httpClient.post("/auth/register", request);
  }

  Future<void> login(LoginRequest request) async {
    await httpClient.post("/auth/login", request);
  }

  Future<UserInfos> getUserInfos() async {
    final response = await httpClient.get("/auth/me");

    return UserInfos.fromJson(response.data as Map<String, dynamic>);
  }
}
