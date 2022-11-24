import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/controller/sign_up_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/widgets/primary_bottun.dart';
import '../app_localization.dart';
import 'package:orange/widgets/text_field.dart';

class SignUp extends StatelessWidget {
  SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: App.primary_mid,
      appBar: AppBar(
        title: Text(App_Localization.of(context).translate("sign_up"),
          style: TextStyle(
            fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        leading: App.backBtn(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: App.linearGradient,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:  Radius.circular(20)),
              boxShadow: [
                App.darkBottomShadow,
              ]
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          child: Center(
            child: Container(
              width: Get.width*0.9,
              child:Obx(() {
                return signupController.loading.value
                    ?App.loading(context)
                    :Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    signupController.fake.value?Center():Center(),

                    MyTextField(
                      width: Get.width,
                      height: 50,
                      controller: signupController.name,
                      validate: (signupController.name.text.isEmpty&&signupController.validate.value).obs,
                      label: "name",
                      onChanged: (value){
                        signupController.fake.value = !signupController.fake.value;
                      },
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
                    ),

                    SizedBox(height: 30,),
                    MyTextField(
                      width: Get.width,
                      height: 50,
                      controller: signupController.password,
                      validate: ((signupController.password.text.isEmpty||signupController.password.text.length<6)&&signupController.validate.value).obs,
                      label: "password",
                      onChanged: (value){
                        signupController.fake.value = !signupController.fake.value;
                      },
                    ),
                    SizedBox(height: 30,),
                    PrimaryBottun(
                      width: Get.width/2,
                      height: 50,
                      onPressed: (){
                        signupController.signup(context);
                      },
                      color: App.primary,
                      text: "sign_up",
                      linearGradient: App.linearGradient,
                    ),
                    SizedBox(height: 15,),

                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
