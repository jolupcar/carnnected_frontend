import 'package:mosigg/signup/tempsignup.dart';
import 'package:mosigg/signup/signup2.dart';
import 'package:mosigg/main.dart';
import 'package:mosigg/signup/common/signupWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String id = '';

class SignUp1 extends StatefulWidget {
  const SignUp1({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp1> {
  final inputId = TextEditingController();
  var idExist = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    inputId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextMethod(
            content: '회원가입',
            size: 20.0,
            weight: FontWeight.w500,
            color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.clear_rounded),
          iconSize: 45.0,
          color: Colors.black,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => StartPage()));
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Divider(
                    thickness: 2.0, color: Color(0xff001A5D), endIndent: 315.0),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(24, 40, 24, 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextMethod(
                                      content: 'CARNNECTED의',
                                      size: 24.0,
                                      weight: FontWeight.w500,
                                      color: Colors.black),
                                  TextMethod(
                                      content: '계정을 만들게요:)',
                                      size: 24.0,
                                      weight: FontWeight.w500,
                                      color: Colors.black),
                                  SizedBox(height: 40.0),
                                  Form(
                                      child: Container(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                        TextFieldMethod(
                                            controller: inputId,
                                            intro: '아이디',
                                            helperText: '아이디를 입력해주세요!',
                                            obsecure: false,
                                            keyType:
                                                TextInputType.emailAddress),
                                        SizedBox(height: 20.0),
                                        ElevatedButton(
                                          onPressed: () async {
                                            FocusScope.of(context).unfocus();
                                            bool exist = await idcheck(
                                                '${inputId.text}');
                                            if (exist == false) {
                                              setState(() {
                                                idExist = true;
                                              });
                                            } else {
                                              setState(() {
                                                id = inputId.text;
                                              });
                                              idExist = false;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          //SignUp2()
                                                          AicarSignup()));
                                            }
                                          },
                                          child: Row(children: [
                                            TextMethod(
                                                content: '계속하기',
                                                size: 14.0,
                                                weight: FontWeight.w500,
                                                color: Colors.white)
                                          ]),
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(0xff001A5D),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              elevation: 0.0,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 154.7)),
                                        ),
                                        (idExist == true)
                                            ? Center(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: TextMethod(
                                                        content:
                                                            '앗! 이미 존재하는 아이디예요!',
                                                        size: 14.0,
                                                        weight: FontWeight.w400,
                                                        color: Colors.black)),
                                              )
                                            : SizedBox(height: 61.0),
                                      ])))
                                ]),
                            Column(children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        height: 1.0,
                                        width: 130.0,
                                        color: Color(0xffCBCBCB)),
                                    TextButton(
                                        onPressed: () {
                                          // 간편 회원가입 페이지로 이동
                                        },
                                        child: TextMethod(
                                            content: '간편 회원가입',
                                            size: 14.0,
                                            weight: FontWeight.w400,
                                            color: Color(0xffCBCBCB))),
                                    Container(
                                        height: 1.0,
                                        width: 130.0,
                                        color: Color(0xffCBCBCB)),
                                  ]),
                              InkWell(
                                  onTap: () {
                                    // 카톡 로그인 페이지로 이동
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 120.0),
                                      decoration: BoxDecoration(
                                          color: Color(0xffF9E000),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Row(children: [
                                        Image.asset('image/kakao.png',
                                            width: 25, height: 25),
                                        SizedBox(width: 5),
                                        Text('카카오로 시작',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black))
                                      ])))
                            ])
                          ])),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<bool> idcheck(String id) async {
  final response =
      await http.get(Uri.parse('http://10.20.10.189:8080/signup/$id'));
  if (response.statusCode == 200) {
    if (json.decode(response.body) == true)
      return false; // 아이디 사용 불가(중복된 아이디)
    else
      return true; // 아이디 사용 가능
  } else {
    return false;
  }
}