import 'package:flutter/material.dart';
import 'package:mosigg/login/login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/* component */
Text text(content, size, weight, colors) {
  return Text(
    content,
    style: TextStyle(fontSize: size, fontWeight: weight, color: colors));
}

Row splitrow(type, info) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      text(type, 14.0, FontWeight.w500, Colors.black),
      text(info, 14.0, FontWeight.w400, Colors.black)
    ],
  );
}

Row splitrow2(type, info) { //뚱뚱한버전
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      text(type, 16.0, FontWeight.w500, Colors.black),
      text(info, 16.0, FontWeight.bold, Colors.black)
    ],
  );
}

Container gohome(BuildContext context) {
  return Container(
    width: double.infinity,
    height: 56,
    padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 16.0),
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      },
      child: text('홈', 14.0, FontWeight.w500, Colors.white),
      style: ElevatedButton.styleFrom(primary: Color(0xff001a5d)),
    ),
  );
}

/* class */
class Recent {
  final String service;
  Recent({ required this.service });

  factory Recent.fromJson(Map<String, dynamic> json) {
    return Recent(
      service: json['tablename'],
    );
  }

  @override
  String toString() => '$service';
}

class Car {
  final String cartype;
  final String carname;
  final String carnumber;
  Car({
    required this.cartype,
    required this.carname,
    required this.carnumber,
  });
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      cartype: json['model'],
      carname: json['name'],
      carnumber: json['number'],
    );
  }
}

/* function */
Future<LatLng> getCarCoord(String carLocation) async {
  late LatLng carCoord;

  Map<String, String> headers = {
    'X-NCP-APIGW-API-KEY-ID': '8eluft3bx7',
    'X-NCP-APIGW-API-KEY': 'Zt0hrdTDUsti4s8cPOlpz26QBfz4Rm6lFUHGBGfG'
  };

  final response = await http.get(
    Uri.parse('https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$carLocation'),
    headers: headers
  );

  if (response.statusCode == 200) {
    carCoord = LatLng(
      double.parse(jsonDecode(response.body)['addresses'][0]['y']),
      double.parse(jsonDecode(response.body)['addresses'][0]['x'])
    );
    return carCoord;
  } else {
    throw Exception('Failed to get coordinates of car');
  }
}