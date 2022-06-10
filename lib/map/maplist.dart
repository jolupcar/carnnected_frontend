import 'package:flutter/material.dart';
import 'package:mosigg/map/common/companies.dart';
import 'package:mosigg/map/gasstation.dart';
import 'package:mosigg/map/carwash.dart';
import 'package:mosigg/map/repairshop.dart';
import 'package:mosigg/map/electriccar.dart';

var gas = [];
var wash = [];
var repair = [];
var electric = [];

class MapList extends StatefulWidget {
  const MapList({ Key? key }) : super(key: key);

  @override
  State<MapList> createState() => _MapListState();
}

class _MapListState extends State<MapList> {

  @override
  void initState(){
    for(var i=0; i<companies.length; i++){
      if(companies[i]['type']=='주유'){
        gas.add(companies[i]);
      }
      else if(companies[i]['type']=='세차'){
        wash.add(companies[i]);
      }
      else if(companies[i]['type']=='정비'){
        repair.add(companies[i]);
      }
      else {
        electric.add(companies[i]);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(49),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: Color(0xff001A5D),
                labelColor: Colors.black,
                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
                tabs: [
                  Tab(text: '주유소'),
                  Tab(text: '세차장'),
                  Tab(text: '정비소'),
                  Tab(text: '전기차')
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              GasStation(),
              CarWash(),
              RepairShop(),
              ElectricCar(),
            ],
          ),
        ),
      ),
    );
  }
}