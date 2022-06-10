import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class GoogleMapBody extends StatefulWidget {
  final double coordX;
  final double coordY;

  const GoogleMapBody({Key? key, required this.coordX, required this.coordY})
      : super(key: key);

  @override
  _GoogleMapBodyState createState() => _GoogleMapBodyState();
}

class _GoogleMapBodyState extends State<GoogleMapBody> {
  Completer<GoogleMapController> _controller = Completer();

  late final CameraPosition markerCam;

  List<Marker> markers = [];

  void initState() {
    super.initState();
    markerCam = CameraPosition(
        target: LatLng(widget.coordY, widget.coordX), zoom: 17.0);
    markers.add(Marker(
      markerId: MarkerId("1"),
      draggable: true,
      position: LatLng(widget.coordY, widget.coordX),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set.from(markers),
        initialCameraPosition: markerCam,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
