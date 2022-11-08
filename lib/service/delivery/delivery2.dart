import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mosigg/service/delivery/delivery3.dart';
import 'package:mosigg/service/delivery/delivery5.dart';
import 'package:mosigg/components.dart';

class Delivery2 extends StatefulWidget {
  final String id;
  final String dateAndTime;
  final String carLocation;
  final String carDetailLocation;
  final String desLocation;
  final String desDetailLocation;
  final String payment;
  final LatLng carCoord;
  final LatLng desCoord;

  const Delivery2(
      {Key? key,
      required this.id,
      required this.dateAndTime,
      required this.carLocation,
      required this.carDetailLocation,
      required this.desLocation,
      required this.desDetailLocation,
      required this.payment,
      required this.carCoord,
      required this.desCoord})
      : super(key: key);
  @override
  _Delivery2State createState() => _Delivery2State();
}

class _Delivery2State extends State<Delivery2> {
  late String id;
  String carnumber = '102허2152';
  List<Marker> _markers = [];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late CameraPosition markerCam;
  late List gasCoordData;

  Completer<GoogleMapController> _controller = Completer();
  int price = 0;
  var btnclicked = 0;

  void initState() {
    super.initState();
    id = widget.id;
    var _latitude = (widget.carCoord.latitude+widget.desCoord.latitude)/2;
    var _longitude = (widget.carCoord.longitude+widget.desCoord.longitude)/2;
    getPrice(widget.carCoord, widget.desCoord);

    markerCam = CameraPosition(target: LatLng(_latitude, _longitude), zoom: 10);
    makeMarker();
  }

  Future<int> getPrice(LatLng src, LatLng dest) async {
    final response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&mode=transit&origins=${src.latitude},${src.longitude}&destinations=${dest.latitude},${dest.longitude}&region=KR&key=AIzaSyBJHfzckYIvqPrJT1rO_GY3xL6BVfQmTGs'));
    var temp = jsonDecode(response.body)['rows'][0]['elements'][0]['distance']['text'].split(' ');
    var dist = double.parse(temp[0]).round();
    print(dist);

    var prc = dist*3000;
    return prc;
  }

  void makeMarker() async {
    _addMarker(0, widget.carCoord.latitude, widget.carCoord.longitude, "출발");
    _addMarker(1, widget.desCoord.latitude, widget.desCoord.longitude, "도착");
  }

  void _addMarker(id, x, y, loc) async {
    final MarkerId markerId = MarkerId(id.toString());
    Uint8List markerIcon = await getBytesFromCanvas(120, 80, loc);

    Marker marker = new Marker(
        markerId: markerId,
        icon: BitmapDescriptor.fromBytes(markerIcon),
        draggable: false,
        position: LatLng(x, y));

    setState(() {
      _markers.add(marker);
    });
  }

  Future<Uint8List> getBytesFromCanvas(int width, int height, String txt) async {
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
      text: txt,
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
          title: text('딜리버리 서비스 예약', 16.0, FontWeight.w500, Colors.black),
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
        padding: EdgeInsets.fromLTRB(40.0, 0.0, 10.0, 0.0),
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        child: TextButton(
          child: text("계속하기", 14.0, FontWeight.w500, Color(0xffffffff)),
          onPressed: () {
            showLoadingIndicator();
          },
          style: TextButton.styleFrom(
            backgroundColor: Color(0xff001A5D),
          ),
        ),
      ),
    );
  }

  void showLoadingIndicator() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 183.0,
            width: 300.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 29.0),
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(color: Color(0xff001A5D))
                ),
                SizedBox(height: 13.0),
                text("예약 진행중!", 14.0, FontWeight.w500, Colors.black),
                text("예약 진행을 취소하시려면 아래 취소 버튼을 눌러주세요!", 10.0, FontWeight.w400, Colors.black),
                SizedBox(height: 23.0),
                SizedBox(
                  width: 300.0,
                  height: 34.0,
                  child: TextButton(
                    onPressed: (){
                      cancelButton(id, carnumber, widget.dateAndTime);
                      btnclicked = 1;
                      Navigator.pop(context);
                    },
                    child: text("취소", 14.0, FontWeight.w500, Color(0xffffffff)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xff001A5D)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0)
                        )
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
    var insertcheck = await deliveryRsv(id, carnumber, widget.dateAndTime, widget.carLocation, widget.carDetailLocation, widget.desLocation, widget.desDetailLocation, widget.payment, price);
    var loadingcheck = await loadingAction(id, carnumber, widget.dateAndTime);
    Navigator.pop(context);
    
    if(insertcheck == false || loadingcheck != "true"){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 183.0,
              width: 300.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 29.0),
                  Icon(
                    Icons.priority_high,
                    color: Color(0xff001A5D),
                    size: 50.0,
                  ),
                  SizedBox(height: 13.0),
                  text("앗! 예약에 실패했습니다!", 14.0, FontWeight.w500, Colors.black),
                  text("다시 시도하시려면 다시하기 버튼을 클릭해주세요!", 10.0, FontWeight.w400, Colors.black),
                  SizedBox(height: 23.0),
                  Row(
                    children: [
                      SizedBox(
                        width: 150.0,
                        height: 34.0,
                        child: TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                  Delivery5(id: id)));
                          },
                          child: text("취소", 14.0, FontWeight.w500, Color(0xff000000)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xfff5f5f5)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0)
                              )
                            )
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150.0,
                        height: 34.0,
                        child: TextButton(
                          onPressed: (){Navigator.pop(context);},
                          child: text("다시하기", 14.0, FontWeight.w500, Color(0xffffffff)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xff001A5D)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0)
                              )
                            )
                          ),
                  
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      );
    }
    else{
      Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Delivery3(
          id: id,
          dateAndTime: widget.dateAndTime,
          carLocation: widget.carLocation,
          carDetailLocation: widget.carDetailLocation,
          desLocation: widget.desLocation,
          desDetailLocation: widget.desDetailLocation,
          payment: widget.payment,
          price: price.toString(),
        )));
    }
  }
}

Future<bool> deliveryRsv(
    String id,
    String carNum,
    String dateAndTime,
    String carLocation,
    String carDetailLocation,
    String desLocation,
    String desDetailLocation,
    String payment,
    int price) async {
  final response = await http.get(Uri.parse(
      'http://172.30.1.24:8080/deliv_resrv/$id/$carNum/$dateAndTime/$carLocation/$carDetailLocation/$desLocation/$desDetailLocation/$payment/$price'));
  if (response.statusCode == 200) {
    print('댕같이성공 ${response.body}');
    if(json.decode(response.body) == true)  return true;
    else  return false;
  } else {
    print('개같이실패 ${response.statusCode}');
    return false;
  }
}

Future<String> loadingAction(String id, String carnumber, String time) async {
  final response = await http.get(Uri.parse('http://172.30.1.24:8080/deliv_resrv/$id/$carnumber/$time'));

  if (response.statusCode == 200) {
    var rt = response.body.toString();
    return rt;
  } else
    throw Exception('Failed to loading');
}

Future<String> cancelButton(String id, String carnumber, String time) async {
  final response = await http.get(Uri.parse('http://172.30.1.24:8080/deliv_cancel/$id/$carnumber/$time'));

  if (response.statusCode == 200) {
    var rt = response.body.toString();
    return rt;
  } else
    throw Exception('Failed to loading');
}