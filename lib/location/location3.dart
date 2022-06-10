import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mosigg/location/common/map.dart';
import 'package:mosigg/location/location2.dart';

class LocationSearchPage3 extends StatefulWidget {
  const LocationSearchPage3({Key? key}) : super(key: key);

  @override
  _LocationSearchPage3State createState() => _LocationSearchPage3State();
}

class _LocationSearchPage3State extends State<LocationSearchPage3> {
  var latitude;
  var longitude;
  late String addr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
              color: Colors.black),
          title: Text('현재 위치로 검색',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'NotoSansKR',
                  fontWeight: FontWeight.w500)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Flexible(
                child: FutureBuilder<Position>(
                    future: getCurrentLocation(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return Column(
                          children: [
                            Text('지도를 불러오는 중입니다'),
                            SizedBox(),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('지도 불러오기 에러!');
                      } else {
                        latitude = snapshot.data!.latitude;
                        longitude = snapshot.data!.longitude;
                        print(
                            '${snapshot.data!.latitude}, ${snapshot.data!.longitude}');
                        return GoogleMapBody(
                            coordX: snapshot.data!.longitude,
                            coordY: snapshot.data!.latitude);
                      }
                    })),
            Container(
                padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder(
                        future: revGeoCoding(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            addr = snapshot.data!.toString();
                            return Text(snapshot.data!.toString());
                          } else {
                            return Text('주소를 불러오지 못했습니다');
                          }
                        }),
                    InkWell(
                        onTap: () async {
                          final _ = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LocationSearchPage2(
                                          addr: addr,
                                          latitude: latitude,
                                          longitude: longitude))).then((val) {
                            if (val != null) {
                              Navigator.pop(context, val);
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 16),
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color(0xff001a5d),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '이 위치로 주소 설정',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'NotoSansKR',
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ))
          ],
        ));
  }
}

/*현재 위치 불러오기*/
Future<Position> getCurrentLocation() async {
  //LocationPermission permission = await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return position;
}

Future<String> revGeoCoding() async {
  LocationPermission permission = await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&language=ko&key=AIzaSyBJHfzckYIvqPrJT1rO_GY3xL6BVfQmTGs'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['results'][0]['formatted_address']
        .toString()
        .substring(5);
  } else {
    return '역지오코딩 에러';
  }
}
