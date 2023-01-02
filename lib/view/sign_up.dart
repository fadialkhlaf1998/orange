import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/controller/sign_up_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/widgets/logo.dart';
import 'package:orange/widgets/primary_bottun.dart';
import '../app_localization.dart';
import 'package:orange/widgets/text_field.dart';

class SignUp extends StatelessWidget {
  SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: App.background,
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          child: Center(
            child: Container(
              width: Get.width*0.8,
              child:Obx(() {
                return signupController.loading.value
                    ?App.loading(context)
                    :SingleChildScrollView(
                      child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      signupController.fake.value?Center():Center(),
                      Logo(70),
                      SizedBox(height: 30,),
                      MyTextField(
                        width: Get.width,
                        height: 50,
                        controller: signupController.name,
                        validate: (signupController.name.text.isEmpty&&signupController.validate.value).obs,
                        label: "name",
                        onChanged: (value){
                          signupController.fake.value = !signupController.fake.value;
                        },
                        errText: (signupController.name.text.isEmpty&&signupController.validate.value)?"name_is_required":null,
                      ),
                      SizedBox(height: 30,),
                      MyTextField(
                        width: Get.width,
                        height: 50,
                        controller: signupController.email,
                        validate: ((signupController.email.text.isEmpty||!signupController.email.text.isEmail)&&signupController.validate.value).obs,
                        label: "email",
                        onChanged: (value){
                          signupController.fake.value = !signupController.fake.value;
                        },
                        errText: ((signupController.email.text.isEmpty||!signupController.email.text.isEmail)&&signupController.validate.value)?"plz_enter_a_valid_email":null,
                      ),

                      SizedBox(height: 30,),
                      MyTextField(
                        width: Get.width,
                        height: 50,
                        controller: signupController.password,
                        validate: ((signupController.password.text.isEmpty||signupController.password.text.length<6)&&signupController.validate.value).obs,
                        label: "password",
                        isPassword: true,
                        onChanged: (value){
                          signupController.fake.value = !signupController.fake.value;
                        },
                        hidden: signupController.hidePassword,
                        errText: ((signupController.password.text.isEmpty||signupController.password.text.length<6)&&signupController.validate.value)?"password_must_be_more_than_6":null,
                      ),
                      SizedBox(height: 30,),
                      PrimaryBottun(
                        width: Get.width*0.8,
                        radiuce: 25,
                        height: 50,
                        onPressed: (){
                          signupController.signup(context);
                        },
                        color: App.dark_grey,
                        text: "sign_up",
                        // linearGradient: App.linearGradient,
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(App_Localization.of(context).translate("have_account"),style: TextStyle(color: App.dark_grey,fontSize: 12),),
                          SizedBox(width: 5,),
                          GestureDetector(
                            onTap: (){
                              Get.back();

                            },
                            child: Text(App_Localization.of(context).translate("login").toUpperCase(),style: TextStyle(color: App.primary,decoration: TextDecoration.underline,decorationThickness: 1.5,fontWeight: FontWeight.bold,fontSize: 12),),
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

  
}
