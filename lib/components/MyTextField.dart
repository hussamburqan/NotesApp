import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hinttext ;
  final TextEditingController mycontroller ;
  final String? Function(String?)? validator;
  final int? maxLines;
  final double? borderRadius;
  const MyTextField({super.key, required this.hinttext, required this.mycontroller, this.validator,this.maxLines, this.borderRadius});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {

    return TextFormField(
      validator: widget.validator,
      controller: widget.mycontroller,
      maxLines: widget.maxLines  ?? 1,
      decoration: InputDecoration(
          hintText: widget.hinttext,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 50),
              borderSide:
              const BorderSide(color: Color.fromARGB(255, 184, 184, 184))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 50),
              borderSide: const BorderSide(color: Colors.grey))),
    );
  }
}