import 'package:flutter/material.dart';
import 'package:mosigg/map/common/tabbarWidget.dart';
import 'package:mosigg/map/googlemap.dart';
import 'package:mosigg/map/maplist.dart';

// ignore: must_be_immutable
class GasStation extends StatefulWidget {
  const GasStation({Key? key}) : super(key: key);

  @override
  _GasStationState createState() => _GasStationState();
}

class _GasStationState extends State<GasStation> {
  @override
  Widget build(BuildContext context){
    return ListView(
      children: [
        FilterMethod(),
        listview(gas.length)
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
            latitude = gas[index]['x'].toString();
            longtitude = gas[index]['y'].toString();
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
                colors: [Color(0xff001A5D), Color(0xffF5F5F5)]
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${gas[index]['name']}',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                    '${gas[index]['price']}',
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      '${gas[index]['address']}',
                      style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      '${gas[index]['time']}',
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