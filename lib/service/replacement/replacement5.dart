import 'package:flutter/material.dart';
import 'package:mosigg/components.dart';

class Replacement5 extends StatefulWidget {
  final String id;
  const Replacement5({Key? key, required this.id}) : super(key: key);

  @override
  State<Replacement5> createState() => _Replacement5State();
}

class _Replacement5State extends State<Replacement5> {
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
        title: text('교체 서비스 예약', 16.0, FontWeight.w500, Colors.black),
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