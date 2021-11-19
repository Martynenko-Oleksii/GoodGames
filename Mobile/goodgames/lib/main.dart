import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:goodgames/getdata.dart';
import 'package:goodgames/profile/ProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'apptheme.dart';
import 'competitions/competitions_list_page.dart';
import 'global.dart';
import 'login/login.dart';
import 'login/regist.dart';


void main() async {

  runApp(MyAppprofl());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'GoodGames',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      home: LoginPage(),
      //home: RegistPage(),
    );
  }
}
class MyAppprofl extends StatelessWidget {

  Future<User> futget() async {
    String email = "";
    String pass = "";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email_Key') ?? "";
    pass = prefs.getString('pass_Key') ?? "";
    if(email != "" && pass!=""){
      return getDatahttp.postDateLogin(email, pass);
    }else{
      return new User(id: 0);
  }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futget(),
    builder: (context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      if(snapshot.data.id == 0){
        return MaterialApp(
          title: 'GoodGames',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: AppTheme.textTheme,
            platform: TargetPlatform.iOS,
          ),
          home: LoginPage(),
          //home: RegistPage(),
        );
      }else{
        return MaterialApp(
          title: 'GoodGames',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: AppTheme.textTheme,
            platform: TargetPlatform.iOS,
          ),
          home: ProfileScreen(user: snapshot.data),
          //home: RegistPage(),
        );
      }

    }else{
      return Container();
    }
        }
        );

  }
}


class MyAppprof extends StatelessWidget {
  User user;

  MyAppprof({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'GoodGames',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      home: ProfileScreen(user: user),
      //home: RegistPage(),
    );
  }
}


class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}