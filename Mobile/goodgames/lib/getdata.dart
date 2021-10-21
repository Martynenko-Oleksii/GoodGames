import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:goodgames/global.dart';
import 'package:http/http.dart' as http;

class getDatahttp {
  static Future<User> postDateRegister(String name ,String email ,String pass) async {
    User? user;

    var body = jsonEncode( {
      'login': name,
      'email': email,
      'password': pass
    });

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/users/reg"),
          body: body,
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        user = User(
            id: jsonData["id"],
            login: jsonData["login"],
            email: jsonData["email"],
            password: jsonData["password"],
            subscription: jsonData["subscription"],
            sports: jsonData["sports"]
        );
      }
    } catch(ex) {
      print(ex);
    }

    return user!;
  }

  static Future<User> postDateLogin(String email ,String pass) async {
    User? user;

    var body = jsonEncode( {
      'email': email,
      'password': pass
    });

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/users/login"),
          body: body,
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        user = User(
            id: jsonData["id"],
            login: jsonData["login"],
            email: jsonData["email"],
            password: jsonData["password"],
            subscription: jsonData["subscription"],
            sports: jsonData["sports"]
        );
      }
    } catch(ex) {
      print(ex);
    }

    return user!;
  }

  static Future<List<Sport>> getFavouriteSports(int userId) async{
    List<Sport> sports = [];

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/sports/$userId"),
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var s in jsonData) {
          Sport sport = Sport(
              id: s["id"],
              title: s["title"],
              hasTeam: s["hasTeam"],
              hasGrid: s["hasGrid"],
              competitorsLimit: s["competitorsLimit"],
              hasTeamLimit: s["hasTeamLimit"],
              teamLimit: s["teamLimit"]
          );

          sports.add(sport);
        }
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    return sports;
  }

  static Future<List<Competition>> getCompetitions(int userId) async{
    List<Competition> competitions = [];

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/competitions/users/$userId"),
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var s in jsonData) {
          Competition competition = Competition(
              id: s["id"],
              title: s["title"]
          );

          competitions.add(competition);
        }
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    return competitions;
  }
}


