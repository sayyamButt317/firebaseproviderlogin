import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    this.formKey,
    this.controller,
    this.text,
    this.height,
    this.padding,
    this.style,
    required this.onPressed,
    this.width,
    this.loading = false, // Default loading state is false
  }) : super(key: key);

  final GlobalKey<FormState>? formKey;
  final TextEditingController? controller;
  final String? text;
  final double? height;
  final double? width;
  final bool loading;
  final EdgeInsetsGeometry? padding;
  final Color? style;
  final VoidCallback onPressed;

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
        color: loading
            ? Colors.grey
            : Colors.black, // Change color during loading state
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Center(
                child: Text(
                  text ?? '',
                  style: TextStyle(
                    color: loading
                        ? Colors.grey
                        : Colors
                            .white, // Change text color during loading state
                  ),
                ),
              ),
      ),
    );
  }
}
