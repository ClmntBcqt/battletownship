import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson2/geojson2/geojson_layer.dart';
import 'package:frontend/services/township_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const new({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final grenobleCoordinates = const LatLng(45.166672, 5.716670);

  @override
  void initState() {
    super.initState();

    context.read<TownshipService>().fetchTownships();
  }

  @override
  Widget build(BuildContext context) {
    var townships = context.watch<TownshipService>().townships;
    return FlutterMap(
      options: MapOptions(initialCenter: grenobleCoordinates),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.clementbq.battletownship',
        ),
        ...townships.map((town) => GeoJsonLayer.memory(town.geojson)),
      ],
    );
  }
}
