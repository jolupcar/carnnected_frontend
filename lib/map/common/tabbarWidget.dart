import 'package:flutter/material.dart';

class FilterMethod extends StatefulWidget {
  const FilterMethod({ Key? key }) : super(key: key);

  @override
  _FilterMethodState createState() => _FilterMethodState();
}

class _FilterMethodState extends State<FilterMethod> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: (){},
              child: Text(
                '거리순',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black)
              )
            ),
            SizedBox(width: 20)
          ],
        ),
      ],
    );
  }
}

class Location{
  double x;
  double y;
  Location(this.x, this.y);
}

var latitude = '';
var longtitude = '';