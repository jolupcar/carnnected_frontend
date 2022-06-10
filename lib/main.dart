import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:mosigg/setting/setting1.dart';
import 'package:mosigg/signup/signup2.dart';
import 'package:mosigg/signup/signup3.dart';
import 'package:provider/provider.dart';
import 'package:mosigg/provider/replaceProvider.dart';
import 'package:mosigg/signup/signup1.dart';
import 'package:mosigg/login/login.dart';
import 'package:mosigg/location/location1.dart';

import 'calender/calender.dart';

//void main() => runApp(MyApp());
void main() {
  KakaoContext.clientId = 'f7926788ee7785502df4ce563f93d183';
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CountPurchase()),
    ChangeNotifierProvider(create: (_) => MyCart()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CARNNECTED',
        theme: ThemeData(
            fontFamily: 'NotoSansKR',
            primaryColor: Colors.white,
            colorScheme:
                ThemeData().colorScheme.copyWith(primary: Color(0xff9a9a9a)),
            scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          // '/': (context) => Bottomtabbar(id: 'mouse0429@naver.com', pw: 'password1234'),
          '/': (context) => LoginPage(),
          '/location1': (context) => LocationSearchPage1(
                id: id,
              )
        }
        // home:
        );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Future<void> loginButtonPressed() async {
    try {
      String authCode = await AuthCodeClient.instance.request();
      print(authCode);
    } catch (e) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => StartPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff001A5D),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 150),
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'CARNNECTED',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 54,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '차량 관리를 더 쉽고 더 간편하게',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                      SizedBox(
                        width: 270,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xfff9e000),
                              onPrimary: Color(0xff000000)),
                          onPressed: () {
                            loginButtonPressed();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble, color: Colors.black),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '카카오톡으로 로그인',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: 270,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xffffffff),
                              onPrimary: Color(0xff000000)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '카넥티드로 로그인',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Color(0xff000000),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp1()),
                          );
                        },
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
