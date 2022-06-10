import 'package:mosigg/components.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
//import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  final String id;
  final String pw;
  HomePage({Key? key, required this.id, required this.pw}) : super(key: key);
  // const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String id;
  late String pw;
  var idx = 0;
  Future<List>? data;
  String usingservice = "";

  Future initService(String carNumber) async {
    var service = await getUsingservice(carNumber);
    setState(() {
      usingservice = service;
    });
  }

  @override
  void initState() {
    super.initState();
    id = widget.id;
    pw = widget.pw;
    data = cardata(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('HOME', 20.0, FontWeight.w500, Colors.black),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            // 임시로그아웃 버튼
            onPressed: () {
              
            },
            icon: Icon(
              Icons.help_outline,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length == 0) {
                return pluscard();
              } else {
                if (usingservice == "") {
                  initService(snapshot.data![idx].carnumber);
                }
                return SingleChildScrollView(
                    child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      text(snapshot.data![idx].cartype, 18.0, FontWeight.w500,
                          Colors.black),
                      text(snapshot.data![idx].carname, 14.0, FontWeight.w500,
                          Color(0xffA9A9A9)),
                      SizedBox(height: 15),
                      Container(
                          height: 340,
                          child: card(
                              snapshot.data![idx].carnumber, usingservice)),
                      SizedBox(height: 34.0),
                      Container(
                        width: 300,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Color(0xffE8EAEE),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  text('열기', 12.0, FontWeight.w400,
                                      Colors.black),
                                  SvgPicture.asset('image/key/open.svg',
                                      width: 24, height: 24),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  text('닫기', 12.0, FontWeight.w400,
                                      Colors.black),
                                  SvgPicture.asset('image/key/close.svg',
                                      width: 24, height: 24),
                                ],
                              ),
                            ),
                            // Container(
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //     children: [
                            //       text('시동', 12.0, FontWeight.w400, Colors.black),
                            //       SvgPicture.asset('image/key/on.svg',
                            //           width: 24, height: 24),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  text('경적', 12.0, FontWeight.w400,
                                      Colors.black),
                                  SvgPicture.asset('image/key/horn.svg',
                                      width: 24, height: 24),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  text('트렁크', 12.0, FontWeight.w400,
                                      Colors.black),
                                  SvgPicture.asset('image/key/trunk.svg',
                                      width: 24, height: 24),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
              }
            } else {
              return SizedBox(height: 100);
            }
          },
        ),
      ),
    );
  }
}

Card card(String carnumber, String usingservice) {
  return Card(
    elevation: 0.0,
    child: Container(
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color(0x3f000000),
            offset: Offset(10, 10),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
        color: Color(0xff001A5D),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundImage: AssetImage('image/peridot.jpg'),
            radius: 40.0,
          ),
          SizedBox(height: 10.0),
          text(carnumber, 18.0, FontWeight.bold, Colors.white),
          SizedBox(height: 9.0),
          Container(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: Divider(
              height: 0.0,
              color: Colors.white,
              thickness: 1.0,
            ),
          ),
          SizedBox(height: 13.0),
          text('마지막으로 이용한 서비스', 12.0, FontWeight.w400, Colors.white),
          SizedBox(height: 6.0),
          text(usingservice, 20.0, FontWeight.bold, Colors.white),
          SizedBox(height: 13.0),
          Container(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: Divider(
              height: 0.0,
              color: Colors.white,
              thickness: 1.0,
            ),
          ),
          SizedBox(height: 26.0),
          InkWell(
            onTap: () {
              print('공유하기 서비스');
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                ),
              ),
              height: 40,
              width: 280,
              child: Center(
                  child: text("공유하기", 20.0, FontWeight.bold, Colors.black)),
            ),
          )
        ],
      ),
    ),
  );
}

Container pluscard() {
  return Container(
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        text('차량 없음', 18.0, FontWeight.w500, Colors.black),
        text('차량을 등록해주세요', 14.0, FontWeight.w500, Color(0xffA9A9A9)),
        SizedBox(height: 15),
        Container(
          width: 220,
          height: 330,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Color(0x3f000000),
                offset: Offset(10, 10),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
            color: Colors.grey[300],
          ),
          child: Center(
              child: text('+', 40.0, FontWeight.w400, Color(0xffA9A9A9))),
        ),
        SizedBox(height: 34.0),
        Container(
            alignment: Alignment.center,
            width: 300,
            height: 90,
            decoration: BoxDecoration(
              color: Color(0xffE8EAEE),
              borderRadius: BorderRadius.circular(25),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              text('차량을 등록하면\n이용 가능합니다', 14.0, FontWeight.w400, Colors.black),
            ]) //Container(),
            ),
      ],
    ),
  );
}

Future<List> cardata(String id) async {
  final response =
      await http.get(Uri.parse('http://10.20.10.189:8080/carinfo/$id'));
  late List<Car> carList = [];
  if (response.statusCode == 200) {
    List<dynamic> json = jsonDecode(response.body);
    for (var i = 0; i < json.length; i++) {
      carList.add(Car.fromJson(json[i]));
    }
    return carList;
  } else {
    throw Exception('Failed to load car data');
  }
}

Future<String> getUsingservice(String carnumber) async {
  final response =
      await http.get(Uri.parse('http://10.20.10.189:8080/usingservice/$carnumber'));

  if (response.statusCode == 200) {
    String service = response.body.toString();
    return service;
  } else
    throw Exception('Failed to load car data');
}
