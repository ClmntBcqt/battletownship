import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpClient {
  Future<http.Response> get(String url, {Map<String, String>? headers}) {
    return http.get(Uri.parse(url), headers: headers);
  }

  Future<http.Response> post(String url, Object data) {
    return http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: Map.from({"Content-Type": "application/json"}),
    );
  }
}
