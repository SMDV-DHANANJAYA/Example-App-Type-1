import 'package:flutter/material.dart';
import 'IconButton.dart';

class CustomPasswordField extends StatelessWidget {

  final TextEditingController? textEditingController;
  final bool? showPassword;
  final VoidCallback? passwordVisibility;
  final FormFieldValidator<String>? validate;
  final String? labelText;

  const CustomPasswordField({this.textEditingController,this.showPassword,this.passwordVisibility,this.validate,this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: showPassword!,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validate,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.black
        ),
        suffixIcon: CustomIconButton(
          icon: showPassword! ? Icons.visibility_off : Icons.visibility,
          color: Colors.black,
          action: passwordVisibility!,
        ),
      ),
    );
  }
}
