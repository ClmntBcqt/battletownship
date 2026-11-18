import 'package:frontend/pages/settings_page.dart';
import 'package:frontend/pages/settings_user_page.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/pages/auth_page.dart';
import 'package:frontend/pages/map_page.dart';
import 'package:frontend/pages/scan_page.dart';
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
      builder: (_, _, child) => AppLayout(child: child),
      routes: [
        GoRoute(path: "/app/map", builder: (_, _) => MapPage()),
        GoRoute(path: "/app/scans", builder: (_, _) => ScanPage()),
        GoRoute(path: "/app/settings", builder: (_, _) => SettingsPage()),
      ],
    ),

    GoRoute(path: "/settings/user", builder: (_, state) => SettingsUserPage()),

    GoRoute(path: "/auth", builder: (_, _) => AuthPage()),
  ],
);
