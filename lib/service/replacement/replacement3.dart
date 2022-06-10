// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:mosigg/service/replacement/replacement4.dart';
import 'package:mosigg/components.dart';

class Replacement3 extends StatefulWidget {
  final String id;
  final String dateAndTime;
  final String carLocation;
  final String carDetailLocation;
  final String payment;

  const Replacement3(
      {Key? key,
      required this.id,
      required this.dateAndTime,
      required this.carLocation,
      required this.carDetailLocation,
      required this.payment})
      : super(key: key);

  @override
  _Replacement3State createState() => _Replacement3State();
}

class _Replacement3State extends State<Replacement3> {
  late String id;
  final isSelected = <bool>[false, false];
  List<String> maintList = ['없음', '적용'];
  String? maintenance;
  TextEditingController plusRequest = TextEditingController();

  @override
  void initState() {
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
        body: Container(
          padding: EdgeInsets.fromLTRB(25.0, 28.0, 25.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text('정비 옵션', 14.0, FontWeight.w400, Colors.black),
              SizedBox(height: 6),
              Container(
                height: 24,
                child: ToggleButtons(
                    color: Colors.black,
                    selectedColor: Colors.white,
                    selectedBorderColor: Color(0xff001a5d),
                    fillColor: Color(0xff001a5d),
                    onPressed: (int index2) {
                      setState(() {
                        for (int buttonIndex2 = 0;
                            buttonIndex2 < isSelected.length;
                            buttonIndex2++) {
                          if (buttonIndex2 == index2) {
                            isSelected[buttonIndex2] = true;
                            maintenance = maintList[buttonIndex2];
                          } else {
                            isSelected[buttonIndex2] = false;
                          }
                        }
                      });
                    },
                    children: [
                      toggleItem(context, maintList[0], 2),
                      toggleItem(context, maintList[1], 2),
                    ],
                    isSelected: isSelected),
              ),
              SizedBox(height: 6),
              text('교체와 함께 간단 정비 서비스를 이용하고 싶으시면 적용을 눌러주세요!', 10.0,
                  FontWeight.w400, Color(0xff9d9d9d)),
              SizedBox(height: 19.0),
              text('추가 요청 사항', 14.0, FontWeight.w400, Colors.black),
              SizedBox(height: 6.0),
              TextField(
                maxLength: 200,
                controller: plusRequest,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(fontSize: 10.0, color: Colors.black),
                decoration: InputDecoration(
                  counterText: '',
                  helperText: '추가 요청 사항을 200자 이내로 입력해주세요!',
                  helperStyle:
                      TextStyle(fontSize: 10.0, color: Color(0xff9d9d9d)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        if (maintenance != null && plusRequest != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Replacement4(
                                        id: id,
                                        dateAndTime: widget.dateAndTime,
                                        carLocation: widget.carLocation,
                                        carDetailLocation:
                                            widget.carDetailLocation,
                                        payment: widget.payment,
                                        maintenance: maintenance!,
                                        plusRequest: plusRequest.text,
                                      )));
                        }
                      },
                      child: text('예약하기', 14.0, FontWeight.w500, Colors.white),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xff001a5d)),
                    ),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

Container toggleItem(context, text, itemNum) {
  return Container(
    width: (MediaQuery.of(context).size.width - 60.0) / itemNum,
    child: Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
      ),
    ),
  );
}
