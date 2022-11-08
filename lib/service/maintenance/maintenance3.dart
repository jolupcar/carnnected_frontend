import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mosigg/service/maintenance/maintenance4.dart';
import 'package:mosigg/components.dart';

import 'dart:convert';
import 'dart:ui' as ui;

class Maintenance3 extends StatefulWidget {
  final String id;
  final String dateAndTime;
  final String carLocation;
  final String carDetailLocation;
  final String detail;
  final String payment;
  final String type;
  final LatLng carCoord;

  const Maintenance3(
      {Key? key,
      required this.id,
      required this.dateAndTime,
      required this.carLocation,
      required this.carDetailLocation,
      required this.detail,
      required this.payment,
      required this.type,
      required this.carCoord})
      : super(key: key);
  @override
  _Maintenance3State createState() => _Maintenance3State();
}

class _Maintenance3State extends State<Maintenance3> {
  late String id;
  List<Marker> _markers = [];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late CameraPosition markerCam;
  late List fixCoordData;

  Completer<GoogleMapController> _controller = Completer();

  late String fixStationName;
  late String fixStationaddress;

  void initState() {
    super.initState();
    id = widget.id;
    markerCam = CameraPosition(target: widget.carCoord, zoom: 14);
    makeMarker();
  }

  void makeMarker() async {
    fixCoordData = await getFixinfo(widget.carCoord);
    for (var i = 0; i < fixCoordData.length; i++) {
      _addMarker(i, fixCoordData[i].lat, fixCoordData[i].long,
          fixCoordData[i].name, fixCoordData[i].address);
    }
  }

  void _addMarker(id, x, y, name, address) async {
    final MarkerId markerId = MarkerId(id.toString());
    Uint8List markerIcon = await getBytesFromCanvas(150, 80, name);

    Marker marker = new Marker(
        markerId: markerId,
        icon: BitmapDescriptor.fromBytes(markerIcon),
        draggable: false,
        infoWindow: InfoWindow(title: "여기로 예약"),
        onTap: () {
          _infoDialog(context, name, address);
          setState(() {
            fixStationName = name;
            fixStationaddress = address;
          });
        },
        position: LatLng(x, y));

    setState(() {
      _markers.add(marker);
    });
  }

  Future<Uint8List> getBytesFromCanvas(
      int width, int height, String name) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Color(0xff001a5d);
    final Radius radius = Radius.circular(20.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: name,
      style: TextStyle(
          fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: text('정비 서비스 예약', 16.0, FontWeight.w500, Colors.black),
          toolbarHeight: 56.0,
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            // iconSize: 16.0,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.from(_markers),
        initialCameraPosition: markerCam,
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.fromLTRB(55.0, 0.0, 25.0, 0.0),
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        child: TextButton(
          child: text("계속하기", 14.0, FontWeight.w500, Color(0xffffffff)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Maintenance4(
                      id: id,
                      dateAndTime: widget.dateAndTime,
                      carLocation: widget.carLocation,
                      carDetailLocation: widget.carDetailLocation,
                      detail: widget.detail,
                      type: widget.type,
                      payment: widget.payment,
                      destName: fixStationName,
                      destaddr: fixStationaddress,
                    )));
          },
          style: TextButton.styleFrom(
            backgroundColor: Color(0xff001A5D),
          ),
        ),
      ),
    );
  }

  void _infoDialog(BuildContext context, String name, String address) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SimpleDialog(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 12.0)),
                        text(name, 16.0, FontWeight.bold, Colors.black),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 12.0)),
                        Container(
                          width: 24.0,
                          child: Text(
                            "주소",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 8.0,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(color: Color(0xffe8eaee)),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        text(address, 10.0, FontWeight.w500, Colors.black),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}

Future<List> getFixinfo(LatLng addr) async {
  Map<String, String> headers = {
    'X-NCP-APIGW-API-KEY-ID': '8eluft3bx7',
    'X-NCP-APIGW-API-KEY': 'Zt0hrdTDUsti4s8cPOlpz26QBfz4Rm6lFUHGBGfG'
  };

  late List<FIX> fixList = [];

  final responseCrawling = await http.get(Uri.parse(
      'http://172.30.1.24:8080/map/카센터/${addr.latitude}/${addr.longitude}'));

  if (responseCrawling.statusCode == 200) {
    List<dynamic> jsonCrawl = jsonDecode(responseCrawling.body);
    for (var i = 0; i < jsonCrawl.length; i++) {
      print('[크롤링 결과] ${jsonCrawl[i]}');
      var addr = jsonCrawl[i]['address'];
      final responseCoord = await http.get(
          Uri.parse(
              'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$addr'),
          headers: headers);
      if (responseCoord.statusCode == 200) {
        var jsonCoord = jsonDecode(responseCoord.body);
        if (jsonCoord['error'] != null || jsonCoord['addresses'].length == 0)
          continue;
        var long = double.parse(jsonCoord['addresses'][0]['x']);
        var lat = double.parse(jsonCoord['addresses'][0]['y']);

        print('네이버 좌표 결과] $long $lat');
        fixList.add(FIX(
            type: jsonCrawl[i]['type'],
            name: jsonCrawl[i]['name'],
            address: jsonCrawl[i]['address'],
            long: long,
            lat: lat));
      } else {
        throw Exception('Failed to load fix data');
      }
    }
    return fixList;
  } else {
    throw Exception('Failed to load coordinates');
  }
}

///////////////////////////// 내가 원하는 FIX class /////////////////////////////
class FIX {
  final String type;
  final String name;
  final String address;
  final double long;
  final double lat;

  FIX({
    required this.type,
    required this.name,
    required this.address,
    required this.long,
    required this.lat,
  });

  factory FIX.fromJson(Map<dynamic, dynamic> json) {
    return FIX(
      type: json['type'],
      name: json['name'],
      address: json['address'],
      long: json['long'],
      lat: json['lat2'],
    );
  }
}

class FIX1 {
  final String type;
  final String name;
  final String address;

  FIX1({
    required this.type,
    required this.name,
    required this.address,
  });
}
