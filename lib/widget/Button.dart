import 'package:flutter/material.dart';
import 'Text.dart';

class CustomButton extends StatelessWidget {

  final VoidCallback? action;
  final String? text;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final double? radius;

  const CustomButton({this.action,this.text,this.fontSize,this.color,this.radius,this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius!),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
          child: CustomText(
            text: text,
            color: textColor,
            size: fontSize,
          ),
        ),
      ),
    );
  }
}
