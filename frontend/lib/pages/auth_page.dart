import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/auth/auth_form.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const new({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isPageLoading = true;

  @override
  void initState() {
    super.initState();

    final authService = context.read<AuthService>();

    authService.isAuthenticated.then((isAuthenticated) {
      if (!mounted) return;
      if (isAuthenticated) context.go("/map");

      setState(() {
        _isPageLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
        ),
        padding: EdgeInsets.all(32),
        child: _isPageLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: .spaceAround,
                children: [
                  Expanded(flex: 10, child: AppTitle()),
                  Expanded(flex: 15, child: AuthForm()),
                ],
              ),
      ),
    );
  }
}

class AppTitle extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          Text(
            "Battlemap",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontWeight: .bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Icon(
            Icons.travel_explore,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
