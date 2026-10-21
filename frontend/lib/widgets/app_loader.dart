import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/auth/auth_page.dart';
import 'package:frontend/widgets/map_page.dart';
import 'package:provider/provider.dart';

class AppLoader extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    return FutureBuilder(
      future: authService.isAuthenticated,
      builder: (context, snapshot) => snapshot.hasData
          ? snapshot.data!
                ? MapPage()
                : AuthPage()
          : Center(child: CircularProgressIndicator()),
    );
  }
}
