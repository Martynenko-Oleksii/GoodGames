import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:goodgames/global.dart';
import 'package:http/http.dart' as http;

class getDatahttp{



  static Future<User> postDateRegister(String name ,String email ,String pass) async {
    User user = [] as User;
    var body = jsonEncode( {
      'login': name,
      'email': email,
      'password': pass
    });
    try{
    var response = await http.post(Uri.
    //parse("https://www.goodgames.kh.ua/api/users/reg")
        https("goodgames.kh.ua", "api/users/reg"),
        body: body,
      headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
    );
    var jsondata = jsonDecode(utf8.decode(response.bodyBytes));
    for(var u in jsondata){
      User eser = User(
          id: u["id"],
          login: u["login"],
          email: u["email"],
          password: u["password"],
          subscription:u["subscription"],
          sports:u["sports"]
      );
      user = eser;
    }
  //  print(response.request);
  //  print(response.body);
    }catch(e){
      print(e);
    }
    
    return user;
  }

  static Future<User> postDateLogin(String email ,String pass) async {
    User user = [] as User;
    var body = jsonEncode( {
      'email': email,
      'password': pass
    });
    try{
      var response = await http.post(Uri.
      //parse("https://www.goodgames.kh.ua/api/users/reg")
      https("goodgames.kh.ua", "api/users/login"),
          body: body,
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );
      var jsondata = jsonDecode(utf8.decode(response.bodyBytes));
      for(var u in jsondata){
        User eser = User(
            id: u["id"],
            login: u["login"],
            email: u["email"],
            password: u["password"],
            subscription:u["subscription"],
            sports:u["sports"]
        );
        user = eser;
      }
      //  print(response.request);
      //  print(response.body);
    }catch(e){
      print(e);
    }
    return user;
  }


}
