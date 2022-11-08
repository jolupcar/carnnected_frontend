import 'package:flutter/material.dart';
import 'package:mosigg/map/gasstation.dart';
import 'package:mosigg/map/carwash.dart';
import 'package:proj4dart/proj4dart.dart';
import 'package:mosigg/map/repairshop.dart';
import 'package:mosigg/map/electriccar.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List>? gasStationAddr3;

class MapList extends StatefulWidget {
  const MapList({Key? key}) : super(key: key);

  @override
  State<MapList> createState() => _MapListState();
}

class _MapListState extends State<MapList> {
  //late Future<Position> position;
  Future<List>? gasStationData1, gasStationData2, gasStationData3;

  @override
  void initState() {
    super.initState();
    gasStationData1 = getGasStationFromRad1(127.060926, 37.619774);
    gasStationData2 = getGasStationFromRad2(127.060926, 37.619774);
    gasStationData3 = getGasStationFromPri(127.060926, 37.619774);
    //position = getCurrentLocation();
  }

  // Future<Position> getCurrentLocation() async {
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   return position;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(49),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: Color(0xff001A5D),
                labelColor: Colors.black,
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
                tabs: [
                  Tab(text: '주유소'),
                  Tab(text: '세차장'),
                  Tab(text: '정비소'),
                  Tab(text: '전기차')
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              GasStation(
                  data1: gasStationData1,
                  data2: gasStationData2,
                  data3: gasStationData3),
              CarWash(long: 127.060926, lat: 37.619774),
              RepairShop(long: 127.060926, lat: 37.619774),
              ElectricCar(long: 127.060926, lat: 37.619774),
            ],
          ),
        ),
      ),
    );
  }
}

/* 오피넷 거리 2km로 주유소 정보 받아오는 코드 */
Future<List> getGasStationFromRad1(long, lat) async {
  late double katecX, katecY;

  var point = Point(x: long, y: lat);
  var katecPoint = transCoord('위도', point);

  katecX = katecPoint.x;
  katecY = katecPoint.y;

  final responseGas = await http.get(Uri.parse(
      'http://www.opinet.co.kr/api/aroundAll.do?code=F220207018&x=$katecX&y=$katecY&radius=2000&sort=2&prodcd=B027&out=json'));
  if (responseGas.statusCode == 200) {
    List<dynamic> json = jsonDecode(responseGas.body)['RESULT']['OIL'];
    late List<GasRad1> gasStationList1 = [];

    for (var i = 0; i < json.length; i++) {
      Point point = transCoord(
          '카텍', Point(x: json[i]['GIS_X_COOR'], y: json[i]['GIS_Y_COOR']));
      final responseGps = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${point.y},${point.x}&key=AIzaSyAU9xreP16vriX0jhzLaWiNGQbGsYQQrnw&language=ko"));
      if (responseGps.statusCode == 200) {
        String addr = jsonDecode(responseGps.body)['results'][0]['formatted_address'];
        gasStationList1.add(GasRad1.fromJson(json[i], addr));
      } else {
        throw Exception('Fail to google Geocoding');
      }
    }
    return gasStationList1;
  } else {
    throw Exception('Failed to load gas station data');
  }
}

class GasRad1 {
  final String name;
  final int price;
  final double long;
  final double lat;
  final String addr;

  GasRad1({
    required this.name,
    required this.price,
    required this.long,
    required this.lat,
    required this.addr
  });

  factory GasRad1.fromJson(Map<dynamic, dynamic> json, String addr) {
    Point point =
        transCoord('카텍', Point(x: json['GIS_X_COOR'], y: json['GIS_Y_COOR']));
    return GasRad1(
        name: json['OS_NM'],
        price: json['PRICE'],
        long: point.x,
        lat: point.y,
        addr: addr);
  }

  @override
  String toString() => '$addr';
}

