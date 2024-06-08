import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? textSize;
  final Color? textColor;

  final TextAlign? textAlign;

  const CustomText({
    Key? key,
    required this.text,
    this.textSize,
    this.textColor ,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: textSize ?? 16.0,
        color: textColor,
      ),
    );
  }
}
