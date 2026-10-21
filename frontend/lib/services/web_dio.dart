import 'package:dio/dio.dart';
import 'package:dio/browser.dart';

Future<Dio> getDio(BaseOptions? baseOptions) async {
  final dio = Dio(baseOptions);
  dio.httpClientAdapter = BrowserHttpClientAdapter(withCredentials: true);
  return Future.value(dio);
}
