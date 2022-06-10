import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mosigg/location/location2.dart';
import 'package:mosigg/location/location3.dart';

class LocationSearchPage1 extends StatefulWidget {
  final String id;
  const LocationSearchPage1({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _LocationSearchPage1State createState() => _LocationSearchPage1State();
}

class _LocationSearchPage1State extends State<LocationSearchPage1> {
  Future<List>? favoriteAddrData;
  Future<List>? searchAddrData;

  var searchDone = false;

  @override
  void initState() {
    favoriteAddrData = favoriteAddr(widget.id);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new),
              color: Colors.black),
          title: Text('주소 설정',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'NotoSansKR',
                  fontWeight: FontWeight.w500)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Builder(builder: (context) {
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.fromLTRB(25, 57, 25, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('지번, 도로명, 건물명으로\n검색해주세요:)',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(height: 26),
                    Container(
                        alignment: Alignment.centerLeft,
                        height: 25,
                        child: TextField(
                          style: TextStyle(fontSize: 12),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (text) => {
                            print('[location1/onSubmitted]$text'),
                            setState(() {
                              searchAddrData = searchAddr(text);
                              searchDone = true;
                            }),
                          },
                          decoration: InputDecoration(
                            prefixIcon: Container(
                                width: 20,
                                child: Icon(Icons.search),
                                margin: EdgeInsets.only(right: 2)),
                            iconColor: Color(0xff9a9a9a),
                            prefixIconConstraints:
                                BoxConstraints(maxHeight: 30, maxWidth: 26),
                            hintText: '예) 광운로 12',
                            hintStyle: TextStyle(
                              color: Color(0xff9a9a9a),
                              fontSize: 12,
                              fontFamily: 'NotoSansKR',
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xffcbcbcb))),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xffcbcbcb))),
                          ),
                          keyboardType: TextInputType.text,
                        )),
                    SizedBox(height: 6.5),
                    InkWell(
                      onTap: () {
                        final _ = Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LocationSearchPage3())).then((val) {
                          if (val != null) {
                            Navigator.pop(context, val);
                          }
                        });
                      },
                      child: Row(children: [
                        Icon(FeatherIcons.crosshair, size: 18),
                        SizedBox(width: 6.5),
                        Text(
                          '현재 위치로 검색하기',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'NotoSansKR',
                          ),
                        )
                      ]),
                    ),
                    SizedBox(height: 44),
                    searchDone == false
                        ? favoriteAddrWidget(favoriteAddrData)
                        : searchAddrWidget(searchAddrData)
                  ],
                ),
              ));
        }));
  }
}

/*즐겨찾는 주소*/
//즐겨찾는 주소 전체 위젯
Column favoriteAddrWidget(Future<List>? favoriteAddrData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '즐겨찾는 주소',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'NotoSansKR',
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(height: 6),
      FutureBuilder<List>(
        future: favoriteAddrData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length == 0) {
              return Text('즐겨찾는 주소가 없습니다!');
            } else {
              return Container(
                height: snapshot.data!.length * 56,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return addrWidget(context, snapshot.data![index].addr,
                        snapshot.data![index].detailAddr);
                  },
                ),
              );
            }
          } else {
            return Text('즐겨찾는 주소 불러오는 중!');
          }
        },
      ),
    ],
  );
}

//즐겨찾는 주소 결과 부분 위젯
InkWell addrWidget(BuildContext context, String addr, String detailAddr) {
  return InkWell(
    onTap: () {
      Navigator.pop(context, Addr(addr: addr, detailAddr: detailAddr));
    },
    child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
        padding: EdgeInsets.all(8),
        height: 50,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              addr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'NotoSansKR',
              ),
            ),
            SizedBox(height: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Text(
                      '상세주소',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 8,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                    color: Color(0xffe8eaee)),
                SizedBox(width: 3),
                Text(
                  detailAddr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ],
            )
          ],
        )),
  );
}

