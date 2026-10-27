import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const new({
    super.key,
    required this.navIndex,
    required this.onDestinationSelected,
  });

  final int navIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: [
        NavigationDestination(icon: Icon(Icons.map_outlined), label: "Carte"),
        NavigationDestination(icon: Icon(Icons.list), label: "Mes scans"),
      ],
      selectedIndex: navIndex,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
