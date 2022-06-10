import 'package:flutter/material.dart';
import 'package:mosigg/components.dart';

class Delivery5 extends StatefulWidget {
  final String id;
  const Delivery5({Key? key, required this.id}) : super(key: key);

  @override
  State<Delivery5> createState() => _Delivery5State();
}

class _Delivery5State extends State<Delivery5> {
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
              text('해당 시간에 이미 예약이 있습니다', 20.0, FontWeight.w500, Colors.black),
              text('예약을 다시 진행해주세요', 20.0, FontWeight.w500, Colors.black),
              Image.asset('image/thinking.png', width: 300.0, height: 300.0),
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