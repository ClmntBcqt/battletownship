import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/auth/auth_page.dart';
import 'package:frontend/widgets/map/map_page.dart';
import 'package:frontend/widgets/scans/scan_page.dart';
import 'package:frontend/widgets/shared/main_layout.dart';
import 'package:go_router/go_router.dart';

GoRouter getGoRouter(AuthService authService) => GoRouter(
  initialLocation: "/auth",

  refreshListenable: authService,

  redirect: (context, state) async {
    final isAuthenticated = await authService.isAuthenticated;

    if (!isAuthenticated) {
      return "/auth";
    }

    return null;
  },

  routes: [
    ShellRoute(
      builder: (_, _, child) => MainLayout(child: child),
      routes: [
        GoRoute(path: "/map", builder: (_, _) => MapPage()),
        GoRoute(path: "/scans", builder: (_, _) => ScanPage()),
      ],
    ),

    GoRoute(path: "/auth", builder: (_, _) => AuthPage()),
  ],
);
