import 'package:flutter/material.dart';
import 'package:mosigg/components.dart';

class Oiling5 extends StatefulWidget {
  final String id;
  const Oiling5({Key? key, required this.id}) : super(key: key);

  @override
  State<Oiling5> createState() => _Oiling5State();
}

class _Oiling5State extends State<Oiling5> {
  late String id;

  @override
  void initState() {
    id = widget.id;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: text('주유 서비스 예약', 16.0, FontWeight.w500, Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 80.0),
        child: Center(
          child: Column(
            children: [
              text('예약이 완료되었습니다', 20.0, FontWeight.w500, Colors.black),
              text('최고의 서비스로 모시겠습니다:D', 20.0, FontWeight.w500, Colors.black),
              Image.asset('image/reserved.png', width: 300.0, height: 300.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [gohome(context)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}