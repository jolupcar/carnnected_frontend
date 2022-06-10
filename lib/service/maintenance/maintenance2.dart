import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mosigg/service/maintenance/maintenance3.dart';
import 'package:mosigg/components.dart';

class Maintenance2 extends StatefulWidget {
  final String id;
  final String dateAndTime;
  final String carLocation;
  final String carDetailLocation;
  final String? type;
  final String? detail;
  final String payment;
  final LatLng carCoord;

  const Maintenance2(
      {Key? key,
      required this.id,
      required this.dateAndTime,
      required this.carLocation,
      required this.carDetailLocation,
      this.type,
      this.detail,
      required this.payment,
      required this.carCoord})
      : super(key: key);

  @override
  _Maintenance2State createState() => _Maintenance2State();
}

class _Maintenance2State extends State<Maintenance2> {
  late String id;
  final isSelected = <bool>[false, false, false];
  List<String> typeList = ['정기 검사', '종합 검사', '부분 검사'];
  String? type1;
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
        resizeToAvoidBottomInset: false,
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
        body: Container(
          padding: EdgeInsets.fromLTRB(25.0, 28.0, 25.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text('검사 종류', 14.0, FontWeight.w400, Colors.black),
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
                            type1 = typeList[buttonIndex2];
                          } else {
                            isSelected[buttonIndex2] = false;
                          }
                        }
                      });
                    },
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width - 60.0) / 3,
                        child: Center(
                          child: Text(
                            '정기 검사',
                            style: TextStyle(
                                fontSize: 12.0, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width - 60.0) / 3,
                        child: Center(
                          child: Text(
                            '종합 검사',
                            style: TextStyle(
                                fontSize: 12.0, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width - 60.0) / 3,
                        child: Center(
                          child: Text(
                            '부분 검사',
                            style: TextStyle(
                                fontSize: 12.0, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                    isSelected: isSelected),
              ),
              SizedBox(height: 6),
              text('필요하신 검사 종류를 선택해주세요!', 10.0, FontWeight.w400,
                  Color(0xff9d9d9d)),
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
                minLines: 6,
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
                        if (type1 != null)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Maintenance3(
                                          id: id,
                                          dateAndTime: widget.dateAndTime,
                                          carLocation: widget.carLocation,
                                          carDetailLocation:
                                              widget.carDetailLocation,
                                          type: type1!,
                                          payment: widget.payment,
                                          carCoord: widget.carCoord,
                                          detail: plusRequest.text)));
                      },
                      child: text('계속하기', 14.0, FontWeight.w500, Colors.white),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xff001a5d)),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
