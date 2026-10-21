import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

Future<Dio> getDio(BaseOptions? baseOptions) async {
  final dio = Dio(baseOptions);

  final appDocDir = await getApplicationDocumentsDirectory();

  final persistCookieJar = PersistCookieJar(
    storage: FileStorage("${appDocDir.path}/.cookies"),
  );

  dio.interceptors.add(CookieManager(persistCookieJar));

  // Contourner la vérification du certificat SSL en développement local
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback = (
      X509Certificate cert,
      String host,
      int port,
    ) => true;
    return client;
  };

  return dio;
}

void addAuthTokenTo(Dio dio, String token) {}
