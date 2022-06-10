import 'package:flutter/material.dart';
import 'package:mosigg/service/oiling/oiling4.dart';
import 'package:mosigg/components.dart';

class Oiling3 extends StatefulWidget {
  final String id;
  final String dateAndTime;
  final String carLocation;
  final String carDetailLocation;
  final String fuel;
  final String payment;
  final String gasStationName;

  const Oiling3(
      {Key? key,
      required this.id,
      required this.dateAndTime,
      required this.carLocation,
      required this.carDetailLocation,
      required this.fuel,
      required this.payment,
      required this.gasStationName})
      : super(key: key);

  @override
  State<Oiling3> createState() => _Oiling3State();
}

class _Oiling3State extends State<Oiling3> {
  late String id;

  @override
  void initState() {
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: text('주유 서비스 예약', 16.0, FontWeight.w500, Colors.black),
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
        padding: EdgeInsets.fromLTRB(25.0, 78.0, 25.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text('기름은', 20.0, FontWeight.w500, Colors.black),
            text('얼마나 넣어드릴까요?', 20.0, FontWeight.w500, Colors.black),
            SizedBox(height: 22.0),
            Row(
              children: [
                SizedBox(width: 8.0),
                Container(
                  width: 32,
                  height: 29,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xff001a5d)))),
                  ),
                ),
                SizedBox(width: 45.0),
                text('만원', 20.0, FontWeight.w500, Colors.black),
              ],
            ),
            SizedBox(
              height: 25.0,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.text = '10';
                  },
                  child: text('가득', 12.0, FontWeight.w500, Colors.white),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff001a5d),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minimumSize: Size(33.0, 18.0),
                  ),
                ),
                SizedBox(width: 5.0),
                text('가득을 원하시면 눌러주세요', 10.0, FontWeight.w400, Colors.black)
              ],
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                kipgoing(
                    context,
                    controller,
                    widget.dateAndTime,
                    widget.carLocation,
                    widget.carDetailLocation,
                    widget.fuel,
                    widget.payment,
                    widget.gasStationName),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Container kipgoing(
      BuildContext context,
      controller,
      String dateAndTime,
      String carLocation,
      String carDetailLocation,
      String fuel,
      String payment,
      String gasStationName) {
    return Container(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          if (controller.text.length > 0 &&
              controller.text != "0" &&
              controller.text[0] != "-") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Oiling4(
                    id: id,
                    dateAndTime: dateAndTime,
                    carLocation: carLocation,
                    carDetailLocation: carDetailLocation,
                    fuel: fuel,
                    payment: payment,
                    gasStationName: gasStationName,
                    price: controller.text)));
          }
        },
        child: text('계속하기', 14.0, FontWeight.w500, Colors.white),
        style: ElevatedButton.styleFrom(primary: Color(0xff001a5d)),
      ),
    );
  }
}