/* 오피넷 거리 5km로 주유소 정보 받아오는 코드 */
Future<List> getGasStationFromRad2(long, lat) async {
  late double katecX, katecY;

  var point = Point(x: long, y: lat);
  var katecPoint = transCoord('위도', point);

  katecX = katecPoint.x;
  katecY = katecPoint.y;

  final responseGas = await http.get(Uri.parse(
      'http://www.opinet.co.kr/api/aroundAll.do?code=F220207018&x=$katecX&y=$katecY&radius=5000&sort=2&prodcd=B027&out=json'));
  if (responseGas.statusCode == 200) {
    List<dynamic> json = jsonDecode(responseGas.body)['RESULT']['OIL'];
    late List<GasRad2> gasStationList2 = [];

    for (var i = 0; i < json.length; i++) {
      Point point = transCoord(
          '카텍', Point(x: json[i]['GIS_X_COOR'], y: json[i]['GIS_Y_COOR']));
      final responseGps = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${point.y},${point.x}&key=AIzaSyAU9xreP16vriX0jhzLaWiNGQbGsYQQrnw&language=ko"));
      if (responseGps.statusCode == 200) {
        String addr = jsonDecode(responseGps.body)['results'][0]['formatted_address'];
        gasStationList2.add(GasRad2.fromJson(json[i], addr));
      } else {
        throw Exception('Fail to google Geocoding');
      }
    }
    return gasStationList2;
  } else {
    throw Exception('Failed to load gas station data');
  }
}

class GasRad2 {
  final String name;
  final int price;
  final double long;
  final double lat;
  final String addr;

  GasRad2({
    required this.name,
    required this.price,
    required this.long,
    required this.lat,
    required this.addr
  });

  factory GasRad2.fromJson(Map<dynamic, dynamic> json, String addr) {
    Point point =
        transCoord('카텍', Point(x: json['GIS_X_COOR'], y: json['GIS_Y_COOR']));
    return GasRad2(
        name: json['OS_NM'],
        price: json['PRICE'],
        long: point.x,
        lat: point.y,
        addr: addr);
  }

  @override
  String toString() => '$addr';
}

/* 오피넷 가격순 반경 5km로 주유소 정보 받아오는 코드 */
Future<List> getGasStationFromPri(long, lat) async {
  late double katecX, katecY;

  var point = Point(x: long, y: lat);
  var katecPoint = transCoord('위도', point);

  katecX = katecPoint.x;
  katecY = katecPoint.y;

  final responseGas = await http.get(Uri.parse(
      'http://www.opinet.co.kr/api/aroundAll.do?code=F220207018&x=$katecX&y=$katecY&radius=5000&sort=1&prodcd=B027&out=json'));
  if (responseGas.statusCode == 200) {
    List<dynamic> json = jsonDecode(responseGas.body)['RESULT']['OIL'];
    late List<GasPri> gasStationList3 = [];

    for (var i = 0; i < json.length; i++) {
      Point point = transCoord(
          '카텍', Point(x: json[i]['GIS_X_COOR'], y: json[i]['GIS_Y_COOR']));
      final responseGps = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${point.y},${point.x}&key=AIzaSyAU9xreP16vriX0jhzLaWiNGQbGsYQQrnw&language=ko"));
      if (responseGps.statusCode == 200) {
        String addr = jsonDecode(responseGps.body)['results'][0]['formatted_address'];
        gasStationList3.add(GasPri.fromJson(json[i], addr));
      } else {
        throw Exception('Fail to google Geocoding');
      }
    }
    return gasStationList3;
  } else {
    throw Exception('Failed to load gas station data');
  }
}

class GasPri {
  final String name;
  final int price;
  final double long;
  final double lat;
  final String addr;

  GasPri(
      {required this.name,
      required this.price,
      required this.long,
      required this.lat,
      required this.addr});

  factory GasPri.fromJson(Map<dynamic, dynamic> json, String addr) {
    Point point =
        transCoord('카텍', Point(x: json['GIS_X_COOR'], y: json['GIS_Y_COOR']));
    return GasPri(
        name: json['OS_NM'],
        price: json['PRICE'],
        long: point.x,
        lat: point.y,
        addr: addr);
  }

  @override
  String toString() => '$addr';
}

/* 좌표 변환 함수 */
Point transCoord(String type, Point point) {
  late Point resultPoint;

  var grs80 = Projection.get('grs80') ??
      Projection.add('grs80',
          '+proj=tmerc +lat_0=38 +lon_0=128 +k=0.9999 +x_0=400000 +y_0=600000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43');
  var wgs84 = Projection.get('wgs84') ??
      Projection.add('wgs84',
          '+title=WGS 84 (long/lat) +proj=longlat +ellps=WGS84 +datum=WGS84 +units=degrees');

  if (type == '위도') {
    resultPoint = wgs84.transform(grs80, point);
  } else if (type == '카텍') {
    resultPoint = grs80.transform(wgs84, point);
  } else {
    resultPoint = Point(x: 0, y: 0);
  }

  return resultPoint;
}
