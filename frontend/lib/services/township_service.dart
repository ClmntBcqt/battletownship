import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/dtos/township_suggestion.dart';

class TownshipService {
  final _httpClient = Dio(BaseOptions(baseUrl: "https://geo.api.gouv.fr"));

  Timer? _debouce;
  Completer<List<TownshipSuggestionDto>>? _completer;

  List<TownshipSuggestionDto> _suggestions = [];
  List<TownshipSuggestionDto> get suggestions =>
      _suggestions.take(10).toList()
        ..sort((s1, s2) => s1.nom.length.compareTo(s2.nom.length));

  Future<List<TownshipSuggestionDto>> getSuggestions(String text) {
    _debouce?.cancel();

    if (_completer?.isCompleted == false) {
      _completer!.complete([]);
    }

    final completer = Completer<List<TownshipSuggestionDto>>();
    _completer = completer;

    _debouce = Timer(Duration(milliseconds: 400), () async {
      try {
        _suggestions = await _fetchSuggestions(text);

        if (!completer.isCompleted) {
          completer.complete(suggestions);
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.complete([]);
        }
      }
    });

    return completer.future;
  }

  Future<List<TownshipSuggestionDto>> _fetchSuggestions(String text) async {
    var response = await _httpClient.get(
      "/communes?nom=${jsonEncode(text)}&fields=code,nom,codesPostaux&boost=population&limit=30",
    );

    return (response.data as List)
        .map((json) => TownshipSuggestionDto.fromJson(json))
        .toList();
  }
}
