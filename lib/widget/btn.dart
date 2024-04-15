import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.formKey,
    this.controller,
    this.text,
    this.height,
    this.padding,
    this.style,
    required this.onPressed,
    this.width,
    this.loading = false,
  });

  final GlobalKey<FormState>? formKey;
  final TextEditingController? controller;
  final String? text;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? style;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: loading ? null : onPressed,
        height: height ?? 50,
        minWidth: width,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.black,
      
        child:loading ? const Center(
          child:CircularProgressIndicator(color:Colors.white,)):Center( 
           child: Text(
          text ?? '',
          style: const TextStyle(
            color: Colors.white,

          ),
        ),)
      ),
    );
  }
}
