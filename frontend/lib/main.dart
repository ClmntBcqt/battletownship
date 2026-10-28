import 'package:flutter/material.dart';
import 'package:frontend/config/config.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/services/api_client.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/http_client.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/scans_service.dart';
import 'package:provider/provider.dart';

void main() async {
  AppConfig.validate();

  WidgetsFlutterBinding.ensureInitialized();

  final httpClient = await HttpClient.create(
    baseOptions: ApiClient.defaultOptions,
  );
  final apiClient = ApiClient(httpClient);

  final authService = AuthService(apiClient);
  final mapService = MapService(apiClient);
  final scanService = ScanService(apiClient);

  runApp(
    MyApp(
      authService: authService,
      mapService: mapService,
      scanService: scanService,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this._authService,
    required this._mapService,
    required this._scanService,
  });

  final AuthService _authService;
  final MapService _mapService;
  final ScanService _scanService;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authService),
        ChangeNotifierProvider.value(value: _mapService),
        ChangeNotifierProvider.value(value: _scanService),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        routerConfig: goRouter,
      ),
    );
  }
}
