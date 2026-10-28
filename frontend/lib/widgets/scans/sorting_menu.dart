import 'package:flutter/material.dart';
import 'package:frontend/services/scans_service.dart';
import 'package:provider/provider.dart';

class SortingMenu extends StatefulWidget {
  const new({super.key});

  @override
  State<SortingMenu> createState() => _SortingMenuState();
}

class _SortingMenuState extends State<SortingMenu> {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      animated: true,
      menuChildren: ScanSortingOptions.values
          .map(
            (sortOption) => MenuItemButton(
              onPressed: () => context.read<ScanService>().setSort(sortOption),
              child: Text("Par ${sortOption.label.toLowerCase()}"),
            ),
          )
          .toList(),
      builder: (_, controller, _) => ElevatedButton.icon(
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
        style: ElevatedButton.styleFrom(elevation: 1),
        icon: Icon(Icons.sort),
        label: Text(context.watch<ScanService>().currentSort.label),
      ),
    );
  }
}
