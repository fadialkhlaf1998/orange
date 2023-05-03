import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/login_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/view/main.dart';
import 'package:orange/view/sign_up.dart';
import 'package:orange/widgets/logo.dart';
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
              width: Get.width * 0.92,
              child: Obx(() {
                return loginController.loading.value
                    ? App.loading(context)
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            loginController.fake.value ? Center() : Center(),
                            Logo(70,false),
                            SizedBox(height: 20,),
                            Text(App_Localization.of(context).translate("sign_in_to_shop_now"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                            SizedBox(
                              height: 30,
                            ),
                            MyTextField(

                              width: Get.width,
                              prefix: Container(
                                width: 50,
                                height: 50,
                                child: Padding(
                                  padding: EdgeInsets.all(13),
                                  child: Image.asset("assets/icons/email.png"),
                                ),
                              ),
                              height: 50,
                              controller: loginController.email,
                              validate: ((loginController.email.text.isEmpty ||
                                          !loginController
                                              .email.text.isEmail) &&
                                      loginController.validate.value)
                                  .obs,
                              label: "email",
                              onChanged: (value) {
                                loginController.fake.value =
                                    !loginController.fake.value;
                              },
                              errText: ((loginController.email.text.isEmpty ||
                                          !loginController
                                              .email.text.isEmail) &&
                                      loginController.validate.value)
                                  ? "plz_enter_a_valid_email"
                                  : null,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            MyTextField(
                              prefix: Container(
                                width: 50,
                                height: 50,
                                child: Padding(
                                  padding: EdgeInsets.all(13),
                                  child: Image.asset("assets/icons/lock-Filled@2x.png"),
                                ),
                              ),
                              width: Get.width,
                              height: 50,
                              controller: loginController.password,
                              validate:
                                  (loginController.password.text.isEmpty &&
                                          loginController.validate.value)
                                      .obs,
                              label: "password",
                              onChanged: (value) {
                                loginController.fake.value =
                                    !loginController.fake.value;
                              },
                              hidden: loginController.hidePassword,
                              isPassword: true,
                              errText: (loginController.password.text.isEmpty &&
                                      loginController.validate.value)
                                  ? "password_is_required"
                                  : null,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    loginController.forgot_password(context);
                                  },
                                  child: Text(
                                    App_Localization.of(context)
                                        .translate("forgot_password"),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: App.primary,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            PrimaryBottun(
                              width: Get.width * 0.92,
                              height: 50,
                              onPressed: () {
                                loginController.login(context);
                              },
                              color: App.primary,
                              radiuce: 25,
                              text: "login",
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            PrimaryBottun(
                              width: Get.width * 0.92,
                              height: 50,
                              onPressed: () {
                                loginController.homeController.refreshData();
                                Get.off(() => Main());
                              },
                              text: "visit_as_guest",
                              color: Colors.transparent,
                              textColor: App.primary,
                              radiuce: 25,
                              border: Border.all(color: App.primary),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: Get.width * 0.92,
                              child: Row(
                                children: [
                                  Expanded(
                                      child:Container(
                                        height: 1,
                                        color: App.grey95.withOpacity(0.25),
                                      )
                                  ),
                                  SizedBox(width: 8,),
                                  Text(App_Localization.of(context).translate("or_continue_with"),style: TextStyle(color: App.grey95,fontSize: 12),),
                                  SizedBox(width: 8,),
                                  Expanded(
                                      child:Container(
                                        height: 1,
                                        color: App.grey95.withOpacity(0.25),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      child: Center(
                                        child: Platform.isIOS
                                            ? Image.asset("assets/icons/Apple.png",width: 30,)
                                            : Image.asset("assets/icons/Google.png",width: 30,)
                                      )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  App_Localization.of(context)
                                      .translate("donot_have_account"),
                                  style: TextStyle(
                                      color: App.dark_grey, fontSize: 12),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => SignUp());
                                  },
                                  child: Text(
                                    App_Localization.of(context)
                                        .translate("sign_up")
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: App.primary,
                                        decoration: TextDecoration.underline,
                                        decorationThickness: 1.5,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
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
