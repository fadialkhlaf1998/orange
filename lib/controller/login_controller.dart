import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/model/result.dart';
import 'package:orange/view/main.dart';
import 'package:orange/view/verification_code.dart';

class LoginController extends GetxController{

  HomeController homeController = Get.find();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool validate = false.obs;
  RxBool loading = false.obs;
  RxBool fake = false.obs;

  login(BuildContext context)async{
    validate.value = true;
    if(email.text.isNotEmpty && email.text.isEmail && password.text.isNotEmpty){
      await Api.hasInternet();
      loading.value = true;
      Global.temp_email = email.text;
      Result loginResult = await Api.login(email.text, password.text);
      if(loginResult.code==1){
        homeController.refreshData();
        Get.off(()=>Main());
        App.succMsg(context ,"login", loginResult.message);
      }else if(loginResult.code==-10){
        Get.off(()=>VerificationCode());
        App.errMsg(context , "login",loginResult.message);
      }else{
        App.errMsg(context , "login",loginResult.message);
      }
      await Future.delayed(Duration(seconds: 1));
      loading.value = false;
    }else{

    }
  }

  forgot_password(BuildContext context)async{
    if(email.text.isEmpty){
      App.errMsg(context, "forgot_password", "please_add_your_email");
    }else{
      await Api.hasInternet();
      loading.value = true;
      bool succ = await Api.forgot_password(email.text);
      if(succ){
        App.succMsg(context, "forgot_password", "forgot_password_successfully");
      }else{
        App.errMsg(context, "forgot_password", "wrong");
      }
      loading.value = false;
    }
  }
}