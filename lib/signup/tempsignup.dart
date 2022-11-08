import 'package:mosigg/signup/signup1.dart';
import 'package:mosigg/signup/signup4.dart';
import 'package:mosigg/signup/common/signupWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AicarSignup extends StatefulWidget {
  const AicarSignup({ Key? key }) : super(key: key);

  @override
  State<AicarSignup> createState() => _AicarSignupState();
}

class _AicarSignupState extends State<AicarSignup> {
  final inputOtp = TextEditingController();
  final inputId = TextEditingController();
  final inputPwd = TextEditingController();
  final inputPhone = TextEditingController();
  final inputName = TextEditingController();
  late String authToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
              width: 380.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.0),
                  TextFieldMethod(
                    controller: inputPwd,
                    intro: '비밀번호',
                    helperText: '비밀번호는 6자리 이상만 가능해요!',
                    obsecure: true),
                  SizedBox(height: 15.0),
                  TextFieldMethod(
                    controller: inputName,
                    intro: '이름',
                    helperText: '이름을 입력해주세요!',
                    obsecure: false),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Container(
                        height: 100.0,
                        width: 270.0,
                        child: TextFieldMethod(
                            controller: inputPhone,
                            intro: '휴대폰 번호',
                            helperText: '휴대폰 번호를 입력해주세요!',
                            obsecure: false),
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        width: 100.0,
                        child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff001A5D),
                            onPrimary: Color(0xff000000)),
                        onPressed: () {
                          requestGenericOtp("otpReq test", false, inputPhone.text, 1);
                        },
                        child: 
                            Text(
                              'OTP 전송',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Container(
                        height: 100.0,
                        width: 270.0,
                        child: TextFieldMethod(
                            controller: inputOtp,
                            intro: '전송받은 OTP',
                            helperText: '전송받은 OTP를 입력해주세요!',
                            obsecure: false),
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        width: 100.0,
                        child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff001A5D),
                            onPrimary: Color(0xff000000)),
                        onPressed: () {
                          authenticateOtp(inputOtp.text, inputPhone.text);
                        },
                        child: 
                            Text(
                              '확인',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff001A5D),
                        onPrimary: Color(0xff000000)),
                    onPressed: () async {
                      createNewUser(id, inputPhone.text, inputName.text, inputOtp.text, inputPwd.text, id);
                      bool sign = await signup(id, inputPwd.text, inputName.text, '010101', inputPhone.text);
                      if (sign == true &&
                          inputPwd.text.length != 0 &&
                          inputName.text.length != 0 &&
                          inputPhone.text.length != 0 &&
                          inputOtp.text.length != 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SignUp4()));
                      }
                    },
                    child: 
                        Text(
                          '회원가입',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff001A5D),
                        onPrimary: Color(0xff000000)),
                    onPressed: () async {
                      var token = await getXAuthToken("abcdefg", id, inputPwd.text, inputId.text);
                      setState(() {
                        authToken = token;
                      });
                      print('authToken: $authToken');
                    },
                    child: 
                        Text(
                          'X-Auth-Token 받아오기',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff001A5D),
                        onPrimary: Color(0xff000000)),
                    onPressed: () {
                      print('delete authToken: $authToken');
                      deleteUser(authToken, id);
                    },
                    child: 
                        Text(
                          '지금 입력한 정보의 회원 삭제',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// otp 문자 전송
Future<Map<String, dynamic>> requestGenericOtp(String autoFillSignature, bool dryRun, String phoneNo, int requestType) async {
  var url = Uri.parse("http://a93c9509242fe46e39e730b4ae48f208-b3896d77e6aa6d2c.elb.ap-northeast-2.amazonaws.com/aikey/user/otp");
  var body = jsonEncode({
    "autoFillSignature": "$autoFillSignature",
    "dryRun": "$dryRun",
    "phoneNo": "$phoneNo",
    "requestType": "$requestType"
  });

  var response = await http.post(
    url,
    headers: {
      "accept": "application/json;charset=UTF-8",
      "Content-Type": "application/json"
    },
    body: body
  );

  print(response.body);
  return jsonDecode(response.body);
}

// 입력한 otp 일치하는 지 확인
Future<Map<String, dynamic>> authenticateOtp(String code, String phoneNo) async {
  var url = Uri.parse("http://a93c9509242fe46e39e730b4ae48f208-b3896d77e6aa6d2c.elb.ap-northeast-2.amazonaws.com/aikey/user/otp/auth");
  var body = jsonEncode({
    "code": "$code",
    "phoneNo": "$phoneNo"
  });

  var response = await http.post(
    url,
    headers: {
      "accept": "application/json;charset=UTF-8",
      "Content-Type": "application/json"
    },
    body: body
  );

  print(response.body);
  return jsonDecode(response.body);
}

// 회원 가입
Future<Map<String, dynamic>> createNewUser(String email, String mobilePhone, String name, String otpCode, String password, String userId) async {
  var url = Uri.parse("http://a93c9509242fe46e39e730b4ae48f208-b3896d77e6aa6d2c.elb.ap-northeast-2.amazonaws.com/aikey/user");
  var body = jsonEncode({
    "email": "$email",
    "mobilePhone": "$mobilePhone",
    "name": "$name",
    "otpCode": "$otpCode",
    "password": "$password",
    "userId": "$userId"
  });

  var response = await http.post(
    url,
    headers: {
      "accept": "application/json;charset=UTF-8",
      "Content-Type": "application/json"
    },
    body: body
  );

  print(response.body);
  return jsonDecode(response.body);
}

// X-Auth-Token 가져오기
Future<String> getXAuthToken(String appToken, String email, String password, String userId) async {
  var url = Uri.parse("http://a93c9509242fe46e39e730b4ae48f208-b3896d77e6aa6d2c.elb.ap-northeast-2.amazonaws.com/aikey/user/auth");
  var body = jsonEncode({
    "appToken": "$appToken",
    "email": "$email",
    "password": "$password",
    "userId": "$userId"
  });

  var response = await http.post(
    url,
    headers: {
      "accept": "application/json;charset=UTF-8",
      "Content-Type": "application/json"
    },
    body: body
  );
  print(jsonDecode(response.body));
  print(jsonDecode(response.body)['payload']['authToken']); // 호출할 때마다 token 값 바뀜
  return jsonDecode(response.body)['payload']['authToken'];
}

// 우리 DB에 회원 정보 저장
Future<bool> signup(
    String id, String pwd, String name, String birth, String phone) async {
  final response = await http.get(Uri.parse(
      'http://172.30.1.24:8080/signup/$id/$pwd/$name/$birth/$phone'));

  if (response.statusCode == 200) {
    if (json.decode(response.body) == true)
      return true; // 회원가입 성공
    else
      return false; // 회원가입 실패
  } else {
    return false;
  }
}

// 회원 정보 삭제
Future<Map<String, dynamic>> deleteUser(String authToken, String userId) async {
  var url = Uri.parse("http://a93c9509242fe46e39e730b4ae48f208-b3896d77e6aa6d2c.elb.ap-northeast-2.amazonaws.com/aikey/api/user/${userId}");
  
  var response = await http.delete(
    url,
    headers: {
      "accept": "application/json;charset=UTF-8",
      "X-Auth-Token": "$authToken"
    },
  );

  print(response.body);
  return jsonDecode(response.body);
}

