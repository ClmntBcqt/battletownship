import 'package:flutter/material.dart';
import 'package:frontend/config/config.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/services/api_client.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/http_client.dart';
import 'package:frontend/services/map_service.dart';
import 'package:frontend/services/scans_service.dart';
import 'package:frontend/services/township_service.dart';
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
  final townshipService = TownshipService();

  runApp(
    MyApp(
      authService: authService,
      mapService: mapService,
      scanService: scanService,
      townshipService: townshipService,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this._authService,
    required this._mapService,
    required this._scanService,
    required this._townshipService,
  });

  final AuthService _authService;
  final MapService _mapService;
  final ScanService _scanService;
  final TownshipService _townshipService;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authService),
        ChangeNotifierProvider.value(value: _mapService),
        ChangeNotifierProvider.value(value: _scanService),
        Provider.value(value: _townshipService),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        routerConfig: goRouter,
      ),
    );
  }
}
