import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  RxBool hidePassword = false.obs;

  login(BuildContext context)async{
    validate.value = true;
    if(email.text.isNotEmpty && email.text.isEmail && password.text.isNotEmpty){
      await Api.hasInternet();
      loading.value = true;
      Global.temp_email = email.text;
      Result loginResult = await Api.login(email.text, password.text);
      if(loginResult.code==1){
        homeController.refreshData();
        Get.offAll(()=>Main());
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

  loginWithVerify(BuildContext context,String name , String email , String pass)async{
    loading.value = true;
    await Api.hasInternet();
    Global.temp_email = email;
    try{
      await Api.signup(name, email, pass, 1);
    }catch(err){
      print(err);
    }
    Result loginResult = await Api.login(email, pass);
    if(loginResult.code==1){
      homeController.refreshData();
      Get.offAll(()=>Main());
      App.succMsg(context ,"login", loginResult.message);
    }else if(loginResult.code==-10){
      Get.off(()=>VerificationCode());
      App.errMsg(context , "login",loginResult.message);
    }else{
      App.errMsg(context , "login",loginResult.message);
    }
    await Future.delayed(Duration(seconds: 1));
    loading.value = false;
  }

  googleSignIn(BuildContext context)async{
    GoogleSignIn googleSignIn = GoogleSignIn();
    var googleData = await googleSignIn.signIn();
    if(googleData != null){
      String email = googleData.email;
      String pass = generatePassword(googleData.email.split("@")[0]);
      loginWithVerify(context,googleData.displayName??"", email, pass);
    }else{
      App.errMsg(context, "login","wrong");
    }
  }

  // appleSignIn(BuildContext context)async{
  //   final credential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //   );
  //   if(credential.email != null){
  //     // AppStyle.successMsg(context, credential.email!);
  //     String email = credential.email!;
  //     String pass =  generatePassword(credential.email!.split("@")[0]);
  //     String name = "";
  //     if(credential.givenName !=null && credential.familyName !=null){
  //       name = credential.givenName! +" "+credential.familyName!;
  //     }
  //     signUpVerifyThenLogIn(context,name, email, pass,"");
  //   }else if(credential.identityToken != null){
  //     // AppStyle.successMsg(context, credential.identityToken!.substring(0,15));
  //     String email = credential.identityToken!.substring(0,15);
  //     String pass =  generatePassword(credential.identityToken!.substring(0,15));
  //     String name = "";
  //     if(credential.givenName !=null && credential.familyName !=null){
  //       name = credential.givenName! +" "+credential.familyName!;
  //     }
  //     signUpVerifyThenLogIn(context,name, email, pass,"");
  //   }else{
  //     AppStyle.errorMsg(context, "oops SomeThing Went Wrong");
  //   }
  // }

  generatePassword(String email) {
    String output = "";
    output = email.replaceAll("a", "m")
        .replaceAll("b", "i")
        .replaceAll("c", "d")
        .replaceAll("d", "g")
        .replaceAll("e", "h")
        .replaceAll("f", "w")
        .replaceAll("g", "r")
        .replaceAll("h", "j")
        .replaceAll("i", "q")
        .replaceAll("j", "p")
        .replaceAll("k", "z")
        .replaceAll("l", "s")
        .replaceAll("m", "t")
        .replaceAll("n", "y")
        .replaceAll("o", "j")
        .replaceAll("p", "s")
        .replaceAll("q", "b")
        .replaceAll("r", "c")
        .replaceAll("s", "k")
        .replaceAll("t", "e")
        .replaceAll("u", "l")
        .replaceAll("w", "a")
        .replaceAll("y", "b")
        .replaceAll("z", "m");
    return output;
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