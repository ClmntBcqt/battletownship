import 'package:flutter/material.dart';
import 'package:frontend/widgets/fab.dart';
import 'package:frontend/widgets/shared/navbar.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatefulWidget {
  const new({super.key, required this.child});

  final Widget child;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,

      floatingActionButton: _selectedIndex == 0 ? Fab() : null,

      bottomNavigationBar: Navbar(
        navIndex: _selectedIndex,
        onDestinationSelected: selectDestination,
      ),
    );
  }

  void selectDestination(int destinationIndex) {
    if (destinationIndex == _selectedIndex) return;

    setState(() {
      _selectedIndex = destinationIndex;
    });

    context.go(
      "/app${switch (destinationIndex) {
        0 => "/map",
        1 => "/scans",
        2 => "/settings",
        _ => throw Error(),
      }}",
    );
  }
}
