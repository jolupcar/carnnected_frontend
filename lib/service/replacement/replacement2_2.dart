import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mosigg/provider/replaceProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mosigg/components.dart';

class Replacement22 extends StatefulWidget {
  final int index;
  final String? image;
  final String name;
  final String price;

  const Replacement22(
      {Key? key,
      required this.index,
      required this.image,
      required this.name,
      required this.price})
      : super(key: key);

  @override
  _Replacement22State createState() => _Replacement22State();
}

class _Replacement22State extends State<Replacement22> {
  Future<Item>? item;

  /*가격*/
  var priceFormat = NumberFormat.currency(locale: "ko_KR", symbol: "");
  late int total;
  int? opPrice;
  int opIndex = 0;

  @override
  void initState() {
    super.initState();
    item = getItemDetail(widget.index);
    total = int.parse(widget.price);
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
      floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 16),
          width: MediaQuery.of(context).size.width - 50,
          height: 40,
          child: FloatingActionButton(
            backgroundColor: Color(0xff001A5D),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.0,
            onPressed: () {
              context.read<CountPurchase>().increase();
              context.read<MyCart>().add(CartItem(
                  (widget.index).toString()+'-'+(opIndex).toString(), widget.name, total));
              Navigator.pop(context);
            },
            child: text('${priceFormat.format(total)}원 담기', 14.0,
                FontWeight.w500, Colors.white),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 360,
              height: 212,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (widget.image == null)
                      ? AssetImage('image/none.png')
                      : AssetImage(widget.image!),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 17, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 250,
                        child: Row(
                          children: [
                            Flexible(
                                child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                  text: widget.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500)),
                            )),
                          ],
                        ),
                      ),
                      text(priceFormat.format(int.parse(widget.price)) + '원',
                          18.0, FontWeight.w500, Colors.black),
                    ],
                  ),
                  SizedBox(height: 14),
                  FutureBuilder<Item>(
                      future: item,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.opName == null) {
                            return Container();
                          } else {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text(snapshot.data!.opName, 16.0,
                                      FontWeight.w500, Colors.black),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 28.0 * snapshot.data!.op!.length,
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.op!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                              splashColor: Colors.grey[50],
                                              onTap: () {
                                                setState(() {
                                                  snapshot.data!.op!
                                                      .forEach((element) {
                                                    element.isSelected = false;
                                                  });
                                                  snapshot.data!.op![index]
                                                      .isSelected = true;
                                                  opPrice = snapshot
                                                      .data!.opPrice![index];
                                                  total =
                                                      int.parse(widget.price) +
                                                          opPrice!;
                                                  opIndex = index;
                                                });
                                              },
                                              child: CustomRadioItem(
                                                  item: snapshot
                                                      .data!.op![index]));
                                        }),
                                  ),
                                  SizedBox(height: 50),
                                ]);
                          }
                        } else {
                          return Text('옵션 불러오는 중!');
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomRadioItem extends StatelessWidget {
  final CustomRadio item;

  const CustomRadioItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      height: 22,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 2),
          item.isSelected
              ? Container(
                  height: 27,
                  width: 27,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 7.0, color: Color(0xff001A5D))),
                )
              : Container(
                  height: 27,
                  width: 27,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.0, color: Colors.grey)),
                ),
          SizedBox(width: 6),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(item.option, 12.0, FontWeight.w400, Colors.black),
                text('+' + item.price + '원', 12.0, FontWeight.w400,
                    Colors.black),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomRadio {
  late bool isSelected;
  late String option;
  late String price;

  CustomRadio(this.isSelected, this.option, this.price);
}

Future<Item> getItemDetail(int index) async {
  final response =
      await http.get(Uri.parse('http://10.20.10.189:8080/replace_item/$index'));

  late Item item;

  if (response.statusCode == 200) {
    print(response.body);
    var json = jsonDecode(response.body);
    item = Item.fromJson(json);
    return item;
  } else {
    throw Exception('Failed to load item data');
  }
}

class Item {
  final String? opName;
  final List? op;
  final List? opPrice;

  Item({this.opName, this.op, this.opPrice});
  factory Item.fromJson(Map<dynamic, dynamic> json) {
    List<CustomRadio> opList = [];
    List opPrice = [];

    if (json['option'] != null) {
      for (var i = 0; i < jsonDecode(json['option']).length; i++) {
        opList.add(CustomRadio(false, jsonDecode(json['option'])[i].toString(),
            jsonDecode(json['opPrice'])[i].toString()));
        opPrice.add(jsonDecode(json['opPrice'])[i]);
      }
    }

    return Item(
      opName: json['opName'],
      op: opList,
      opPrice: opPrice,
    );
  }
}