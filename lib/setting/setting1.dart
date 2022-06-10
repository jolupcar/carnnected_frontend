import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mosigg/login/login.dart';
import 'package:mosigg/setting/setting2.dart';
import 'package:mosigg/setting/setting3.dart';
import 'package:mosigg/setting/setting4.dart';
import 'package:mosigg/components.dart';
import 'package:flutter/material.dart';
import 'package:mosigg/signup/signup1.dart';

class Settingstart extends StatefulWidget {
  final String id;
  const Settingstart({Key? key, required this.id}) : super(key: key);

  @override
  State<Settingstart> createState() => _SettingstartState();
}

class _SettingstartState extends State<Settingstart> {
  static final storage = FlutterSecureStorage(); // 로그아웃
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: text('설정', 18.0, FontWeight.w500, Colors.black),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text('운전자님', 20.0, FontWeight.w500, Colors.black),
            text('오늘도 안전운행하세요:)', 20.0, FontWeight.w500, Colors.black),
            SizedBox(height: 34.0),
            text('기본설정', 12.0, FontWeight.w400, Color(0xff747474)),
            newsplitrow(
                context,
                '계정 관리',
                Settingid(
                  id: id,
                )),
            newsplitrow(
                context,
                '차량 관리',
                Settingcar(
                  id: id,
                )),
            newsplitrow(context, '즐겨찾는 주소 설정', Settingaddr(id: id)),
            Divider(
              height: 10.0,
              color: Color(0xffcbcbcb),
              thickness: 1.0,
            ),
            SizedBox(height: 10.0),
            text('이용 약관', 12.0, FontWeight.w400, Color(0xff747474)),
            newsplitrow(
                context,
                '서비스 이용 약관',
                Settingid(
                  id: id,
                )),
            newsplitrow(
                context,
                '개인 정보 처리 약관',
                Settingid(
                  id: id,
                )),
            newsplitrow(context, '위치 기반 서비스 이용 약관', Settingid(id: id)),
            Divider(
              height: 10.0,
              color: Color(0xffcbcbcb),
              thickness: 1.0,
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Color(0xff000000),
              ),
              onPressed: () {
                storage.delete(key: "login");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text(
                '로그아웃',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Row newsplitrow(BuildContext context, type, page) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      text(type, 14.0, FontWeight.w400, Colors.black),
      IconButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => page));
        },
        icon: Icon(
          Icons.navigate_next,
          color: Color(0xffbcbcbc),
        ),
      )
    ],
  );
}
