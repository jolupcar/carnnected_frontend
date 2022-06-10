import 'package:flutter/material.dart';

class TextMethod extends StatelessWidget {
  final String content;
  final double size;
  final FontWeight weight;
  final Color color;

  const TextMethod(
      {Key? key,
      required this.content,
      required this.size,
      required this.weight,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(content,
        style: TextStyle(fontSize: size, fontWeight: weight, color: color));
  }
}

class TextFieldMethod extends StatelessWidget {
  final controller;
  final String intro;
  final helperText;
  final bool obsecure;
  final TextInputType? keyType;

  const TextFieldMethod(
      {Key? key,
      required this.controller,
      required this.intro,
      required this.helperText,
      required this.obsecure,
      this.keyType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    TextMethod(content: intro, size: 16.0, weight:FontWeight.w500, color: Colors.black),
    TextField(
      controller: controller,
      obscureText: obsecure,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffCBCBCB), width: 2.0)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffCBCBCB), width: 2.0)),
          helperText: helperText,
          helperStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Color(0xff9D9D9D)),
          focusColor: Colors.grey),
      keyboardType: keyType==null ? TextInputType.name : keyType,
    )
  ]);
  }
}