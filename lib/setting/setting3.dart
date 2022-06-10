import 'package:mosigg/components.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Settingcar extends StatefulWidget {
  final String id;
  const Settingcar({Key? key, required this.id}) : super(key: key);

  @override
  State<Settingcar> createState() => _SettingcarState();
}

class _SettingcarState extends State<Settingcar> {
  Future<List>? data;
  @override
  void initState() {
    data = cardata(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: text('차량 관리', 18.0, FontWeight.w500, Colors.black),
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
                  padding: EdgeInsets.fromLTRB(25.0, 26.0, 25.0, 0.0),
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return carcontainer(
                            snapshot.data![index].carnumber,
                            snapshot.data![index].cartype,
                            snapshot.data![index].carname);
                      },
                    ),
                  ),
                );
              } else
                return SingleChildScrollView(
                  child: Center(
                    child: text(
                        '등록된 차량이 없습니다', 20.0, FontWeight.bold, Colors.black),
                  ),
                );
            }));
  }
}

Future<List> cardata(String id) async {
  final response =
      await http.get(Uri.parse('http://10.20.10.189:8080/carinfo/$id'));
  late List<Car> carList = [];
  if (response.statusCode == 200) {
    List<dynamic> json = jsonDecode(response.body);
    for (var i = 0; i < json.length; i++) {
      carList.add(Car.fromJson(json[i]));
    }
    return carList;
  } else {
    throw Exception('Failed to load car data');
  }
}

class Car {
  final String cartype;
  final String carname;
  final String carnumber;
  Car({
    required this.cartype,
    required this.carname,
    required this.carnumber,
  });
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      cartype: json['model'],
      carname: json['name'],
      carnumber: json['number'],
    );
  }
}

Container carcontainer(String carnumber, String cartype, String carname) {
  return Container(
    height: 80,
    child: Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('image/peridot.jpg'),
              radius: 28.0,
            ),
            SizedBox(width: 17.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text(carnumber, 12.0, FontWeight.w500, Colors.black),
                text(cartype, 12.0, FontWeight.w500, Colors.black),
                text(carname, 10.0, FontWeight.w400, Colors.black)
              ],
            ),
          ],
        ),
        Divider(
          height: 20.0,
          color: Color(0xffcbcbcb),
          thickness: 1.0,
        )
      ],
    ),
  );
}
