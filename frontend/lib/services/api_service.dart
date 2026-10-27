import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/dtos/create_scan_request.dart';
import 'package:frontend/dtos/township.dart';
import 'package:frontend/services/api_client.dart';

class ApiService extends ChangeNotifier {
  final ApiClient _apiClient;

  ApiService(this._apiClient);

  List<TownshipDto> _townships = [];
  List<TownshipDto> get townships => _townships;

  Future<void> fetchTownships() async {
    _townships = await _apiClient.getAllTownships();

    notifyListeners();
  }

  Future<void> addScan(String townshipName, Uint8List picture) async {
    await _apiClient.addScan(
      CreateScanRequest(townshipName: townshipName, picture: picture),
    );

    await fetchTownships();
  }

  Future<void> reportScan(String scanId) => _apiClient.reportScan(scanId);
}
