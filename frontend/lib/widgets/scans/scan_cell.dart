import 'package:flutter/material.dart';
import 'package:frontend/dtos/scan.dart';
import 'package:frontend/services/scans_service.dart';
import 'package:intl4x/datetime_format.dart';
import 'package:provider/provider.dart';

class ScanCell extends StatelessWidget {
  const new({super.key, required this.scan});

  final ScanDto scan;

  static final _dateFormatter = DateTimeFormat.yearMonthDay(
    locale: .parse("fr-FR"),
    length: .medium,
  );

  static final _timeFormatter = DateTimeFormat.time(
    locale: .parse("fr-FR"),
    timePrecision: .second,
  );

  @override
  Widget build(BuildContext context) {
    final scanService = context.read<ScanService>();
    final isScanSelected = scanService.isSelected(scan);
    final isSelectionEmpty = scanService.isSelectionEmpty;
    return GestureDetector(
      onLongPress: () => scanService.toggleSelect(scan),
      onTap: () => isSelectionEmpty ? null : scanService.toggleSelect(scan),
      child: Stack(
        children: [
          Column(
            children: [
              Transform.scale(
                scale: isScanSelected ? .86 : 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: .circular(22),
                    border: .all(
                      color: isScanSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 6,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: .circular(16),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Stack(
                        fit: .expand,
                        children: [
                          Image.memory(scan.picture, fit: .cover),
                          Positioned(
                            right: 0,
                            left: 0,
                            bottom: 0,
                            top: 0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: .topCenter,
                                  end: .bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black87,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            left: 8,
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  _dateFormatter.format(scan.createdAt),
                                  style: TextStyle(color: Colors.white),
                                  overflow: .ellipsis,
                                ),
                                Text(
                                  _timeFormatter.format(scan.createdAt),
                                  style: TextStyle(color: Colors.white),
                                  overflow: .ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                spacing: 4,
                                children: [
                                  if (scan.hasTownship)
                                    Transform.scale(
                                      scale: .8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainer,
                                          shape: .circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(Icons.flag),
                                        ),
                                      ),
                                    ),
                                  if (scan.reportNumber > 0)
                                    Transform.scale(
                                      scale: .8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainer,
                                          shape: .circle,
                                        ),
                                        child: Padding(
                                          padding: const .all(4),
                                          child: Badge.count(
                                            backgroundColor: Colors.orange,
                                            count: scan.reportNumber,
                                            child: Icon(Icons.warning),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  scan.townshipName,
                  style: TextStyle(fontWeight: .bold),
                  overflow: .ellipsis,
                ),
              ),
              Spacer(),
            ],
          ),
          if (isScanSelected)
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
