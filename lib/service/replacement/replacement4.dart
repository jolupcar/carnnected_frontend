import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mosigg/provider/replaceProvider.dart';
import 'package:mosigg/service/replacement/replacement5.dart';
import 'package:mosigg/service/replacement/replacement6.dart';
import 'package:provider/src/provider.dart';
import 'package:http/http.dart' as http;
import 'package:mosigg/components.dart';

var priceFormat = NumberFormat.currency(locale: "ko_KR", symbol: "");
bool boolOfMaintenance = false;
String items = '';

class Replacement4 extends StatefulWidget {
  final String id;
  final String dateAndTime;
  final String carLocation;
  final String carDetailLocation;
  final String payment;
  final String maintenance;
  final String plusRequest;

  const Replacement4(
      {Key? key,
      required this.id,
      required this.dateAndTime,
      required this.carLocation,
      required this.carDetailLocation,
      required this.payment,
      required this.maintenance,
      required this.plusRequest})
      : super(key: key);

  @override
  State<Replacement4> createState() => _Replacement4State();
}

class _Replacement4State extends State<Replacement4> {
  late String id;

  String detail2 = '없음';
  get index => null; //해당 차량
  Future<List>? data;
  @override
  void initState() {
    id = widget.id;
    data = cardata(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: text('교체 서비스 예약', 16.0, FontWeight.w500, Colors.black),
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
                    text('기본 정보', 16.0, FontWeight.bold, Colors.black),
                    SizedBox(height: 34.0),
                    splitrow('차량번호', snapshot.data![0].carnumber),
                    SizedBox(height: 20.0),
                    splitrow('예약일시',
                        '${widget.dateAndTime.substring(0, 4)}년 ${widget.dateAndTime.substring(5, 7)}월 ${widget.dateAndTime.substring(8, 10)}일 ${widget.dateAndTime.substring(11, 13)}:${widget.dateAndTime.substring(14, 16)}'),
                    splitrow('차량위치', '${widget.carLocation}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        text('${widget.carDetailLocation}', 14.0,
                            FontWeight.w400, Colors.black)
                      ],
                    ),
                    SizedBox(height: 10.0),
                    splitrow('정비 옵션', '${widget.maintenance}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text('추가 요청', 14.0, FontWeight.w500, Colors.black),
                        Container(
                          width: 271,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text.rich(TextSpan(
                                    text: '${widget.plusRequest}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400))),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 28,
                      color: Color(0xffcbcbcb),
                      thickness: 1.0,
                    ),
                    text('교체 물품', 16.0, FontWeight.bold, Colors.black),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: ListView.builder(
                          itemCount: context.read<MyCart>().items.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 240,
                                  child: Row(
                                    children: [
                                      Flexible(
                                          child: RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                            text: context
                                                .read<MyCart>()
                                                .items[index]
                                                .name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500)),
                                      )),
                                    ],
                                  ),
                                ),
                                text(
                                    '${priceFormat.format(context.read<MyCart>().items[index].price)}원',
                                    14.0,
                                    FontWeight.w400,
                                    Colors.black),
                              ],
                            );
                          }),
                    ),
                    Divider(
                      height: 28,
                      color: Color(0xffcbcbcb),
                      thickness: 1.0,
                    ),
                    splitrow2('예상 금액',
                        '${priceFormat.format(context.read<MyCart>().totalPrice)} 원'),
                    splitrow2('결제방식', '${widget.payment}'),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              if (widget.maintenance == '적용') {
                                boolOfMaintenance = true;
                              }
                              for (var i = 0;
                                  i < context.read<MyCart>().items.length;
                                  i++) {
                                items +=
                                    '${context.read<MyCart>().items[i].itemList}, ';
                              }
                              if (widget.plusRequest == '')
                                repRsv(
                                        id,
                                        snapshot.data![0].carnumber,
                                        widget.dateAndTime,
                                        items,
                                        boolOfMaintenance,
                                        detail2,
                                        widget.carLocation,
                                        widget.carDetailLocation,
                                        context.read<MyCart>().totalPrice,
                                        widget.payment)
                                    .then((result) {
                                  if (result == true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Replacement5(
                                                  id: id,
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Replacement6(id: id)));
                                    print("댕같이 실패");
                                  }
                                });
                              else
                                repRsv(
                                        id,
                                        snapshot.data![0].carnumber,
                                        widget.dateAndTime,
                                        items,
                                        boolOfMaintenance,
                                        widget.plusRequest,
                                        widget.carLocation,
                                        widget.carDetailLocation,
                                        context.read<MyCart>().totalPrice,
                                        widget.payment)
                                    .then((result) {
                                  if (result == true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Replacement5(
                                                  id: id,
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Replacement6(id: id)));
                                    print("댕같이 실패");
                                  }
                                });
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

Future<bool> repRsv(
    String id,
    String carNum,
    String dateAndTime,
    String item,
    bool maintenance,
    String plusRequest,
    String carLocation,
    String carDetailLocation,
    int totalPrice,
    String payment) async {
  final response = await http.get(Uri.parse(
      'http://172.30.1.24:8080/replace_resrv/$id/$carNum/$dateAndTime/$carLocation/$carDetailLocation/$item/$maintenance/$plusRequest/$totalPrice/$payment'));
  if (response.statusCode == 200) {
    print('예약 성공 ${response.body}');
    bool result = (response.body == 'true') ? true : false;
    return result;
  } else {
    print('예약 실패 ${response.statusCode}');
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
