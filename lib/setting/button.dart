import 'package:flutter/material.dart';

class OutlineCircleButton extends StatelessWidget {
  const OutlineCircleButton({
    Key? key,
    this.onTap,
    this.borderSize: 0.5,
    this.radius: 10.0,
    this.child,
  }) : super(key: key);
  final onTap;
  final radius;
  final borderSize;

  final child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff001a5d), width: borderSize),
          color: Color(0xff001a5d),
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              child: child ?? SizedBox(),
              onTap: () async {
                if (onTap != null) {
                  onTap();
                }
              }),
        ),
      ),
    );
  }
}
