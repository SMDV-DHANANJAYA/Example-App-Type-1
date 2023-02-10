import 'package:flutter/material.dart';

class CustomLoadingProgress extends StatelessWidget {

  final Color color;

  const CustomLoadingProgress(this.color);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }
}
