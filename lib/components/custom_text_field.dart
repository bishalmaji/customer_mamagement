import 'package:flutter/material.dart';

class CustomTextFormField extends TextFormField {
  CustomTextFormField({
    Key? key,
    required this.validator,
    required this.onSaved,
    required this.keyboardType,
    this.initialValue,
    this.decoration = const InputDecoration(),
  }) : super(
    key: key,
    validator: validator,
    onSaved: onSaved,
    keyboardType: keyboardType,
    initialValue: initialValue,
    decoration: decoration,
  );

  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final TextInputType keyboardType;
  final String? initialValue;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              validator: validator,
              onSaved: onSaved,
              keyboardType: keyboardType,
              initialValue: initialValue,
              decoration: decoration.copyWith(
                errorStyle: TextStyle(height: 0), // Hide the default error message
              ),
            ),
          )
        ],
      ),
    );
  }
}
