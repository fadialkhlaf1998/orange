import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/firebase_options.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/helper/store.dart';
import 'package:orange/view/intro.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:  'This channel is used for important notifications.', // description
  importance: Importance.max,
);
///final from Fadi Alkhlaf
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackhroundHadler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackhroundHadler);
  // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    sound: true,
    alert: true,
    badge: true,
  );

  runApp(MyApp());
}

//FROM FADI ALKHLAF 24/11/2022  "com.maxart.orange"
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
      FirebaseMessaging.instance.getToken().then((value) {
        print('Token Here');
        print(value);
        setState(() {
          if(value!=null){
            Global.token = value;
          }
        });
      });
      // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
      FirebaseMessaging.onMessage.listen((RemoteMessage message){

        RemoteNotification notification = message.notification!;
        AndroidNotification androd = message.notification!.android!;


        if(notification != null && androd !=null){
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    channelDescription: channel.description,
                    playSound: true,
                    icon: "@mipmap/ic_launcher"
                )
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
        title: 'Syria Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          sliderTheme: SliderThemeData(
            // showValueIndicator: ShowValueIndicator.always,
            valueIndicatorColor: Colors.transparent,
          ),
            primaryColor: App.primary,
            primarySwatch: generateMaterialColor(App.primary),
            fontFamily: "Poppins",
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
