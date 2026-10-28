import 'package:flutter/material.dart';
import 'package:frontend/services/scans_service.dart';
import 'package:provider/provider.dart';

class FilterBar extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: "Nom de commune",
      textStyle: WidgetStatePropertyAll<TextStyle>(
        Theme.of(context).textTheme.bodySmall!,
      ),
      constraints: BoxConstraints.tightFor(height: 40),
      leading: Icon(Icons.search),
      padding: const WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 16),
      ),
      elevation: const WidgetStatePropertyAll<double>(1),
      backgroundColor: WidgetStatePropertyAll<Color>(
        Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      onChanged: (filter) => context.read<ScanService>().setFilter(filter),
    );
  }
}
