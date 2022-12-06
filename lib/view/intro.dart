import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/view/pdf_viewer.dart';

class Intro extends StatelessWidget {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: App.primary_mid,
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/logo.png")),
                ),
              ),
              SizedBox(height: 20,),
              Text("ORANGE",style: TextStyle(letterSpacing: 1.5,color: App.primary,fontWeight: FontWeight.bold,fontSize: 30),)
            ],
          ),
        ),
      ),
    );
  }
}
