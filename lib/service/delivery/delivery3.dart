import 'package:flutter/material.dart';
import 'package:mosigg/service/delivery/delivery4.dart';
import 'package:mosigg/components.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Delivery3 extends StatefulWidget {
  final String id;
  final String dateAndTime;
  final String carLocation;
  final String carDetailLocation;
  final String desLocation;
  final String desDetailLocation;
  final String payment;
  final String price;

  const Delivery3(
      {Key? key,
      required this.id,
      required this.dateAndTime,
      required this.carLocation,
      required this.carDetailLocation,
      required this.desLocation,
      required this.desDetailLocation,
      required this.payment,
      required this.price})
      : super(key: key);

  @override
  State<Delivery3> createState() => _Delivery3State();
}

class _Delivery3State extends State<Delivery3> {
  late String id;
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
        title: text('딜리버리 서비스 예약', 16.0, FontWeight.w500, Colors.black),
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
                    text('딜리버리 서비스 예약이 완료되었습니다', 16.0, FontWeight.bold,
                        Colors.black),
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
                    splitrow('배달위치', '${widget.desLocation}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        text('${widget.desDetailLocation}', 14.0,
                            FontWeight.w400, Colors.black)
                      ],
                    ),
                    Divider(
                      height: 47,
                      color: Color(0xffcbcbcb),
                      thickness: 1.0,
                    ),
                    SizedBox(height: 13.5),
                    splitrow2('예상 금액',
                        '${(int.parse(widget.price) + 2).toString()} 만원'),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Delivery4(id: id)));
                            },
                            child: text(
                                '예약하기', 14.0, FontWeight.w500, Colors.white),
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xff001a5d)),
                          ),
                        ),
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
