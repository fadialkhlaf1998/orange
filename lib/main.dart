import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/store.dart';
import 'package:orange/view/intro.dart';
import 'package:orange/view/no_internet.dart';
import 'package:orange/view/pdf_viewer.dart';

void main() {
  runApp(MyApp());
}
//FROM FADI ALKHLAF 24/11/2022
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  static void set_locale(BuildContext context , Locale locale){
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.set_locale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale? _locale;
  void set_locale(Locale locale){
    setState(() {
      _locale=locale;
    });
  }

  @override
  void initState(){
    super.initState();
    Store.loadLanguage().then((language) {
      setState(() {
        _locale= Locale(language);
        Get.updateLocale(Locale(language));
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
        title: 'Syria Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: App.primary,
            primarySwatch: generateMaterialColor(App.primary),
            fontFamily: "NunitoSans",
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        locale: _locale,
        supportedLocales: [Locale('en', ''), Locale('ar', '')],
        localizationsDelegates: [
          App_Localization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (local, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == local!.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: Intro()
        // home: MyPDFViewer("https://www.ece.uvic.ca/~itraore/elec567-13/notes/dist-03-4.pdf")
    );
  }

  MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);

  int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));


}
