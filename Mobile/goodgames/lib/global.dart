import 'package:flutter/cupertino.dart';

class User {
  int? id;
  String? login;
  String? email;
  String? password;
  String? subscription;
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
  Sport(
        {
          required this.id,
          required this.title,
          required this.hasTeam,
          required this.hasGrid,
          required this.competitorsLimit,
          required this.hasTeamLimit,
          required this.teamLimit,
        });

  final int id;
  final String title;
  final bool hasTeam;
  final bool hasGrid;
  final int competitorsLimit;
  final bool hasTeamLimit;
  final int teamLimit;
}