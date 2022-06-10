import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:mosigg/service/replacement/replacement3.dart';
import 'package:mosigg/service/replacement/replacement2_2.dart';
import 'package:provider/provider.dart';
import 'package:mosigg/provider/replaceProvider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mosigg/components.dart';

var priceFormat = NumberFormat.currency(locale: "ko_KR", symbol: "");

class Replacement2 extends StatefulWidget {
  final String id;
  final String dateAndTime;
  final String carLocation;
  final String carDetailLocation;
  final String payment;

  const Replacement2(
    {Key? key,
    required this.id,
    required this.dateAndTime,
    required this.carLocation,
    required this.carDetailLocation,
    required this.payment})
    : super(key: key);

  @override
  _Replacement2State createState() => _Replacement2State();
}

class _Replacement2State extends State<Replacement2> with TickerProviderStateMixin {
  late String id;
  Future<List>? itemListData;

  late TabController _controller;
  late AnimationController _animationControllerOn;
  late AnimationController _animationControllerOff;
  late Animation _colorTweenBackgroundOn;
  late Animation _colorTweenBackgroundOff;

  int _currentIndex = 0;
  int _prevControllerIndex = 0;
  double _aniValue = 0.0;
  double _prevAniValue = 0.0;

  List _tabs = [
    'ALL',
    '와이퍼',
    '에어컨필터',
    '워셔액',
    '엔진오일',
    '배터리',
    '타이어',
    '타이어 공기압'
  ];

  Color _backgroundOn = Color(0xff001a5d);
  Color _backgroundOff = Colors.grey;

  ScrollController _scrollController = new ScrollController();
  List _keys = [];
  bool _buttonTap = false;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    itemListData = getItemList();

    for (int index = 0; index < _tabs.length; index++) {
      _keys.add(new GlobalKey());
    }

    _controller = TabController(vsync: this, length: _tabs.length);
    _controller.animation!.addListener(_handleTabAnimation);
    _controller.addListener(_handleTabChange);

    _animationControllerOff =
        AnimationController(vsync: this, duration: Duration(milliseconds: 75));
    _animationControllerOff.value = 1.0;
    _colorTweenBackgroundOff =
        ColorTween(begin: _backgroundOn, end: _backgroundOff)
            .animate(_animationControllerOff);

    _animationControllerOn =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animationControllerOn.value = 1.0;
    _colorTweenBackgroundOn =
        ColorTween(begin: _backgroundOff, end: _backgroundOn)
            .animate(_animationControllerOn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onPressedFunction(
    BuildContext context,
    String dateAndTime,
    String carLocation,
    String carDetailLocation,
    String payment) {
    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Replacement3(
                            id: id,
                            dateAndTime: dateAndTime,
                            carLocation: carLocation,
                            carDetailLocation: carDetailLocation,
                            payment: payment
                            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: text('교체 서비스 예약', 16.0, FontWeight.w500, Colors.black),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 49.0,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  key: _keys[index],
                  padding: EdgeInsets.all(6.0),
                  child: ButtonTheme(
                      child: AnimatedBuilder(
                    animation: _colorTweenBackgroundOn,
                    builder: (context, child) => TextButton(
                      style: TextButton.styleFrom(
                        primary: _getBackgroundColor(index),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(7.0)),
                        ),
                      onPressed: () {
                        setState(() {
                          _buttonTap = true;
                          _controller.animateTo(index);
                          _setCurrentIndex(index);
                          _scrollTo(index);
                        });
                      },
                      child: Text(
                        '${_tabs[index]}',
                      )),
                  ))
                );
              }
            ),
          ),
          Flexible(
            child: TabBarView(
              controller: _controller,
              children: [
                FutureBuilder<List>(
                  future: itemListData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return listview(snapshot.data!.length, snapshot.data!);
                    } else {
                      return Text('상품 불러오는 중!');
                    }
                  }
                ),
                FutureBuilder<List>(
                  future: itemListData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return listview2(snapshot.data!.length, snapshot.data!, '와이퍼');
                    } else {
                      return Text('상품 불러오는 중!');
                    }
                  }
                ),
                FutureBuilder<List>(
                  future: itemListData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return listview2(snapshot.data!.length, snapshot.data!, '에어컨필터');
                    } else {
                      return Text('상품 불러오는 중!');
                    }
                  }
                ),
                FutureBuilder<List>(
                  future: itemListData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return listview2(snapshot.data!.length, snapshot.data!, '워셔액');
                    } else {
                      return Text('상품 불러오는 중!');
                    }
                  }
                ),
                FutureBuilder<List>(
                  future: itemListData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return listview2(snapshot.data!.length, snapshot.data!, '엔진오일');
                    } else {
                      return Text('상품 불러오는 중!');
                    }
                  }
                ),
                FutureBuilder<List>(
                  future: itemListData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return listview2(snapshot.data!.length, snapshot.data!, '배터리');
                    } else {
                      return Text('상품 불러오는 중!');
                    }
                  }
                ),
                FutureBuilder<List>(
                  future: itemListData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return listview2(snapshot.data!.length, snapshot.data!, '타이어');
                    } else {
                      return Text('상품 불러오는 중!');
                    }
                  }
                ),
                FutureBuilder<List>(
                  future: itemListData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return listview2(snapshot.data!.length, snapshot.data!, '공기압');
                    } else {
                      return Text('상품 불러오는 중!');
                    }
                  }
                ),
              ],
            ),
          ),

        ]
      ),
      backgroundColor: Colors.white,
      floatingActionButton: Container(
        height: 56,
        width: 56,
        child: FloatingActionButton(
          onPressed: () {
            onPressedFunction(
              context,
              widget.dateAndTime,
              widget.carLocation,
              widget.carDetailLocation,
              widget.payment
            );
          },
          shape: CircleBorder(),
          child: Badge(
              position: BadgePosition.topEnd(top: -8, end: -6),
              toAnimate: true,
              shape: BadgeShape.circle,
              badgeContent: Text(
                '${context.watch<CountPurchase>().count}',
                style: TextStyle(color: Color(0xff001a5d), fontSize: 8),
              ),
              badgeColor: Colors.white,
              showBadge: context.watch<CountPurchase>().count == 0 ? false : true,
              child: Icon(Icons.shopping_bag_rounded)),
          backgroundColor: Color(0xff001a5d),
        ),
      ),
    );
  }

  _handleTabAnimation() {
    _aniValue = _controller.animation!.value;

    if (!_buttonTap && ((_aniValue - _prevAniValue).abs() < 1)) {
      _setCurrentIndex(_aniValue.round());
    }
    _prevAniValue = _aniValue;
  }

  _handleTabChange() {
    if (_buttonTap) _setCurrentIndex(_controller.index);

    if ((_controller.index == _prevControllerIndex) ||
        (_controller.index == _aniValue.round())) _buttonTap = false;

    _prevControllerIndex = _controller.index;
  }

  _setCurrentIndex(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });

      _triggerAnimation();
      _scrollTo(index);
    }
  }

  _triggerAnimation() {
    _animationControllerOn.reset();
    _animationControllerOff.reset();

    _animationControllerOn.forward();
    _animationControllerOff.forward();
  }

  _scrollTo(int index) {
    double screenWidth = MediaQuery.of(context).size.width;

    RenderBox renderBox = _keys[index].currentContext.findRenderObject();
    double size = renderBox.size.width;
    double position = renderBox.localToGlobal(Offset.zero).dx;
    
    double offset = (position + size / 2) - screenWidth / 2;

    if (offset < 0) {
      renderBox = _keys[0].currentContext.findRenderObject();
      position = renderBox.localToGlobal(Offset.zero).dx;

      if (position > offset) offset = position;
    } else {

      renderBox = _keys[_tabs.length - 1].currentContext.findRenderObject();
      position = renderBox.localToGlobal(Offset.zero).dx;
      size = renderBox.size.width;

      if (position + size < screenWidth) screenWidth = position + size;

      if (position + size - offset < screenWidth) {
        offset = position + size - screenWidth;
      }
    }

    _scrollController.animateTo(offset + _scrollController.offset,
        duration: new Duration(milliseconds: 150), curve: Curves.easeInOut);
  }

  _getBackgroundColor(int index) {
    if (index == _currentIndex) {
      return _colorTweenBackgroundOn.value;
    } else if (index == _prevControllerIndex) {
      return _colorTweenBackgroundOff.value;
    } else {
      return _backgroundOff;
    }
  }
}

