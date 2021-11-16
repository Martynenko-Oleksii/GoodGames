import 'dart:convert';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goodgames/global.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class getDatahttp {
  static Future<User> postDateRegister(
      String name, String email, String pass) async {
    User? user;

    var body = jsonEncode({'login': name, 'email': email, 'password': pass});

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/users/reg"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        user = User(
            id: jsonData["id"],
            login: jsonData["login"],
            email: jsonData["email"],
            password: jsonData["password"],
            subscription: jsonData["subscription"],
            sports: jsonData["sports"]);
      }
    } catch (ex) {
      print(ex);
    }

    return user!;
  }

  static Future<User> postDateLogin(String email, String pass) async {
    User? user;

    var body = jsonEncode({'email': email, 'password': pass});

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/users/login"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonData["subscription"] == null) {
          user = User(
            id: jsonData["id"],
            login: jsonData["login"],
            email: jsonData["email"],
            password: jsonData["password"],
            subscription: jsonData["subscription"],
          );
        } else {
          user = User(
            id: jsonData["id"],
            login: jsonData["login"],
            email: jsonData["email"],
            password: jsonData["password"],
            subscription: Subscription(
              id: jsonData["subscription"]["id"],
              lvl: jsonData["subscription"]["level"],
              start: DateTime.parse(jsonData["subscription"]["start"]
                      .toString()
                      .substring(0, 10) +
                  " " +
                  jsonData["subscription"]["start"].toString().substring(11)),
              end: DateTime.parse(
                  jsonData["subscription"]["end"].toString().substring(0, 10) +
                      " " +
                      jsonData["subscription"]["end"].toString().substring(11)),
            ),
          );
        }

        if (jsonData["avatarPath"] != null) {
          user.avatarPath = jsonData["avatarPath"];
        }

        List<Sport> sports = [];
        for (var s in jsonData["sports"]) {
          Sport sport = Sport(
              id: s["id"],
              title: s["title"],
              minCompetitorsCount: s["minCompetitorsCount"],
              hasTeam: s["hasTeam"],
              minTeamsCount: s["minTeamsCount"],
              teamSize: s["teamSize"],
              hasGrid: s["hasGrid"]);
          sports.add(sport);
          user.sports = sports;
        }
      }
    } catch (ex) {
      print(ex);
    }

    return user!;
  }

  static Future<User> getUserData(int userId) async {
    User? user;

    try {
      var response = await http
          .get(Uri.https("goodgames.kh.ua", "api/users/$userId"), headers: {
        'Accept': 'application/json',
        'content-type': 'application/json'
      });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        user = User(
          id: jsonData["id"],
          login: jsonData["login"],
          email: jsonData["email"],
          password: jsonData["password"],
        );

        if (jsonData["avatarPath"] != null) {
          user.subscription = Subscription(
            id: jsonData["subscription"]["id"],
            lvl: jsonData["subscription"]["level"],
            start: DateTime.parse(
                jsonData["subscription"]["start"].toString().substring(0, 10) +
                    " " +
                    jsonData["subscription"]["start"].toString().substring(11)),
            end: DateTime.parse(
                jsonData["subscription"]["end"].toString().substring(0, 10) +
                    " " +
                    jsonData["subscription"]["end"].toString().substring(11)),
          );
        }

        if (jsonData["avatarPath"] != null) {
          user.avatarPath = jsonData["avatarPath"];
        }

        List<Sport> sports = [];
        for (var s in jsonData["sports"]) {
          Sport sport = Sport(
              id: s["id"],
              title: s["title"],
              minCompetitorsCount: s["minCompetitorsCount"],
              hasTeam: s["hasTeam"],
              minTeamsCount: s["minTeamsCount"],
              teamSize: s["teamSize"],
              hasGrid: s["hasGrid"]);
          sports.add(sport);
          user.sports = sports;
        }
      }
    } catch (ex) {
      print(ex);
    }

    return user!;
  }

  static Future<List<Sport>> getFavouriteSports(int userId) async {
    List<Sport> sports = [];

    try {
      var response = await http
          .get(Uri.https("goodgames.kh.ua", "api/sports/$userId"), headers: {
        'Accept': 'application/json',
        'content-type': 'application/json'
      });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var s in jsonData) {
          Sport sport = Sport(
              id: s["id"],
              title: s["title"],
              minCompetitorsCount: s["minCompetitorsCount"],
              hasTeam: s["hasTeam"],
              minTeamsCount: s["minTeamsCount"],
              teamSize: s["teamSize"],
              hasGrid: s["hasGrid"]);

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

  static Future<dynamic> getCompetitions(int userId) async {
    List<Competition> competitions = [];

    print(userId);

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/competitions/users/$userId"),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var s in jsonData) {
          Competition competition = Competition(id: s["id"], title: s["title"]);

          competitions.add(competition);
        }
      } else {
        print(response.body);
        return false;
      }
    } catch (ex) {
      print(ex);
    }

    return competitions;
  }

  static Future<Competition> getCompetition(int competitionId) async {
    Competition? competition;

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/competitions/$competitionId"),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        //print(jsonData[0]["competitors"]);

        competition = Competition(
            id: jsonData[0]["id"],
            title: jsonData[0]["title"],
            isOpen: jsonData[0]["isOpen"],
            sport: Sport(
                id: jsonData[0]["sport"]["id"],
                title: jsonData[0]["sport"]["title"],
                minCompetitorsCount: jsonData[0]["sport"]
                    ["minCompetitorsCount"],
                hasTeam: jsonData[0]["sport"]["hasTeam"],
                minTeamsCount: jsonData[0]["sport"]["minTeamsCount"],
                teamSize: jsonData[0]["sport"]["teamSize"],
                hasGrid: jsonData[0]["sport"]["hasGrid"]),
            ageLimit: jsonData[0]["ageLimit"],
            city: jsonData[0]["city"],
            startDate: DateTime.parse(
                jsonData[0]["startDate"].toString().substring(0, 10) +
                    " " +
                    jsonData[0]["startDate"].toString().substring(11)),
            endDate: DateTime.parse(
                jsonData[0]["endDate"].toString().substring(0, 10) +
                    " " +
                    jsonData[0]["endDate"].toString().substring(11)),
            isPublic: jsonData[0]["isPublic"],
            user: User(
                id: jsonData[0]["user"]["id"],
                login: jsonData[0]["user"]["login"]),
            streamUrl: jsonData[0]["streamUrl"],
            state: jsonData[0]["state"]);

        List<Competitor> competitors = [];
        for (var c in jsonData[0]["competitors"]) {
          competitors.add(Competitor(
              id: c["id"],
              name: c["name"],
              email: c["email"],
              age: c["age"],
              gender: c["gender"],
              weigth: c["weigth"],
              healthState: c["healthState"],
              team: c["team"]));
        }

        competition.competitors = competitors;
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    //print(competition);

    return competition!;
  }

  static Future<Competition> postNewCompetition(
      String title,
      bool isOpen,
      int sportId,
      String ageLimit,
      String city,
      DateTime startDate,
      DateTime endDate,
      bool isPublic,
      int userId) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    Competition? competition;

    var body = jsonEncode({
      'title': title,
      'isOpen': isOpen,
      'sport': {'id': sportId},
      'ageLimit': ageLimit,
      'city': city,
      'startDate': formatter.format(startDate),
      'endDate': formatter.format(endDate),
      'isPublic': isPublic,
      'user': {'id': userId}
    });

    print(body);

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/competitions/create"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        competition = Competition(id: jsonData["id"], title: jsonData["title"]);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    return competition!;
  }

  static Future<Competition> deleteCompetition(int competitionId) async {
    Competition? competition;

    try {
      var response = await http.get(
          Uri.https(
              "goodgames.kh.ua", "api/competitions/delete/$competitionId"),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        competition = Competition(id: jsonData['id']);
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    return competition!;
  }

  static Future<Competitor?> postNewCompetitor(
      String name,
      String email,
      int age,
      String gender,
      int weigth,
      String healthState,
      String team,
      int competitionId) async {
    Competitor? competitor;

    var body = jsonEncode({
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'weigth': weigth,
      'healthState': healthState,
      'team': team,
      'competitions': [
        {'id': competitionId}
      ]
    });

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/competitors"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });
      //print(response.body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        competitor = Competitor(id: jsonData["id"], name: jsonData["name"]);
      }
    } catch (ex) {
      print(ex);
    }
    // print("$name , $email,$age ,$gender ,$weigth , $healthState ,$team , $competitionId");
    // print(competitor);

    return competitor;
  }

  static Future<bool> postEmail(String email, int competitionId, int id) async {
    bool result = false;

    var body = jsonEncode({
      'competitionId': competitionId,
      'email': email,
      'userId': id,
    });

    try {
      var response = await http.post(Uri.https("goodgames.kh.ua", "api/post"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        result = true;
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }
    print(result);

    return result;
  }

  static Future<List<Sport>> getSports() async {
    List<Sport> sports = [];

    try {
      var response = await http.get(Uri.https("goodgames.kh.ua", "api/sports"),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var s in jsonData) {
          Sport sport = Sport(
              id: s["id"],
              title: s["title"],
              minCompetitorsCount: s["minCompetitorsCount"],
              hasTeam: s["hasTeam"],
              minTeamsCount: s["minTeamsCount"],
              teamSize: s["teamSize"],
              hasGrid: s["hasGrid"]);

          sports.add(sport);
        }
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    print(sports);

    return sports;
  }

  static Future<User?> subscribe(int id) async {
    User? subUser;

    try {
      var response = await http
          .get(Uri.https("goodgames.kh.ua", "api/subs/$id"), headers: {
        'Accept': 'application/json',
        'content-type': 'application/json'
      });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        subUser = User(
          subscription: Subscription(
            id: jsonData["subscription"]["id"],
            lvl: jsonData["subscription"]["level"],
            start: DateTime.parse(
                jsonData["subscription"]["start"].toString().substring(0, 10) +
                    " " +
                    jsonData["subscription"]["start"].toString().substring(11)),
            end: DateTime.parse(
                jsonData["subscription"]["end"].toString().substring(0, 10) +
                    " " +
                    jsonData["subscription"]["end"].toString().substring(11)),
          ),
        );
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    return subUser;
  }

  static Future<List<TimetableCell>> getTimetable(int competitionId) async {
    List<TimetableCell> cells = [];

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/timetables/$competitionId"),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var s in jsonData) {
          // print(s);
          TimetableCell cell = TimetableCell(
            id: s["id"],
            dateTime: DateTime.parse(s["dateTime"].toString().substring(0, 10) +
                " " +
                s["dateTime"].toString().substring(11)),
            gridStage: s["gridStage"],
          );

          List<Competitor> cellCompetitors = [];
          for (var c in s["competitors"]) {
            cellCompetitors.add(Competitor(
                id: c["id"],
                name: c["name"],
                email: c["email"],
                age: c["age"],
                gender: c["gender"],
                weigth: c["weigth"],
                healthState: c["healthState"],
                team: c["team"]));
          }
          cell.competitors = cellCompetitors;

          if (s["winResult"] != null) {
            cell.winResult = WinResult(
                id: s["winResult"]["id"],
                teamOne: s["winResult"]["teamOne"],
                teamTwo: s["winResult"]["teamTwo"],
                score: s["winResult"]["score"]);
          }

          cells.add(cell);
        }
      } else {
        //  print(response.body);
      }
    } catch (ex) {
      print(ex);
    }
    //print(cells);

    return cells;
  }

  static Future<bool> generateSchedule(
      int competitionId, String start, String end) async {
    bool result = false;

    var body = jsonEncode({'id': competitionId, 'start': start, 'end': end});

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/timetables/create"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        result = true;
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    print(result);

    return result;
  }

  static Future<User> changeLogin(User u) async {
    User? user;

    var body = jsonEncode({'id': u.id, 'login': u.login});

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/users/change/login"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        user = User(
            id: jsonData["id"],
            login: jsonData["login"],
            email: jsonData["email"]);
      }
    } catch (ex) {
      print(ex);
    }

    return user!;
  }

  static Future<User> changeEmail(User u) async {
    User? user;

    var body = jsonEncode({'id': u.id, 'email': u.email});

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/users/change/email"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        user = User(
            id: jsonData["id"],
            login: jsonData["login"],
            email: jsonData["email"]);
      }
    } catch (ex) {
      print(ex);
    }

    return user!;
  }

  static Future<User> changePassword(User u) async {
    User? user;

    var body = jsonEncode({'id': u.id, 'password': u.password});

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/users/change/password"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        user = User(
            id: jsonData["id"],
            login: jsonData["login"],
            email: jsonData["email"],
            password: jsonData["password"]);
      }
    } catch (ex) {
      print(ex);
    }

    return user!;
  }

  // generate token to change forgotten password
  static Future<bool> generateToken(String email) async {
    bool result = false;

    var body = jsonEncode({'email': email});

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/users/token"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        result = true;
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    print(result);

    return result;
  }

  static Future<User> changeForgottenPassword(
      String token, String email, String newPassword) async {
    User? user;

    var body = jsonEncode(
        {'token': token, 'email': email, 'newPassword': newPassword});

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/users/change/forgotten"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        user = User(
            id: jsonData["id"],
            login: jsonData["login"],
            email: jsonData["email"],
            password: jsonData["password"]);
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    return user!;
  }

  static Future<bool> postResults(int timetableCellId, String teamOne,
      String teamTwo, String teamOneResult, String teamTwoResult) async {
    bool result = false;

    var body = jsonEncode({
      'id': timetableCellId,
      'teamOne': teamOne,
      'teamTwo': teamTwo,
      'score': "$teamOneResult,$teamTwoResult"
    });

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/results"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        result = true;
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    return result;
  }

  static Future<List<Competition>> getAllCompetitions() async {
    List<Competition> competitions = [];

    try {
      var response = await http
          .get(Uri.https("goodgames.kh.ua", "api/competitions"), headers: {
        'Accept': 'application/json',
        'content-type': 'application/json'
      });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var c in jsonData) {
          Competition competition = Competition(
              id: c["id"],
              title: c["title"],
              sport: Sport(
                  id: c["sport"]["id"],
                  title: c["sport"]["title"],
                  minCompetitorsCount: c["sport"]["minCompetitorsCount"],
                  hasTeam: c["sport"]["hasTeam"],
                  minTeamsCount: c["sport"]["minTeamsCount"],
                  teamSize: c["sport"]["teamSize"],
                  hasGrid: c["sport"]["hasGrid"]),
              startDate: DateTime.parse(
                  c["startDate"].toString().substring(0, 10) +
                      " " +
                      c["startDate"].toString().substring(11)),
              endDate: DateTime.parse(c["endDate"].toString().substring(0, 10) +
                  " " +
                  c["endDate"].toString().substring(11)),
              state: c["state"]);

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

  static Future<List<Competition>> getFavouriteCompetitions(int userId) async {
    List<Competition> competitions = [];

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/competitions/favourites/$userId"),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var c in jsonData) {
          Competition competition = Competition(
              id: c["id"],
              title: c["title"],
              sport: Sport(
                  id: c["sport"]["id"],
                  title: c["sport"]["title"],
                  minCompetitorsCount: c["sport"]["minCompetitorsCount"],
                  hasTeam: c["sport"]["hasTeam"],
                  minTeamsCount: c["sport"]["minTeamsCount"],
                  teamSize: c["sport"]["teamSize"],
                  hasGrid: c["sport"]["hasGrid"]),
              startDate: DateTime.parse(
                  c["startDate"].toString().substring(0, 10) +
                      " " +
                      c["startDate"].toString().substring(11)),
              endDate: DateTime.parse(c["endDate"].toString().substring(0, 10) +
                  " " +
                  c["endDate"].toString().substring(11)),
              state: c["state"]);

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

  static Future<dynamic> addFavouriteSport(int userId, int sportId) async {
    List<Sport> sports = [];

    var body = jsonEncode({'id': sportId});

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/addsport/$userId"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var s in jsonData) {
          Sport sport = Sport(
              id: s["id"],
              title: s["title"],
              minCompetitorsCount: s["minCompetitorsCount"],
              hasTeam: s["hasTeam"],
              minTeamsCount: s["minTeamsCount"],
              teamSize: s["teamSize"],
              hasGrid: s["hasGrid"]);

          sports.add(sport);
        }
      } else {
        print(response.body);
        return false;
      }
    } catch (ex) {
      print(ex);
    }

    return sports;
  }

  static Future<List<Sport>> deleteFavouriteSport(
      int userId, int sportId) async {
    List<Sport> sports = [];

    var body = jsonEncode({'id': sportId});

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/deletesport/$userId"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var s in jsonData) {
          Sport sport = Sport(
              id: s["id"],
              title: s["title"],
              minCompetitorsCount: s["minCompetitorsCount"],
              hasTeam: s["hasTeam"],
              minTeamsCount: s["minTeamsCount"],
              teamSize: s["teamSize"],
              hasGrid: s["hasGrid"]);

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

  static Future<List<User>> addAdmin(int competitionId, String email) async {
    List<User> users = [];

    var body = jsonEncode({'email': email});

    try {
      var response = await http.post(
          Uri.https(
              "goodgames.kh.ua", "api/competitions/addadmin/$competitionId"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var s in jsonData) {
          User user = User(id: s["id"], login: s["login"]);

          users.add(user);
        }
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    return users;
  }

  static Future<List<User>> deleteAdmin(
      int competitionId, String userId) async {
    List<User> users = [];

    var body = jsonEncode({'id': userId});

    try {
      var response = await http.post(
          Uri.https(
              "goodgames.kh.ua", "api/competitions/deleteadmin/$competitionId"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var s in jsonData) {
          User user = User(id: s["id"], login: s["login"]);

          users.add(user);
        }
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    return users;
  }

  static Future<List<User>> getAllAdmins(int competitionId) async {
    List<User> users = [];

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/admins/$competitionId"),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var s in jsonData) {
          User user = User(id: s["id"], login: s["login"]);

          users.add(user);
        }
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    return users;
  }

  static Future<Competition> addStreamUrl(
      int competitionId, String streamUrl) async {
    Competition? competition;

    var body = jsonEncode({'id': competitionId, 'streamUrl': streamUrl});

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/competitions/addstream"),
          body: body,
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        competition =
            Competition(id: jsonData["id"], streamUrl: jsonData["streamUrl"]);
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    return competition!;
  }

  static Future<dynamic> UploadImg(File photoFile, int userId) async {
    var dio = new Dio();
    String fileName = photoFile.path.split('/').last;
    var formData = FormData.fromMap({'image': await MultipartFile.fromFile(photoFile.path, filename:fileName),});
    try {
      //404
      var response = await dio.post(
          "https://www.goodgames.kh.ua/api/users/change/image/$userId",
          data: formData,
          options: Options(
              method: 'POST',
             // responseType: ResponseType.json,
            contentType: 'STREAM',
              ));
      print(response);

      if (response.statusCode == 200)
        return response;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
        print(e.message);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }

    return false;
  }

  static DelImg(int userId) async {

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/users/change/deleteimage/$userId"),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json'
          });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

  }
}
