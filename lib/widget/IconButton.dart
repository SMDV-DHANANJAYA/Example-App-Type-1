import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {

  final IconData? icon;
  final Color? color;
  final double? size;
  final VoidCallback? action;

  const CustomIconButton({this.icon,this.color,this.size,this.action});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
        size: size,
      ),
      onPressed: action,
    );
  }
}
