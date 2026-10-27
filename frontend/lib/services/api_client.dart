import 'package:dio/dio.dart';
import 'package:frontend/config/config.dart';
import 'package:frontend/dtos/create_scan_request.dart';
import 'package:frontend/dtos/login_request.dart';
import 'package:frontend/dtos/register_request.dart';
import 'package:frontend/dtos/township.dart';
import 'package:frontend/dtos/user_infos.dart';
import 'package:frontend/services/http_client.dart';

class ApiClient {
  static final defaultOptions = BaseOptions(
    baseUrl: AppConfig.backendUrl,
    contentType: 'application/json',
  );

  HttpClient httpClient;

  ApiClient(this.httpClient);

  Future<List<TownshipDto>> getAllTownships() async {
    final response = await httpClient.get("/map");

    return (response.data as List)
        .map((json) => TownshipDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> addScan(CreateScanRequest request) async {
    await httpClient.post("/scans", request);
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

  Future<void> reportScan(String scanId) async =>
      await httpClient.post("/report/$scanId", null);
}
