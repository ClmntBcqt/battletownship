import 'package:flutter/material.dart';
import 'package:frontend/config/config.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/services/api_client.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/http_client.dart';
import 'package:frontend/services/api_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  AppConfig.validate();

  WidgetsFlutterBinding.ensureInitialized();

  final httpClient = await HttpClient.create(
    baseOptions: ApiClient.defaultOptions,
  );
  final apiClient = ApiClient(httpClient);

  final authService = AuthService(apiClient);
  final apiService = ApiService(apiClient);

  await initializeDateFormatting("fr_FR", null);

  runApp(MyApp(authService: authService, apiService: apiService));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this._authService,
    required this._apiService,
  });

  final AuthService _authService;
  final ApiService _apiService;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authService),
        ChangeNotifierProvider.value(value: _apiService),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        routerConfig: goRouter,
      ),
    );
  }
}
