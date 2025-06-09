import 'package:flutter/material.dart';

class DealerCard extends StatelessWidget {
  const DealerCard(
      {super.key,
      this.width,
      this.height,
      this.child,
      this.margin,
      this.borderRadius = const BorderRadius.all(Radius.circular(8)),
      this.padding});

  final double? width;
  final double? height;
  final BorderRadiusGeometry borderRadius;
  final Widget? child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedSuperellipseBorder(
            borderRadius: borderRadius,
            side: BorderSide(color: Colors.grey),
          ),
          shadows: [
            BoxShadow(
              color: Colors.grey.shade500,
              blurRadius: 5,
              offset: Offset(0, 0),
            )
          ]),
      child: child,
    );
  }
}
