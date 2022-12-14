import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/helper/app.dart';

class ProfileBtn extends StatelessWidget {

  final VoidCallback onPressed;
  final Widget icon;
  final String text;


  ProfileBtn({
    required this.onPressed,required this.icon,required this.text
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Container(
          width: Get.width,
          height: 30,
          padding: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: App.dark_grey,width: 1.5)
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 10,),
                  icon,
                  SizedBox(width: 10,),
                  Text(App_Localization.of(context).translate(text),style: TextStyle(fontSize: 16,color: App.dark_blue,fontWeight: FontWeight.bold),)
                ],
              ),
              Icon(Icons.arrow_forward_ios,color: App.dark_grey)
            ],
          )
      ),
    );
  }
}
