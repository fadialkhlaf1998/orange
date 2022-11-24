import 'package:shared_preferences/shared_preferences.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/model/login_info.dart';

class Store {

  static Future<String> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Global.locale = prefs.getString("language")??"en";
    return Global.locale;
  }

  static Future saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("language",language);
    Global.locale = language;
  }

  static Future<LoginInfo?> loadLoginInfo()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.getString("login_info")??"none";
    if(str == "none"){
      Global.loginInfo = null;
    }else {
      Global.loginInfo = LoginInfo.fromJson(str);
    }
    return Global.loginInfo;
  }

  static saveLoginInfo(String email,String password)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LoginInfo loginInfo = LoginInfo(email: email, password: password);
    Global.loginInfo = loginInfo;
    prefs.setString("login_info", loginInfo.toJson());
  }

  static logout()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("login_info");
    Global.customer = null;
    Global.loginInfo = null;
  }

}
