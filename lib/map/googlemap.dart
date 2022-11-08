import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mosigg/components.dart';
import 'package:mosigg/map/common/tabbarWidget.dart';

class MapPage extends StatefulWidget {
  final Location location;
  
  MapPage({Key? key, required this.location}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}
 
class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};
  late Uint8List markerIcon;
  late CameraPosition markerCam;

  @override
  void initState(){
    super.initState();
    markerCam = CameraPosition(target: LatLng(widget.location.y, widget.location.x), zoom: 17);
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    markerIcon = await getBytesFromAsset('image/marker.png', 80);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: text('위치 확인', 16.0, FontWeight.w500, Colors.black),
        toolbarHeight: 56.0,
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: markers,
        initialCameraPosition: markerCam,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          setState(() {
            markers.add(
              Marker(
                markerId: MarkerId('서비스'),
                position: LatLng(widget.location.y, widget.location.x),
                icon: BitmapDescriptor.fromBytes(markerIcon)
              )
            );
          });
        },
      ),
    );
  }
}