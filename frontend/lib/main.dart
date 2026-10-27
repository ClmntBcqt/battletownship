import 'package:flutter/material.dart';
import 'package:frontend/config/config.dart';
import 'package:frontend/services/api_client.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/http_client.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/app_loader.dart';
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
  final townshipService = ApiService(apiClient);

  await initializeDateFormatting("fr_FR", null);

  runApp(MyApp(authService: authService, townshipService: townshipService));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this._authService,
    required this._townshipService,
  });

  final AuthService _authService;
  final ApiService _townshipService;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: _authService),
          ChangeNotifierProvider.value(value: _townshipService),
        ],
        child: AppLoader(),
      ),
    );
  }
}
