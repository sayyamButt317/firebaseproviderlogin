import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.validator,
    this.keyboardType,
    this.cursorColor = Colors.black,
    this.labelText,
    this.hintText,
    this.labelStyle,
    this.prefixIcon,
    this.enabledBorder,
    this.focusedBorder,
    this.suffixIcon,
    this.decoration,
    this.text,
    this.padding,
    this.enabled,
    this.readOnly,
    this.showCursor,
    this.obscureText,
    this.textColor,
    this.onChanged,
    this.focusNode,
    this.value,
  });

  final TextEditingController? controller;
  final FormFieldValidator? validator;

  final String? Function(dynamic value)? onChanged;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Color? cursorColor;
  final String? labelText;
  final String? hintText;
  final TextStyle? labelStyle;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputDecoration? decoration;
  final String? text;
  final EdgeInsetsGeometry? padding;
  final bool? enabled;
  final bool? readOnly;
  final bool? showCursor;
  final bool? obscureText;
  final Color? textColor;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        enabled: enabled,
        readOnly: readOnly ?? false,
        showCursor: showCursor,
        obscureText: obscureText ?? false,
        controller: controller,
        autocorrect: true,
        validator: validator,
        keyboardType: keyboardType,
        cursorColor: cursorColor,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          labelStyle: labelStyle ??
              const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
          prefixIcon:
              prefixIcon != null ? Icon(prefixIcon, color: Colors.black) : null,
          enabledBorder: enabledBorder ??
              OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
          focusedBorder: focusedBorder ??
              OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
