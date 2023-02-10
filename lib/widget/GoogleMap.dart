import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatelessWidget {

  final CameraPosition? cameraPosition;
  final Set<Marker>? markers;
  final MapCreatedCallback? mapCreate;

  const CustomGoogleMap({this.cameraPosition,this.markers,this.mapCreate});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      myLocationEnabled: true,
      buildingsEnabled: true,
      initialCameraPosition: cameraPosition!,
      markers: markers!,
      onMapCreated: mapCreate,
    );
  }
}
