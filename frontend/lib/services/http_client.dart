import 'dart:convert';

import 'package:dio/dio.dart';

class HttpClient({BaseOptions? baseOptions}) {
  final http = Dio(baseOptions);

  Future<Response> get(String url) {
    return http.get(url);
  }

  Future<Response> post(String url, Object data) async {
    return http.post(url, data: jsonEncode(data));
  }
}
