import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:mosigg/map/common/tabbarWidget.dart';
import 'package:mosigg/map/googlemap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RepairShop extends StatefulWidget {
  //final Future<Position> position;
  final double long, lat;
  const RepairShop({Key? key, required this.long, required this.lat}) : super(key: key);

  @override
  _RepairShopState createState() => _RepairShopState();
}

class _RepairShopState extends State<RepairShop> {
  Future<List>? fixCoordData;

  @override
  void initState(){
    super.initState();
    fixCoordData = getFixinfo(widget.lat, widget.long);
  }

  @override
  Widget build(BuildContext context){
    return ListView(
      children: [
        FutureBuilder<List>(
          future: fixCoordData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return listview(snapshot.data!.length, snapshot.data!);
            } else {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator()
                ),
              );
            }
          }
        ),
      ],
    );
  }
}

Widget listview(itemcount, itemType) {
  return ListView.separated(
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    scrollDirection: Axis.vertical,
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: itemcount,
    itemBuilder: (BuildContext context, int index){
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: (){
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext
                        context) =>
                    MapPage(location: Location(
                      itemType[index].long, itemType[index].lat
                    ))));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade200,
                width: 2.0
              ),
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                stops: [0.03, 0.03],
                colors: [Color(0xffe8eaee), Color(0xffF5F5F5)]
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      '${itemType[index].name}',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      width: 310,
                      child: Flexible(
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                          text: '${itemType[index].address}',
                          style: TextStyle(
                              color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),                     
              ],
            ),
          ),
        )
      );
    },
    separatorBuilder: (BuildContext context, int index) => SizedBox(height: 3),
  );
}

Future<List> getFixinfo(latitude, longtitude) async {
  Map<String, String> headers = {
    'X-NCP-APIGW-API-KEY-ID': '8eluft3bx7',
    'X-NCP-APIGW-API-KEY': 'Zt0hrdTDUsti4s8cPOlpz26QBfz4Rm6lFUHGBGfG'
  };

  late List<FIX> fixList = [];

  final responseCrawling = await http.get(Uri.parse(
      'http://172.30.1.24:8080/map/자동차 수리점/${latitude}/${longtitude}'));

  if (responseCrawling.statusCode == 200) {
    List<dynamic> jsonCrawl = jsonDecode(responseCrawling.body);
    for (var i = 0; i < jsonCrawl.length; i++) {
      print('[크롤링 결과] ${jsonCrawl[i]}');
      var addr = jsonCrawl[i]['address'];
      final responseCoord = await http.get(
          Uri.parse(
              'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$addr'),
          headers: headers);
      if (responseCoord.statusCode == 200) {
        var jsonCoord = jsonDecode(responseCoord.body);
        if (jsonCoord['error'] != null || jsonCoord['addresses'].length == 0)
          continue;
        var long = double.parse(jsonCoord['addresses'][0]['x']);
        var lat = double.parse(jsonCoord['addresses'][0]['y']);

        print('[네이버 좌표 결과] $long $lat');
        fixList.add(FIX(
            type: jsonCrawl[i]['type'],
            name: jsonCrawl[i]['name'],
            address: jsonCrawl[i]['address'],
            long: long,
            lat: lat));
      } else {
        throw Exception('Failed to load fix data');
      }
    }
    return fixList;
  } else {
    throw Exception('Failed to load coordinates');
  }
}

class FIX {
  final String type;
  final String name;
  final String address;
  final double long;
  final double lat;

  FIX({
    required this.type,
    required this.name,
    required this.address,
    required this.long,
    required this.lat,
  });

  factory FIX.fromJson(Map<dynamic, dynamic> json) {
    return FIX(
      type: json['type'],
      name: json['name'],
      address: json['address'],
      long: json['long'],
      lat: json['lat2'],
    );
  }
}