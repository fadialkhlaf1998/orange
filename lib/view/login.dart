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
      // backgroundColor: App.primary_mid,
      appBar: AppBar(
        title: Text(App_Localization.of(context).translate("login"),
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
                return loginController.loading.value
                    ?App.loading(context)
                    :Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loginController.fake.value?Center():Center(),
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
                    ),
                    SizedBox(height: 30,),
                    PrimaryBottun(
                      width: Get.width/2,
                      height: 50,
                      onPressed: (){
                        loginController.login(context);
                      },
                      color: App.primary,
                      text: "login",
                      linearGradient: App.linearGradient,
                    ),
                    SizedBox(height: 15,),
                    PrimaryBottun(
                      width: Get.width/2,
                      height: 50,
                      onPressed: (){
                        loginController.homeController.refreshData();
                        Get.off(()=>Main());
                      },
                      color: App.primary,
                      text: "visit_as_guest",
                      linearGradient: App.linearGradient,
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            loginController.forgot_password(context);
                          },
                          child: Text(App_Localization.of(context).translate("forgot_password"),
                            style: TextStyle(color: App.primary,decoration: TextDecoration.underline,fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.to(()=>SignUp());
                          },
                          child: Text(App_Localization.of(context).translate("sign_up"),
                            style: TextStyle(color: App.primary,decoration: TextDecoration.underline,fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
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
