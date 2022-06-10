import 'package:mosigg/setting/button.dart';
import 'package:mosigg/components.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mosigg/signup/signup1.dart';

class Settingaddr extends StatefulWidget {
  final String id;
  const Settingaddr({Key? key, required this.id}) : super(key: key);

  @override
  State<Settingaddr> createState() => _SettingaddrState();
}

class _SettingaddrState extends State<Settingaddr> {
  Future<List>? data;
  List<String> addList = ['편집', '추가'];
  int index1 = 0;
  @override
  void initState() {
    data = favoriteAddr(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: text('주소 관리', 18.0, FontWeight.w500, Colors.black),
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
        body: Padding(
          padding: EdgeInsets.fromLTRB(25.0, 2.0, 25.0, 0.0),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '즐겨찾는 주소',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (index1 == 0) {
                            index1++;
                          } else {
                            index1--;
                          }
                        });
                      },
                      child: text(
                          addList[index1], 12.0, FontWeight.w400, Colors.white),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff001a5d),
                          minimumSize: Size(38.0, 20.0)),
                    )
                  ],
                ),
                SizedBox(height: 6),
                FutureBuilder<List>(
                  future: data,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length == 0) {
                        return Text('즐겨찾는 주소가 없습니다!');
                      } else {
                        return Container(
                          height: snapshot.data!.length * 56,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return addrWidget(
                                  context,
                                  snapshot.data![index].addr,
                                  snapshot.data![index].detailAddr,
                                  index1);
                            },
                          ),
                        );
                      }
                    } else {
                      return Text('즐겨찾는 주소 불러오는 중!');
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

InkWell addrWidget(
    BuildContext context, String addr, String detailAddr, int index1) {
  return InkWell(
    onTap: () {},
    child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
        padding: EdgeInsets.all(8),
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xfff5f5f5),
          boxShadow: [
            BoxShadow(
              color: Color(0x3f000000),
              offset: Offset(0, 0),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
                SizedBox(height: 3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: Text(
                          '상세주소',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontFamily: 'NotoSansKR',
                          ),
                        ),
                        color: Color(0xffe8eaee)),
                    SizedBox(width: 3),
                    Text(
                      detailAddr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                  ],
                )
              ],
            ),
            index1 == 1
                ? OutlineCircleButton(
                    radius: 20.0,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 15.0,
                    ),
                    onTap: () {
                      favoriteAddrdelete(
                          'mouse0429@naver.com', addr, detailAddr);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Settingaddr(
                                    id: id,
                                  )));
                    },
                  )
                : text('', 0.0, FontWeight.bold, Colors.white)
          ],
        )),
  );
}

Future<List> favoriteAddr(String id) async {
  final response =
      await http.get(Uri.parse('http://10.20.10.189:8080/favorite_addr/$id'));
  late List<Addr> favoriteAddrList = [];

  if (response.statusCode == 200) {
    List<dynamic> json = jsonDecode(response.body);
    for (var i = 0; i < json.length; i++) {
      favoriteAddrList.add(Addr.fromJson(json[i]));
    }
    return favoriteAddrList;
  } else {
    throw Exception("즐겨찾는 주소를 불러오는데 실패했습니다");
  }
}

Future<List> favoriteAddrdelete(
    String id, String addr, String detailAddr) async {
  final response = await http.get(Uri.parse(
      'http://10.20.10.189:8080/favorite_addr/delete/$id/$addr/$detailAddr'));
  late List<Addr> favoriteAddrList = [];
  if (response.statusCode == 200) {
    return favoriteAddrList;
  } else {
    throw Exception("즐겨찾는 주소를 삭제하는데 실패했습니다");
  }
}

class Addr {
  final String addr;
  final String detailAddr;

  Addr({required this.addr, required this.detailAddr});

  factory Addr.fromJson(Map<String, dynamic> json) {
    return Addr(addr: json['addr'], detailAddr: json['detailAddr']);
  }
}
