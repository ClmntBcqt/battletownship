import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson2/geojson2/default_features.dart';
import 'package:flutter_map_geojson2/geojson2/geojson_layer.dart';
import 'package:frontend/dtos/township.dart';
import 'package:frontend/services/map_service.dart';
import 'package:frontend/widgets/map/map_toolbox.dart';
import 'package:frontend/widgets/map/scan_infos.dart';
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

  Future<void> showTownshipInfos(BuildContext c) {
    return showDialog(
      context: c,
      builder: (context) => ScanInfos(township: _township),
    );
  }
}