Widget listview(itemcount, listname) {
  return ListView(children: [
    ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemcount,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Replacement22(
                          index : listname[index].index,
                          image: listname[index].image,
                          name: listname[index].name,
                          price: listname[index].price,
                        )));
          },
          child: Container(
            width: 360,
            height: 90,
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (listname[index].image == null)
                              ? AssetImage('image/none.png')
                              : AssetImage('${listname[index].image}'),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 23),
                    Container(
                      width: 253,
                      child: Row(
                        children: [
                          Flexible(
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: listname[index].name,
                                style:
                                  TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${priceFormat.format(int.parse(listname[index].price))}원',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff001a5d)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    ),
  ]);
}

Widget listview2(itemcount, listname, type) {
  return ListView(children: [
    ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemcount,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Replacement22(
                          index : listname[index].index,
                          image: listname[index].image,
                          name: listname[index].name,
                          price: listname[index].price,
                        )));
          },
          child: (listname[index].type != type)
                  ? SizedBox(height: 0)
                  : Container(
                      width: 360,
                      height: 90,
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (listname[index].image == null)
                                        ? AssetImage('image/none.png')
                                        : AssetImage('${listname[index].image}'),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 23),
                              Container(
                                width: 253,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          text: listname[index].name,
                                          style:
                                            TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                        ),                                  
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${priceFormat.format(int.parse(listname[index].price))}원',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff001a5d)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => 
            (listname[index].type != type)
            ? SizedBox(height: 0)
            : Divider(),
    ),
  ]);
}

Future<List> getItemList() async {
  final response =
      await http.get(Uri.parse('http://10.20.10.189:8080/replace_item/list'));
  late List<ItemList> itemList = [];

  if (response.statusCode == 200) {
    print(response.body);
    var json = jsonDecode(response.body);
    for (var i = 0; i < json.length; i++) {
      itemList.add(ItemList.fromJson(json[i]));
    }
    return itemList;
  } else {
    throw Exception("교체 리스트를 불러오는데 실패했습니다");
  }
}

class ItemList{
  final int index;
  final String? image;
  final String? type;
  final String? name;
  final String? price;

  ItemList({required this.index, required this.image, required this.type,
            required this.name, required this.price});
  
  factory ItemList.fromJson(Map<String, dynamic> json) {
    return ItemList(index: json['index'], image: json['image'], type: json['type'],
                name: json['name'], price: json['price'].toString());
  }
}