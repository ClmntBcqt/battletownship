import 'package:flutter/material.dart';
import 'package:frontend/widgets/auth/auth_form.dart';

class AuthPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
        ),
        padding: EdgeInsets.all(32),
        child: Column(
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
