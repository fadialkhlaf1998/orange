import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/login_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/view/main.dart';
import 'package:orange/view/sign_up.dart';
import 'package:orange/widgets/primary_bottun.dart';
import 'package:orange/widgets/text_field.dart';

class Login extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: App.background,

      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          color: App.background,
          child: Center(
            child: Container(
              width: Get.width*0.8,
              child:Obx(() {
                return loginController.loading.value
                    ?App.loading(context)
                    :SingleChildScrollView(
                      child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      loginController.fake.value?Center():Center(),
                      _logo(context),
                      SizedBox(height: 30,),
                      MyTextField(
                        width: Get.width,
                        height: 50,
                        controller: loginController.email,
                        validate: ((loginController.email.text.isEmpty||!loginController.email.text.isEmail)&&loginController.validate.value).obs,
                        label: "email",
                        onChanged: (value){
                          loginController.fake.value = !loginController.fake.value;
                        },
                      ),
                      SizedBox(height: 30,),
                      MyTextField(
                          width: Get.width,
                          height: 50,
                          controller: loginController.password,
                          validate: (loginController.password.text.isEmpty&&loginController.validate.value).obs,
                          label: "password",
                          onChanged: (value){
                            loginController.fake.value = !loginController.fake.value;
                          },
                        isPassword: true,
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              loginController.forgot_password(context);
                            },
                            child: Text(App_Localization.of(context).translate("forgot_password"),
                              style: TextStyle(fontSize: 12,color: App.primary,decoration: TextDecoration.underline,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                      PrimaryBottun(
                        width: Get.width*0.8,
                        height: 50,
                        onPressed: (){
                          loginController.login(context);
                        },
                        color: App.dark_grey,
                        radiuce: 25,
                        text: "login",
                      ),
                      SizedBox(height: 15,),
                      PrimaryBottun(
                        width: Get.width*0.8,
                        height: 50,
                        onPressed: (){
                          loginController.homeController.refreshData();
                          Get.off(()=>Main());
                        },
                        text: "visit_as_guest",
                        color: App.dark_grey,
                        radiuce: 25,
                      ),
                      SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){

                            },
                            child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: App.primary)
                                ),
                                child: Center(
                                  child: Platform.isIOS
                                      ?Icon(Icons.apple,color: App.primary,size: 30,)
                                      :Icon(Icons.android,color: App.primary,size: 30,),
                                )
                            ),
                          )

                        ],
                      ),

                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(App_Localization.of(context).translate("donot_have_account"),style: TextStyle(color: App.dark_grey,fontSize: 12),),
                          SizedBox(width: 5,),
                          GestureDetector(
                            onTap: (){
                              Get.to(()=>SignUp());
                            },
                            child: Text(App_Localization.of(context).translate("sign_up").toUpperCase(),style: TextStyle(color: App.primary,decoration: TextDecoration.underline,decorationThickness: 1.5,fontWeight: FontWeight.bold,fontSize: 12),),
                          )
                        ],
                      ),
                      SizedBox(height: 15,),

                  ],
                ),
                    );
              }),
            ),
          ),
        ),
      ),
    );
  }
  _logo(BuildContext context){
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/logo.png")),
          ),
        ),
        SizedBox(height: 10,),
        Text("ORANGE",style: TextStyle(letterSpacing: 1.5,color: App.primary,fontWeight: FontWeight.bold,fontSize: 15),)
      ],
    );
  }
}
