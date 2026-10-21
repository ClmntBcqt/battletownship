import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/dtos/create_scan_request.dart';
import 'package:frontend/dtos/scan.dart';
import 'package:frontend/services/api_client.dart';

class TownshipService extends ChangeNotifier {
  final ApiClient _apiClient;

  TownshipService(this._apiClient);

  List<ScanDto> _townships = [];
  List<ScanDto> get townships => _townships;

  Future<void> fetchTownships() async {
    _townships = await _apiClient.getAllTownships();

    notifyListeners();
  }

  Future<void> addTownship(String townshipName, Uint8List picture) async {
    await _apiClient.addTownship(
      CreateScanRequest(townshipName: townshipName, picture: picture),
    );

    await fetchTownships();
  }
}
