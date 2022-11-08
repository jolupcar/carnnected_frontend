import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mosigg/map/common/tabbarWidget.dart';
import 'package:mosigg/map/googlemap.dart';

var priceFormat = NumberFormat.currency(locale: "ko_KR", symbol: "");

class GasStation extends StatefulWidget {
  //final Future<Position> position;
  final Future<List>? data1, data2, data3;
  const GasStation(
    {Key? key,
    required this.data1,
    required this.data2,
    required this.data3}) 
    : super(key: key);

  @override
  _GasStationState createState() => _GasStationState();
}

class _GasStationState extends State<GasStation> {
  final List<String> optionList = ['거리순', '가격순'];
  String selectedOption = '거리순';
  final isSelected = <bool>[true, false];
  List<String> rangeList = ['2km', '5km'];
  String range = '';
  late int radius = 2000;
  late int sort = 1;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 22),
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: selectedOption,
                  items: optionList.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value)
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value.toString();
                      if(selectedOption == '거리순'){
                        sort = 1;
                      } else {
                        sort = 2;
                      }
                    });
                  },
                  style: TextStyle(fontSize: 12.0, color: Colors.black),
                ),
              ),
              SizedBox(width: 4),
              (sort == 1)
              ? Container(
                  height: 17,
                  child: ToggleButtons(
                    color: Colors.black,
                    selectedColor: Colors.white,
                    selectedBorderColor: Color(0xff001a5d),
                    fillColor: Color(0xff001a5d),
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++){
                          if (buttonIndex == index) {
                            isSelected[buttonIndex] = true;
                            range = rangeList[buttonIndex];
                          } else {
                            isSelected[buttonIndex] = false;
                          }
                        }
                        if (range == '2km') {
                          radius = 2000;
                        } else {
                          radius = 5000;
                        }
                      });
                    },
                    children: [
                      toggleItem(context, rangeList[0], rangeList.length),
                      toggleItem(context, rangeList[1], rangeList.length)
                    ],
                    isSelected: isSelected,
                  ),
                )
              : SizedBox(width: 0)
            ],
          ),
          (sort == 1)
          ? (radius == 2000)
          ? ListView( // 거리순 2km
              shrinkWrap: true,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: FutureBuilder<List>(
                    future: widget.data1,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return listview(snapshot.data!.length, snapshot.data!);
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                  ),
                ),
              ],
            )
          : ListView( // 거리순 5km
              shrinkWrap: true,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: FutureBuilder<List>(
                    future: widget.data2,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return listview(snapshot.data!.length, snapshot.data!);
                      } else {
                        return Center(
                          child: CircularProgressIndicator()
                        );
                      }
                    }
                  ),
                ),
              ],
            )
          : ListView( // 가격순
              shrinkWrap: true,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: FutureBuilder<List>(
                    future: widget.data3,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return listview(snapshot.data!.length, snapshot.data!);
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                  ),
                ),
              ],
            )
          ],
      ),
    );
  }
}

Widget listview(itemCount, itemData) {
  return ListView.separated(
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    shrinkWrap: true,
    itemCount: itemCount,
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
                      itemData[index].long, itemData[index].lat
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
                colors: [Color(0xff001A5D), Color(0xffF5F5F5)]
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      '${itemData[index].name}',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      '휘발유 ${priceFormat.format(itemData[index].price)}',
                      style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(height: 6.6),
                    Text(
                      '${itemData[index].addr}',
                      style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400
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

Container toggleItem(context, text, itemNum) {
  return Container(
    width: (MediaQuery.of(context).size.width - 300.0) / itemNum,
    child: Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400),
      ),
    ),
  );
}