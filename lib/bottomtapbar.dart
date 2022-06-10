import 'package:flutter/material.dart';
import 'package:mosigg/home/home.dart';
import 'package:mosigg/map/maplist.dart';
import 'package:mosigg/service/service.dart';
import 'package:mosigg/calender/calender.dart';
import 'package:mosigg/setting/setting1.dart';

class Bottomtabbar extends StatefulWidget {
  final String id;
  final String pw;
  Bottomtabbar({required this.id, required this.pw});
  // const Bottomtabbar({Key? key}) : super(key: key);

  @override
  _BottomtabbarState createState() => _BottomtabbarState();
}

class _BottomtabbarState extends State<Bottomtabbar> {
  late String id;
  late String pw;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    pw = widget.pw;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 2,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Calenderpage(id: id), // 서비스 사용 내역
            Servicechoice(id: id), // 서비스 선택 페이지
            HomePage(id: id, pw: pw), // 홈 페이지
            MapList(), // 지도
            Settingstart(
              id: id,
            ), // 설정?
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
          child: TabBar(
            labelColor: Color(0xff001a5d),
            unselectedLabelColor: Color(0xff9d9d9d),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Color(0xff001a5d),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.watch_later_outlined,
                  size: 32.0,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.person,
                  size: 32.0,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.home_outlined,
                  size: 32.0,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.map_outlined,
                  size: 32.0,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.more_horiz,
                  size: 32.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
