import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson2/geojson2/default_features.dart';
import 'package:flutter_map_geojson2/geojson2/geojson_layer.dart';
import 'package:frontend/dtos/township.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/map/map_toolbox.dart';
import 'package:frontend/widgets/shared/eb10_sign.dart';
import 'package:intl4x/datetime_format.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const new({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final grenobleCoordinates = const LatLng(45.166672, 5.716670);
  final mapController = MapController();

  @override
  void initState() {
    super.initState();

    context.read<MapService>().fetchTownships();
  }

  @override
  Widget build(BuildContext context) {
    var townships = context.watch<MapService>().townships;
    return FlutterMap(
      options: MapOptions(
        initialCenter: grenobleCoordinates,
        initialZoom: 10,
        minZoom: 3,
        maxZoom: 18,
        interactionOptions: InteractionOptions(
          enableMultiFingerGestureRace: true,
        ),
      ),
      mapController: mapController,
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.clementbq.battletownship',
        ),
        ...townships.map((t) => TownshipTile(township: t)),
        MapToolbox(mapController: mapController),
      ],
    );
  }
}

class TownshipTile extends StatelessWidget {
  final TownshipDto _township;
  const new({super.key, required this._township});

  static const _townshipPalette = [
    Colors.amber,
    Colors.lightBlue,
    Colors.brown,
    Colors.deepOrange,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
  ];
  Color get _townshipColor => _townshipPalette
      .elementAt(_township.username.hashCode % _townshipPalette.length)
      .shade700;

  TextSpan get _formatAuthor => TextSpan(
    text: "Scanné par ",
    children: [
      TextSpan(
        text: _township.username,
        style: TextStyle(fontWeight: .w600),
      ),
    ],
  );
  TextSpan get _formatScanDate => TextSpan(
    text: DateTimeFormat.yearMonthDayTime(
      locale: .parse("fr-FR"),
      timePrecision: .second,
      length: .medium,
    ).format(_township.createdAt),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showTownshipInfos(context),
      child: GeoJsonLayer.memory(
        _township.geojson,
        styleDefaults: GeoJsonStyleDefaults(
          fillColor: _townshipColor,
          strokeColor: _townshipColor,
        ),
      ),
    );
  }

  Future<void> showTownshipInfos(BuildContext context) {
    final mapService = context.read<MapService>();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
          alignment: .center,
          child: EB10Sign(text: _township.name),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Align(
              alignment: AlignmentGeometry.centerStart,
              child: Text.rich(
                TextSpan(
                  children: [
                    _formatAuthor,
                    TextSpan(text: "\n"),
                    _formatScanDate,
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: .circular(16),
              child: SizedBox(
                width: 300,
                height: 225,
                child: Image.memory(_township.picture, fit: .cover),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async => await _confirmReport(context, mapService),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text("Signaler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReport(BuildContext context, MapService service) async {
    final confirmed = await _showReportConfirmationPopup(context);

    if (!context.mounted) return;
    if (confirmed) {
      await service.reportScan(_township.scanId);
    }
  }

  Future<bool> _showReportConfirmationPopup(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Êtes-vous sûr ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Annuler"),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Confirmer"),
            ),
          ],
        ),
      ) ??
      false;
}