//즐겨찾는 주소 통신
Future<List> favoriteAddr(String id) async {
  final response =
      await http.get(Uri.parse('http://10.20.10.189:8080/favorite_addr/$id'));
  late List<Addr> favoriteAddrList = [];

  if (response.statusCode == 200) {
    List<dynamic> json = jsonDecode(response.body);
    for (var i = 0; i < json.length; i++) {
      favoriteAddrList.add(Addr.fromJson(json[i]));
    }
    return favoriteAddrList;
  } else {
    throw Exception("즐겨찾는 주소를 불러오는데 실패했습니다");
  }
}

class Addr {
  final String addr;
  final String detailAddr;

  Addr({required this.addr, required this.detailAddr});

  factory Addr.fromJson(Map<String, dynamic> json) {
    return Addr(addr: json['addr'], detailAddr: json['detailAddr']);
  }
}

/*주소 검색*/
//검색결과 전체 위젯
Column searchAddrWidget(Future<List>? searchAddrData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '검색 결과',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'NotoSansKR',
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(height: 6),
      FutureBuilder<List>(
        future: searchAddrData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.length == 0) {
              return Text('검색 결과가 없습니다');
            } else {
              return Container(
                height: snapshot.data!.length * 70.0,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return roadAddrWidget(
                        context,
                        snapshot.data![index].rn,
                        snapshot.data![index].addr,
                        snapshot.data![index].admCd,
                        snapshot.data![index].rnMgtSn,
                        snapshot.data![index].udrtYn,
                        snapshot.data![index].buldMnnm,
                        snapshot.data![index].buldSlno);
                  },
                ),
              );
            }
          } else {
            return Text('검색결과 주소 불러오는중!');
          }
        },
      ),
    ],
  );
}

//검색결과 부분 위젯
InkWell roadAddrWidget(
    BuildContext context,
    String rn,
    String addr,
    String admCd,
    String rnMgtSn,
    String udrtYn,
    String buldMnnm,
    String buldSlno) {
  return InkWell(
    onTap: () async {
      final _ = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => LocationSearchPage2(
                  addr: addr,
                  admCd: admCd,
                  rnMgtSn: rnMgtSn,
                  udrtYn: udrtYn,
                  buldMnnm: buldMnnm,
                  buldSlno: buldSlno))).then((val) {
        if (val != null) {
          Navigator.pop(context, val);
        }
      });
    },
    child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
        padding: EdgeInsets.all(8),
        height: 64,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rn,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'NotoSansKR',
              ),
            ),
            SizedBox(height: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Text(
                      '도로명',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 8,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                    color: Color(0xffe8eaee)),
                SizedBox(width: 3),
                Text(
                  addr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ],
            )
          ],
        )),
  );
}

//검색결과 통신
Future<List> searchAddr(dynamic keyword) async {
  final response = await http.post(
      Uri.parse(
          'https://www.juso.go.kr/addrlink/addrLinkApi.do?currentPage=1&countPerPage=100&keyword=$keyword&confmKey=devU01TX0FVVEgyMDIyMDIxMzE0MjkzMzExMjIzNzc=&resultType=json'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
  late List<RoadAddr> searchAddrList = [];

  if (response.statusCode == 200) {
    List<dynamic> json = jsonDecode(response.body)['results']['juso'];
    for (var i = 0; i < json.length; i++) {
      searchAddrList.add(RoadAddr.fromJson(json[i]));
    }
    return searchAddrList;
  } else {
    throw Exception("검색 결과를 불러오는데 실패했습니다");
  }
}

class RoadAddr {
  final String rn;
  final String addr;
  final String admCd;
  final String rnMgtSn;
  final String udrtYn;
  final String buldMnnm;
  final String buldSlno;

  RoadAddr(
      {required this.rn,
      required this.addr,
      required this.admCd,
      required this.rnMgtSn,
      required this.udrtYn,
      required this.buldMnnm,
      required this.buldSlno});

  factory RoadAddr.fromJson(Map<dynamic, dynamic> json) {
    return RoadAddr(
        rn: json['rn'],
        addr: json['roadAddrPart1'],
        admCd: json['admCd'],
        rnMgtSn: json['rnMgtSn'],
        udrtYn: json['udrtYn'],
        buldMnnm: json['buldMnnm'],
        buldSlno: json['buldSlno']);
  }
}
