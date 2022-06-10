import 'package:flutter/material.dart';
import 'package:mosigg/service/carwash/carwash4.dart';
import 'package:mosigg/service/carwash/carwash5.dart';
import 'package:http/http.dart' as http;
import 'package:mosigg/components.dart';

class CarWash3 extends StatefulWidget {
  final String id;
  final String dateAndTime;
  final String carLocation;
  final String carDetailLocation;
  final String type;
  final String detail;
  final String payment;

  const CarWash3(
      {Key? key,
      required this.id,
      required this.dateAndTime,
      required this.carLocation,
      required this.carDetailLocation,
      required this.type,
      required this.detail,
      required this.payment})
      : super(key: key);

  @override
  State<CarWash3> createState() => _CarWash3State();
}

class _CarWash3State extends State<CarWash3> {
  late String id;
  var price = 0;
  String carNum = '102허2152'; // 차량 번호 받아와야 됨
  late var arr = widget.type.split(',');

  @override
  void initState() {
    id = widget.id;
    var temp = widget.type.split(',');
    if (temp[0] == "셀프 세차장 세차")
      price = 4;
    else if (temp[0] == "주차장 스팀 세차")
      price = 5;
    else
      price = 0;
    if (temp[1] == "실내 클리닝") price += 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: text('세차 서비스 예약', 16.0, FontWeight.w500, Colors.black),
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text('예약 내역을 확인해주세요', 12.0, FontWeight.w400, Color(0xff9a9a9a)),
            text('세차 서비스 예약 내역', 16.0, FontWeight.bold, Colors.black),
            SizedBox(height: 34.0),
            splitrow('차량번호', '102허2152'),
            SizedBox(height: 20.0),
            splitrow('예약일시',
                '${widget.dateAndTime.substring(0, 4)}년 ${widget.dateAndTime.substring(5, 7)}월 ${widget.dateAndTime.substring(8, 10)}일 ${widget.dateAndTime.substring(11, 13)}:${widget.dateAndTime.substring(14, 16)}'),
            splitrow('차량위치', '${widget.carLocation}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                text('${widget.carDetailLocation}', 14.0, FontWeight.w400,
                    Colors.black)
              ],
            ),
            SizedBox(height: 10.0),
            splitrow('외부 세차', '${arr[0]}'),
            splitrow('내부 세차', '${arr[1]}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text('추가 요청', 14.0, FontWeight.w500, Colors.black),
                Container(
                  width: 271,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                          child: RichText(
                        //textAlign: TextAlign.right,
                        text: TextSpan(
                            text: widget.detail.length > 0 ? widget.detail : "",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400)),
                      )),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 33),
            Divider(
              height: 28,
              color: Color(0xffcbcbcb),
              thickness: 1.0,
            ),
            splitrow2('예상 금액', '$price 만원'),
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
                      washRsrv(
                          id,
                          carNum,
                          widget.dateAndTime,
                          widget.carLocation,
                          widget.carDetailLocation,
                          widget.type,
                          widget.payment,
                          (widget.detail == '' ? '없음' : widget.detail),
                          price)
                        .then((result) {
                          if(result == true) {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CarWash4(id: id)));
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                  CarWash5(id: id)));
                            print("댕같이 실패");
                          }
                        });
                      
                    },
                    child: text('예약하기', 14.0, FontWeight.w500, Colors.white),
                    style: ElevatedButton.styleFrom(primary: Color(0xff001a5d)),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

Future<bool> washRsrv(
    String id,
    String carNum,
    String dateAndTime,
    String carLocation,
    String carDetailLocation,
    String type,
    String payment,
    String detail,
    int price) async {
  final response = await http.get(Uri.parse(
      'http://10.20.10.189:8080/wash_resrv/$id/$carNum/$dateAndTime/$carLocation/$carDetailLocation/$type/$detail/$price/$payment/'));
  if (response.statusCode == 200) {
    print('세차 예약 성공 ${response.body}');
    bool result = (response.body == 'true') ? true : false;
    return result;
  } else {
    print('세차 예약 실패 ${response.statusCode}');
    return false;
  }
}
