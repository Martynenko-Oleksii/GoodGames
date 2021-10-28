import 'package:flutter/cupertino.dart';

class User {
  int? id;
  String? login;
  String? email;
  String? password;
  Subscription? subscription;
  List<Sport>? sports;

 User({
        this.id,
        this.login,
        this.email,
        this.password,
        this.subscription,
        this.sports
      });

 @override
  String toString() {
    return "id:$id, login:$login, password:$password";
  }
}

class Sport {
  final int id;
  final String title;
  final int minCompetitorsCount;
  final bool hasTeam;
  final int minTeamsCount;
  final int teamSize;
  final bool hasGrid;

  Sport(
        {
          required this.id,
          required this.title,
          required this.minCompetitorsCount,
          required this.hasTeam,
          required this.minTeamsCount,
          required this.teamSize,
          required this.hasGrid,
        });

  @override
  String toString() {
    return "id:$id, title:$title, minCompetitorsCount:$minCompetitorsCount, "
        "hasTeam:$hasTeam, minTeamsCount:$minTeamsCount,"
        "teamSize:$teamSize, hasGrid:$hasGrid";
  }
}

class Competition {
  int? id;
  String? title;
  bool? isOpen;
  Sport? sport;
  String? ageLimit;
  String? city;
  DateTime? startDate;
  DateTime? endDate;
  bool? isPublic;
  List<Competitor>? competitors;
  User? user;
  String? streamUrl;
  String? state;

  Competition({
    this.id,
    this.title,
    this.isOpen,
    this.sport,
    this.ageLimit,
    this.city,
    this.startDate,
    this.endDate,
    this.isPublic,
    this.competitors,
    this.user,
    this.streamUrl,
    this.state,
  });

  @override
  String toString() {
    return "id:$id, title:$title, isOpen:$isOpen, competitors:$competitors[0]";
  }
}

class Competitor {
  int? id;
  String? name;
  String? email;
  int? age;
  String? gender;
  int? weigth;
  String? healthState;
  String? team;

  Competitor({
    this.id,
    this.name,
    this.email,
    this.age,
    this.gender,
    this.weigth,
    this.healthState,
    this.team
  });

  @override
  String toString() {
    return "id:$id, name:$name";
  }
}

class Subscription {
  int? id;
  int? lvl;
  DateTime? start;
  DateTime? end;

  Subscription({
    this.id,
    this.lvl,
    this.start,
    this.end,
  });

  @override
  String toString() {
    return "id:$id, name:$lvl";
  }
}