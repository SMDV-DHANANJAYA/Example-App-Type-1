import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {

  final String? text;
  final double? size;
  final double? letterSpace;
  final Color? color;
  final bool? resize;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final int? maxLines;

  const CustomText({this.text,this.size,this.letterSpace,this.color,this.resize = false,this.textAlign,this.fontWeight,this.maxLines});

  @override
  Widget build(BuildContext context) {
    return resize! ?
    AutoSizeText(
      text!,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        letterSpacing: letterSpace,
        color: color,
      ),
    ) :
    Text(
      text!,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        letterSpacing: letterSpace,
        color: color,
      ),
    );
  }
}
