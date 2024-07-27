import 'package:flutter/material.dart';

class PassTextField extends StatefulWidget {
  final String hinttext ;
  final TextEditingController mycontroller ;
  final String? Function(String?)? validator;
  const PassTextField({super.key, required this.hinttext, required this.mycontroller, this.validator,});

  @override
  State<PassTextField> createState() => _PassTextFieldState();
}

class _PassTextFieldState extends State<PassTextField> {
  bool showtext = true;
  @override
  Widget build(BuildContext context) {

    return TextFormField(
      obscureText: showtext,
      validator: widget.validator,
      controller: widget.mycontroller,
      decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                showtext = !showtext;
                setState(() {});
              },
              icon: Icon(showtext == true ? Icons.visibility : Icons.visibility_off)),

          hintText: widget.hinttext,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide:
              const BorderSide(color: Color.fromARGB(255, 184, 184, 184))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: Colors.grey))),
    );
  }
}