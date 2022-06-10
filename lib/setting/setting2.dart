import 'package:mosigg/components.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Settingid extends StatefulWidget {
  final String id;
  const Settingid({Key? key, required this.id}) : super(key: key);

  @override
  State<Settingid> createState() => _SettingidState();
}

class _SettingidState extends State<Settingid> {
  Future<List>? data;
  @override
  void initState() {
    data = userdata(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: text('계정 관리', 18.0, FontWeight.w500, Colors.black),
          elevation: 0.0,
          backgroundColor: Colors.white,
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
                  padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text('아이디', 14.0, FontWeight.w500, Colors.black),
                      SizedBox(height: 10.0),
                      text(snapshot.data![0].id, 12.0, FontWeight.w400,
                          Colors.black),
                      Divider(
                        height: 6.0,
                        color: Color(0xffcbcbcb),
                        thickness: 2.0,
                      ),
                      SizedBox(height: 20.0),
                      text('휴대폰 번호', 14.0, FontWeight.w500, Colors.black),
                      SizedBox(height: 10.0),
                      text(snapshot.data![0].phone, 12.0, FontWeight.w400,
                          Colors.black),
                      Divider(
                        height: 6.0,
                        color: Color(0xffcbcbcb),
                        thickness: 2.0,
                      ),
                      SizedBox(height: 20.0),
                      text('생년월일', 14.0, FontWeight.w500, Colors.black),
                      SizedBox(height: 10.0),
                      if (int.parse(snapshot.data![0].birth.substring(0, 2)) >
                          23)
                        text(
                            "19${snapshot.data![0].birth.substring(0, 2)}년 ${snapshot.data![0].birth.substring(2, 4)}월 ${snapshot.data![0].birth.substring(4, 6)}일",
                            12.0,
                            FontWeight.w400,
                            Colors.black),
                      if (int.parse(snapshot.data![0].birth.substring(0, 2)) <
                          24)
                        text(
                            "20${snapshot.data![0].birth.substring(0, 2)}년 ${snapshot.data![0].birth.substring(2, 4)}월 ${snapshot.data![0].birth.substring(4, 6)}일",
                            12.0,
                            FontWeight.w400,
                            Colors.black),
                      Divider(
                        height: 6.0,
                        color: Color(0xffcbcbcb),
                        thickness: 2.0,
                      ),
                    ],
                  ),
                );
              } else
                return Text('실패');
            }));
  }
}

Future<List> userdata(String id) async {
  final response =
      await http.get(Uri.parse('http://10.20.10.189:8080/memberinfo/$id'));
  late List<User> dataList = [];
  if (response.statusCode == 200) {
    List<dynamic> json1 = jsonDecode(response.body);
    for (int i = 0; i < json1.length; i++) {
      dataList.add(User.fromJson(json1[i]));
    }
    return dataList;
  } else {
    throw Exception('Failed to load user data');
  }
}

class User {
  final String id;
  final String pwd;
  final String phone;
  final String name;
  final String birth;
  User(
      {required this.id,
      required this.pwd,
      required this.phone,
      required this.birth,
      required this.name});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        pwd: json['pwd'],
        phone: json['phone'],
        birth: json['birth'],
        name: json['name']);
  }
}
