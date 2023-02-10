import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final bool? enable;
  final bool? capital;
  final String? labelText;
  final FormFieldValidator<String>? validate;

  const CustomTextField({this.textEditingController,this.textInputType,this.labelText,this.validate,this.enable = true,this.capital = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: textInputType,
      enabled: enable,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textCapitalization: capital! ? TextCapitalization.words : TextCapitalization.none,
      validator: validate!,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.black
        ),
      ),
    );
  }
}
