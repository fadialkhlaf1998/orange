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
  final bool isPassword;

  final RxBool hidden = true.obs;


  MyTextField({
    required this.width,
    required this.height,
    required this.controller,
    required this.validate,
    required this.label,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.isPassword = false
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
      decoration: BoxDecoration(
        color: App.grey,
        borderRadius: BorderRadius.circular(widget.height/2)
      ),
      child: Obx(() => TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        obscureText: widget.isPassword?widget.hidden.value:false,
        style: TextStyle(color: App.dark_grey),
        decoration: InputDecoration(

          suffix: widget.isPassword?GestureDetector(
            onTap: (){
              widget.hidden(!widget.hidden.value);
              print(widget.hidden.value);
            },
            child: Icon(widget.hidden.value?Icons.visibility_off_outlined:Icons.visibility_outlined,color: App.dark_grey,),
          ):null,

          enabledBorder: widget.validate.value
              ?OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(widget.height/2)
          )
              :OutlineInputBorder(
              borderSide: BorderSide(color: App.grey),
              borderRadius: BorderRadius.circular(widget.height/2)
          ),

          focusedBorder:  widget.validate.value
              ?OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(widget.height/2)
          )
              :OutlineInputBorder(
              borderSide: BorderSide(color: App.primary),
              borderRadius: BorderRadius.circular(widget.height/2)
          ),

          label: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Text(App_Localization.of(context).translate(widget.label),style: TextStyle(color: App.dark_grey),),
          ),
          labelStyle: TextStyle(color: App.grey),
        ),
      )),
    );
  }
}
