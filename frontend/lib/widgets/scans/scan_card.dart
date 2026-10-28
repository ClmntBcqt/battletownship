import 'package:flutter/material.dart';
import 'package:frontend/dtos/scan.dart';
import 'package:intl4x/datetime_format.dart';

class ScanCard extends StatelessWidget {
  const new({super.key, required this.scan});

  final double _imageHeight = 120;
  final ScanDto scan;

  static final dateTimeFormatter = DateTimeFormat.yearMonthDayTime(
    locale: .parse("fr-FR"),
    timePrecision: .second,
    length: .short,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    scan.townshipName,
                    overflow: .ellipsis,
                    style: TextStyle(fontWeight: .bold),
                    textHeightBehavior: TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    dateTimeFormatter.format(scan.createdAt),
                    textAlign: .end,
                    overflow: .ellipsis,
                    textHeightBehavior: TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  flex: 15,
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: .circular(_imageHeight / 10),
                      child: Image.memory(scan.picture, fit: .cover),
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Opacity(
                    opacity: scan.hasTownship ? 1 : 0,
                    child: Icon(Icons.flag),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Opacity(
                    opacity: scan.reportNumber == 0 ? 0 : 1,
                    child: Row(
                      spacing: 4,
                      mainAxisAlignment: .center,
                      children: [
                        Icon(Icons.warning),
                        Text("(${scan.reportNumber})"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
