import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/helper/app.dart';

class MyTextField extends StatefulWidget {
  final double width;
  final double height;
  final TextEditingController controller;
  final RxBool validate;
  final String label;
  final void Function(String) onChanged;
  final TextInputType keyboardType;


  MyTextField({
    required this.width,
    required this.height,
    required this.controller,
    required this.validate,
    required this.label,
    required this.onChanged,
    this.keyboardType = TextInputType.text
  });
  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
            enabledBorder: widget.validate.value
                ?OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)
            )
                :OutlineInputBorder(
                borderSide: BorderSide(color: App.grey)
            ),

            focusedBorder:  widget.validate.value
                ?OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)
            )
                :OutlineInputBorder(
                borderSide: BorderSide(color: App.grey)
            ),

            label: Text(App_Localization.of(context).translate(widget.label),style: TextStyle(color: App.grey),),
            labelStyle: TextStyle(color: App.grey)
        ),
      ),
    );
  }
}
