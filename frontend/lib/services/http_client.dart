import 'dart:convert';

import 'package:dio/dio.dart';

import 'default_dio.dart'
    if (dart.library.html) 'web_dio.dart'
    if (dart.library.js_interop) 'web_dio.dart';

class HttpClient {
  late Dio http;

  HttpClient._internal(this.http);

  static Future<HttpClient> create({BaseOptions? baseOptions}) async {
    final dio = await getDio(baseOptions); // Votre fonction async
    return HttpClient._internal(dio);
  }

  Future<Response> get(String url) {
    return http.get(url);
  }

  Future<Response> post(String url, Object? data) async {
    return http.post(url, data: jsonEncode(data));
  }
}
