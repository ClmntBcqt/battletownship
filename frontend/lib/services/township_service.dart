import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/dtos/create_scan_request.dart';
import 'package:frontend/dtos/scan.dart';
import 'package:frontend/services/api_client.dart';

class TownshipService extends ChangeNotifier {
  final apiClient = ApiClient();

  List<ScanDto> _townships = [];
  List<ScanDto> get townships => _townships;

  Future<void> fetchTownships() async {
    _townships = await apiClient.getAllTownships();

    notifyListeners();
  }

  Future<void> addTownship(
    String townshipName,
    String username,
    Uint8List picture,
  ) async {
    await apiClient.addTownship(
      CreateScanRequest(
        townshipName: townshipName,
        username: username,
        picture: picture,
      ),
    );

    await fetchTownships();
  }
}
