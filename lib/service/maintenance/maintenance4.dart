import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mosigg/home/home.dart';
import 'package:mosigg/service/maintenance/maintenance5.dart';
import 'package:mosigg/service/maintenance/maintenance6.dart';
import 'package:mosigg/components.dart';

class Maintenance4 extends StatefulWidget {
  final String id;
  final String dateAndTime;
  final String carLocation;
  final String carDetailLocation;
  final String detail;
  final String payment;
  final String type;
  final String destName;
  final String destaddr;
  final String? price;
  const Maintenance4(
      {Key? key,
      required this.id,
      required this.dateAndTime,
      required this.carLocation,
      required this.carDetailLocation,
      required this.detail,
      required this.payment,
      required this.type,
      required this.destName,
      required this.destaddr,
      this.price})
      : super(key: key);

  @override
  State<Maintenance4> createState() => _Maintenance4State();
}

class _Maintenance4State extends State<Maintenance4> {
  /*임시데이터*/
  late String id;
  String detail2 = '없음';
  Future<List>? data;

  int price = 15;
  @override
  void initState() {
    id = widget.id;
    data = cardata(widget.id);

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: text('정비 서비스 예약', 16.0, FontWeight.w500, Colors.black),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text('예약 내역을 확인해주세요', 12.0, FontWeight.w400,
                        Color(0xff9a9a9a)),
                    text(widget.destName, 16.0, FontWeight.bold, Colors.black),
                    SizedBox(height: 34.0),
                    splitrow('차량번호', snapshot.data![0].carnumber),
                    SizedBox(height: 20.0),
                    splitrow('예약일시',
                        '${widget.dateAndTime.substring(0, 4)}년 ${widget.dateAndTime.substring(5, 7)}월 ${widget.dateAndTime.substring(8, 10)}일 ${widget.dateAndTime.substring(11, 13)}:${widget.dateAndTime.substring(14, 16)}'),
                    splitrow('차량위치', widget.carLocation),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        text(widget.carDetailLocation, 14.0, FontWeight.w400,
                            Colors.black)
                      ],
                    ),
                    SizedBox(height: 10.0),
                    splitrow('검사 종류', widget.type),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text('추가 요청', 14.0, FontWeight.w500, Colors.black),
                        Container(
                          width: 271,
                          child: Flexible(
                            child: RichText(
                                textAlign: TextAlign.right,
                                text: TextSpan(
                                    text: widget.detail,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400))),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Divider(
                      height: 28,
                      color: Color(0xffcbcbcb),
                      thickness: 1.0,
                    ),
                    splitrow2('예상 금액', '12만원'),
                    splitrow2('결제방식', widget.payment),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              if (widget.detail == '') {
                                fixrsrv(
                                  id,
                                  snapshot.data![0].carnumber,
                                  widget.dateAndTime,
                                  widget.carLocation,
                                  widget.carDetailLocation,
                                  widget.type,
                                  detail2,
                                  widget.payment,
                                  widget.destName,
                                  widget.destaddr,
                                  price,
                                ).then((result) {
                                  if (result == true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Maintenance5(id: id)));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Maintenance6(id: id)));
                                    print("댕같이 실패");
                                  }
                                });
                              } else {
                                id = widget.id;
                                fixrsrv(
                                  id,
                                  snapshot.data![0].carnumber,
                                  widget.dateAndTime,
                                  widget.carLocation,
                                  widget.carDetailLocation,
                                  widget.type,
                                  widget.detail,
                                  widget.payment,
                                  widget.destName,
                                  widget.destaddr,
                                  price,
                                ).then((result) {
                                  if (result == true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Maintenance5(id: id)));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Maintenance6(id: id)));
                                    print("댕같이 실패");
                                  }
                                });
                              }
                            },
                            child: text(
                                '예약하기', 14.0, FontWeight.w500, Colors.white),
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xff001a5d)),
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              );
            } else
              return SingleChildScrollView(
                child: Center(
                  child:
                      text('등록된 차량이 없습니다', 20.0, FontWeight.bold, Colors.black),
                ),
              );
          }),
    );
  }
}

Future<bool> fixrsrv(
    String id,
    String carNum,
    String dateAndTime,
    String carLocation,
    String carDetailLocation,
    String type,
    String payment,
    String? detail,
    String destName,
    String destaddr,
    int price) async {
  final response = await http.get(Uri.parse(
      'http://172.30.1.24:8080/repair_resrv/$id/$carNum/$dateAndTime/$carLocation/$carDetailLocation/$type/$detail/$destName/$destaddr/$price/$payment'));
  if (response.statusCode == 200) {
    print('댕같이성공 ${response.body}');
    bool result = (response.body == 'true') ? true : false;
    return result;
  } else {
    print('개같이실패 ${response.statusCode}');
    return false;
  }
}

Future<List> cardata(String id) async {
  final response =
      await http.get(Uri.parse('http://172.30.1.24:8080/carinfo/$id'));
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
