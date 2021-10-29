import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:goodgames/global.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
              subscription:  jsonData["subscription"],
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
        if(jsonData["subscription"] == null){
          user = User(
              id: jsonData["id"],
              login: jsonData["login"],
              email: jsonData["email"],
              password: jsonData["password"],
              subscription:  jsonData["subscription"],
              sports: jsonData["sports"]
          );
        }else{
          user = User(
              id: jsonData["id"],
              login: jsonData["login"],
              email: jsonData["email"],
              password: jsonData["password"],
              subscription:  Subscription(
                id: jsonData["subscription"]["id"],
                lvl: jsonData["subscription"]["level"],
                start: DateTime.parse(
                    jsonData["subscription"]["start"]
                        .toString()
                        .substring(0, 10) + " " +
                        jsonData["subscription"]["start"]
                            .toString()
                            .substring(11)),
                end: DateTime.parse(
                    jsonData["subscription"]["end"]
                        .toString()
                        .substring(0, 10) + " " +
                        jsonData["subscription"]["end"]
                            .toString()
                            .substring(11)),
              ),
              sports: jsonData["sports"]
          );
        }
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
              minCompetitorsCount: s["minCompetitorsCount"],
              hasTeam: s["hasTeam"],
              minTeamsCount: s["minTeamsCount"],
              teamSize: s["teamSize"],
              hasGrid: s["hasGrid"]
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

    print(userId);

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

  static Future<Competition> getCompetition(int competitionId) async{
    Competition? competition;

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/competitions/$competitionId"),
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

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
              minCompetitorsCount: jsonData[0]["sport"]["minCompetitorsCount"],
              hasTeam: jsonData[0]["sport"]["hasTeam"],
              minTeamsCount: jsonData[0]["sport"]["minTeamsCount"],
              teamSize: jsonData[0]["sport"]["teamSize"],
              hasGrid: jsonData[0]["sport"]["hasGrid"]
          ),
            ageLimit: jsonData[0]["ageLimit"],
            city: jsonData[0]["city"],
            startDate: DateTime.parse(
                jsonData[0]["startDate"]
                    .toString()
                    .substring(0, 10) + " " +
                    jsonData[0]["startDate"]
                        .toString()
                        .substring(11)),
            endDate: DateTime.parse(
                jsonData[0]["endDate"]
                    .toString()
                    .substring(0, 10) + " " +
                    jsonData[0]["endDate"]
                        .toString()
                        .substring(11)),
            isPublic: jsonData[0]["isPublic"],
            user: User(
                id: jsonData[0]["user"]["id"],
                login: jsonData[0]["user"]["login"]
            ),
            streamUrl: jsonData[0]["streamUrl"],
            state: jsonData[0]["state"]
        );

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
              team: c["team"]
          ));
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

  //TODO TESTS!!!

  static Future<Competition> postNewCompetition(
      String title, bool isOpen, int sportId,
      String ageLimit, String city,
      DateTime startDate, DateTime endDate,
      bool isPublic, int userId) async {

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    Competition? competition;

    var body = jsonEncode( {
      'title': title,
      'isOpen': isOpen,
      'sport': {
        'id': sportId
      },
      'ageLimit': ageLimit,
      'city': city,
      'startDate': formatter.format(startDate),
      'endDate': formatter.format(endDate),
      'isPublic': isPublic,
      'user': {
        'id': userId
      }
    });

    print(body);

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/competitions/create"),
          body: body,
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        competition = Competition(
          id: jsonData["id"],
          title: jsonData["title"]
        );
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch(ex) {
      print(ex);
    }

    return competition!;
  }

  static Future<Competition> deleteCompetition(int competitionId) async{
    Competition? competition;

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/competitions/delete/$competitionId"),
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

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

  static Future<Competitor> postNewCompetitor(
      String name, String email, int age,
      String gender, int weigth,
      String healthState, String team) async {

    Competitor? competitor;

    var body = jsonEncode( {
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'weigth': weigth,
      'healthState': healthState,
      'team': team
    });

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/competitors"),
          body: body,
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        competitor = Competitor(
            id: jsonData["id"],
            name: jsonData["name"]
        );
      }
    } catch(ex) {
      print(ex);
    }

    return competitor!;
  }

  //TODO
  static Future<bool> postEmail(String email , int competitionId , int id) async{

    bool result = false;

    var body = jsonEncode({
      'competitionId' : competitionId,
      'email': email,
      'userId' : id,
    });

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/mails"),
          body: body,
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

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

  static Future<List<Sport>> getSports() async{
    List<Sport> sports = [];

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/sports"),
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

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
              hasGrid: s["hasGrid"]
          );

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

  //TODO
  static Future<bool> subscribe(int id) async{

    bool result = false;

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/subs/$id"),
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

      if (response.statusCode == 200) {
print(id);
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

  static Future<List<TimetableCell>> getTimetable(int competitionId) async{
    List<TimetableCell> cells = [];

    try {
      var response = await http.get(
          Uri.https("goodgames.kh.ua", "api/sports/$competitionId"),
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var s in jsonData) {
          TimetableCell cell = TimetableCell(
            id: s[0]["id"],
            dateTime: DateTime.parse(
                s[0]["dateTime"]
                    .toString()
                    .substring(0, 10) + " " +
                    s[0]["dateTime"]
                        .toString()
                        .substring(11)),
            competition: Competition(
              id: s[0]["competition"]["id"],
              title: s[0]["competition"]["title"],
            ),
            gridStage: s[0]["gridStage"],
          );

          List<Competitor> cellCompetitors = [];
          for (var c in s[0]["competitors"])
          {
            cellCompetitors.add(Competitor(
                id: c["id"],
                name: c["name"],
                email: c["email"],
                age: c["age"],
                gender: c["gender"],
                weigth: c["weigth"],
                healthState: c["healthState"],
                team: c["team"]
            ));
          }
          cell.competitors = cellCompetitors;

          if (s[0]["winResult"] != null)
          {
            cell.winResult = WinResult(
                id: s[0]["winResult"]["id"],
                score: s[0]["winResult"]["score"]
            );

            List<Competitor> winCompetitors = [];
            for (var c in s[0]["winResult"]["competitors"])
            {
              winCompetitors.add(Competitor(
                  id: c["id"],
                  name: c["name"],
                  email: c["email"],
                  age: c["age"],
                  gender: c["gender"],
                  weigth: c["weigth"],
                  healthState: c["healthState"],
                  team: c["team"]
              ));
            }
            cell.winResult?.competitors = winCompetitors;
          }

          cells.add(cell);
        }
      } else {
        print(response.body);
      }
    } catch (ex) {
      print(ex);
    }

    print(cells);

    return cells;
  }

  static Future<bool> generateSchedule(int competitionId, DateTime start, DateTime end) async {
    bool result = false;

    var body = jsonEncode({
      'id': competitionId,
      'start': start,
      'end': end
    });

    try {
      var response = await http.post(
          Uri.https("goodgames.kh.ua", "api/timetables/create"),
          body: body,
          headers: {'Accept' : 'application/json' , 'content-type' : 'application/json'}
      );

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
}


