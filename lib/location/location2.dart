import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mosigg/location/common/map.dart';
import 'package:mosigg/location/location1.dart';
import 'dart:convert';
import 'package:proj4dart/proj4dart.dart';

class LocationSearchPage2 extends StatefulWidget {
  final String? rn;
  final String addr;
  final String? admCd;
  final String? rnMgtSn;
  final String? udrtYn;
  final String? buldMnnm;
  final String? buldSlno;
  final double? latitude;
  final double? longitude;

  const LocationSearchPage2(
      {Key? key,
      required this.addr,
      this.rn,
      this.admCd,
      this.rnMgtSn,
      this.udrtYn,
      this.buldMnnm,
      this.buldSlno,
      this.latitude,
      this.longitude})
      : super(key: key);

  @override
  State<LocationSearchPage2> createState() => _LocationSearchPage2State();
}

class _LocationSearchPage2State extends State<LocationSearchPage2> {
  var mapCheck = false;
  var coordX;
  var coordY;
  final detailLocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new),
              color: Colors.black),
          title: Text('상세주소 설정',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'NotoSansKR',
                  fontWeight: FontWeight.w500)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(25, 57, 25, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('좀 더 자세한 주소를\n입력해주세요:)',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(height: 9),
              Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.fromLTRB(8, 12, 0, 12),
                height: 105,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                child: Text(
                                  '도로명',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: 'NotoSansKR',
                                  ),
                                ),
                                color: Color(0xffe8eaee)),
                            SizedBox(width: 3),
                            Text(
                              widget.addr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'NotoSansKR',
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: 26,
                      margin: EdgeInsets.only(
                        left: 2,
                        right: 10,
                      ),
                      padding: EdgeInsets.only(left: 8),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3f000000),
                            offset: Offset(0, 0),
                            blurRadius: 1,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: detailLocationController,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'NotoSansKR'),
                        decoration: InputDecoration(
                          hintText: '주차장 이름, 위치 설명',
                          hintStyle: TextStyle(
                            color: Color(0xffa9a9a9),
                            fontSize: 10,
                            fontFamily: 'NotoSansKR',
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          mapCheck = !mapCheck;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 6),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.map_outlined, size: 12),
                              SizedBox(width: 2),
                              Text(
                                '지도에서 위치 확인',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'NotoSansKR',
                                ),
                              )
                            ]),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      offset: Offset(0, 0),
                      blurRadius: 2,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
              mapCheck
                  ? Flexible(
                      child: FutureBuilder<Coordinates>(
                          future: getCoordinates(
                              widget.rn,
                              widget.addr,
                              widget.admCd,
                              widget.rnMgtSn,
                              widget.udrtYn,
                              widget.buldMnnm,
                              widget.buldSlno,
                              widget.latitude,
                              widget.longitude
                              ),
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
                              return GoogleMapBody(
                                  coordX: double.parse(snapshot.data!.coordX),
                                  coordY: double.parse(snapshot.data!.coordY));
                            }
                          }),
                    )
                  : Flexible(child: Container()),
              InkWell(
                  onTap: () {
                    Navigator.pop(context, Addr(addr: widget.addr, detailAddr: detailLocationController.text));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) => Oilstart(
                    //             carLocation: widget.addr,
                    //             carDetailLocation:
                    //                 detailLocationController.text)));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 12, bottom: 16),
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
                          '확인',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ))
            ])));
  }
}

//좌표 통신
Future<Coordinates> getCoordinates(
    String? rn,
    String addr,
    String? admCd,
    String? rnMgtSn,
    String? udrtYn,
    String? buldMnnm,
    String? buldSlno,
    double? latitude,
    double? longitude) async {
  late Coordinates coordinates;

  if (admCd == null) {
    return Coordinates(coordX: longitude.toString(), coordY: latitude.toString());
  } else {
    final response = await http.post(
        Uri.parse(
            'https://www.juso.go.kr/addrlink/addrCoordApi.do?admCd=$admCd&rnMgtSn=$rnMgtSn&udrtYn=$udrtYn&buldMnnm=$buldMnnm&buldSlno=$buldSlno&confmKey=devU01TX0FVVEgyMDIyMDIxNDA1MDA0NjExMjIzODY=&resultType=json'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

    if (response.statusCode == 200) {
      var grs80 = Projection.get('grs80') ??
          Projection.add('grs80',
              '+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +units=m +no_defs');
      var wgs84 = Projection.get('wgs84') ??
          Projection.add('wgs84',
              '+title=WGS 84 (long/lat) +proj=longlat +ellps=WGS84 +datum=WGS84 +units=degrees');

      print(jsonDecode(response.body)['results']['juso']);
      coordinates =
          Coordinates.fromJson(jsonDecode(response.body)['results']['juso'][0]);
      var point = Point(
          x: double.parse(coordinates.coordX),
          y: double.parse(coordinates.coordY));
      var newCoordinates = grs80.transform(wgs84, point);

      return Coordinates(
          coordX: newCoordinates.x.toString(),
          coordY: newCoordinates.y.toString());
    } else {
      throw Exception("좌표 검색에 실패했습니다");
    }
  }
}

class Coordinates {
  final String coordX;
  final String coordY;

  Coordinates({required this.coordX, required this.coordY});

  factory Coordinates.fromJson(Map<dynamic, dynamic> json) {
    return Coordinates(coordX: json['entX'], coordY: json['entY']);
  }
}
