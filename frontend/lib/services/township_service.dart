import 'package:flutter/material.dart';
import 'package:frontend/dtos/township.dart';
import 'package:frontend/services/api_client.dart';

class TownshipService extends ChangeNotifier {
  final apiClient = ApiClient();

  List<TownshipDto> _townships = [];
  List<TownshipDto> get townships => _townships;

  Future<void> fetchTownships() async {
    _townships = await apiClient.getAllTownships();

    notifyListeners();
  }

  Future<void> addTownship(String name) async {
    await apiClient.addTownship(name);

    await fetchTownships();
  }
}
