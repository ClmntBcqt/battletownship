import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

Future<Dio> getDio(BaseOptions? baseOptions) async {
  final dio = Dio(baseOptions);

  final appDocDir = await getApplicationDocumentsDirectory();

  final persistCookieJar = PersistCookieJar(
    storage: FileStorage("${appDocDir.path}/.cookies"),
  );

  dio.interceptors.add(CookieManager(persistCookieJar));

  return dio;
}

void addAuthTokenTo(Dio dio, String token) {}
