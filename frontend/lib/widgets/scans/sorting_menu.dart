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
    final scanService = context.watch<ScanService>();
    return MenuAnchor(
      animated: true,
      menuChildren: ScanSortingOptions.values
          .map(
            (sortOption) => MenuItemButton(
              onPressed: () =>
                  context.read<ScanService>().toogleSort(sortOption),
              leadingIcon: Icon(
                sortOption == scanService.currentSort
                    ? scanService.isSortReversed
                          ? Icons.arrow_upward
                          : Icons.arrow_downward
                    : null,
              ),
              child: Text(sortOption.label),
            ),
          )
          .toList(),
      builder: (_, controller, _) => IconButton.filledTonal(
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
        icon: Icon(Icons.sort),
      ),
    );
  }
}
