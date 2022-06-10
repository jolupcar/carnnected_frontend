import 'package:mosigg/signup/signup1.dart';
import 'package:mosigg/signup/signup3.dart';
import 'package:mosigg/signup/common/signupWidget.dart';
import 'package:flutter/material.dart';

String pwd = '';

class SignUp2 extends StatefulWidget {
  const SignUp2({Key? key}) : super(key: key);

  @override
  _SignUp2State createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  var pwdcheck = false;
  final inputPwd = TextEditingController();
  final inputCpwd = TextEditingController();
  final inputname = TextEditingController();
  final inputssn = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          iconSize: 40.0,
          color: Colors.black,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SignUp1()));
          },
        ),
      ),
      body: Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                    thickness: 2.0, color: Color(0xff001A5D), endIndent: 210.0),
                SizedBox(height: 40.0),
                Form(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldMethod(
                            controller: inputname,
                            intro: '이름',
                            helperText: '이름을 입력해주세요!',
                            obsecure: false),
                        SizedBox(height: 15.0),
                        TextFieldMethod(
                            controller: inputssn,
                            intro: '주민번호 앞자리',
                            helperText: '주민번호 앞 6자리를 입력해주세요!',
                            obsecure: false),
                        SizedBox(height: 15.0),
                        TextFieldMethod(
                            controller: inputPwd,
                            intro: '비밀번호',
                            helperText: '비밀번호는 6자리 이상만 가능해요!',
                            obsecure: true),
                        SizedBox(height: 15.0),
                        TextFieldMethod(
                            controller: inputCpwd,
                            intro: '비밀번호 확인',
                            helperText: '비밀번호를 한번 더 입력해주세요!',
                            obsecure: true),
                        SizedBox(height: 20.0),
                        SizedBox(
                          width: 400.0,
                          height: 45.0,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (inputPwd.text == inputCpwd.text &&
                                  inputPwd.text.length >= 6) {
                                setState(() {
                                  pwd = inputPwd.text;
                                });
                                pwdcheck = true;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SignUp3()));
                              } else {
                                pwdcheck = false;
                              }
                            },
                            child: Text('계속하기',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff001A5D),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              elevation: 0.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
