import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson2/geojson2/geojson_layer.dart';
import 'package:frontend/dtos/scan.dart';
import 'package:frontend/services/township_service.dart';
import 'package:frontend/widgets/map_toolbox.dart';
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

    context.read<TownshipService>().fetchTownships();
  }

  @override
  Widget build(BuildContext context) {
    var townships = context.watch<TownshipService>().townships;
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
  final ScanDto township;
  const new({super.key, required this.township});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showTownshipInfos(context),
      child: GeoJsonLayer.memory(township.geojson),
    );
  }

  Future<void> showTownshipInfos(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(township.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Align(
            alignment: AlignmentGeometry.centerStart,
            child: Text(
              "Scannée par ${township.username} le ${township.createdAt.day}/${township.createdAt.month}/${township.createdAt.year} à ${township.createdAt.hour}h${township.createdAt.minute}",
            ),
          ),
          Image.memory(
            township.picture,
            height: 400,
            width: 400,
            fit: BoxFit.scaleDown,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Ok"),
        ),
      ],
    ),
  );
}
