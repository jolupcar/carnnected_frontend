import 'package:flutter/material.dart';
import 'package:mosigg/map/maplist.dart';
import 'package:mosigg/map/common/tabbarWidget.dart';
import 'package:mosigg/map/googlemap.dart';

class ElectricCar extends StatefulWidget {
  const ElectricCar({Key? key}) : super(key: key);

  @override
  _ElectricCarState createState() => _ElectricCarState();
}

class _ElectricCarState extends State<ElectricCar> {
  @override
  Widget build(BuildContext context){
    return ListView(
      children: [
        FilterMethod(),
        listview(electric.length)
      ],
    );
  }
}

Widget listview(itemcount) {
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
            latitude = electric[index]['x'].toString();
            longtitude = electric[index]['y'].toString();
            final location = Location(double.parse(latitude), double.parse(longtitude));
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext
                        context) =>
                    MapPage(location: location)));
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
                colors: [Color(0xffFFDF37), Color(0xffF5F5F5)]
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 7),
                    Text(
                      '${electric[index]['name']}',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${electric[index]['address']}',
                      style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      '${electric[index]['time']}',
                      style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w400, color: Color(0xff6A6A6A)
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