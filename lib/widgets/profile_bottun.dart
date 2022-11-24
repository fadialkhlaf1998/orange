import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';

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
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey,width: 1.5)
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
                  Text(App_Localization.of(context).translate(text),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                ],
              ),
              Icon(Icons.arrow_forward_ios,color: Colors.black)
            ],
          )
      ),
    );
  }
}
