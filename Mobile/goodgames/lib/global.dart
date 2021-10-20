import 'package:flutter/cupertino.dart';

class User {
 User(
      {
        required this.id,
        required this.login,
        required this.email,
        required this.password,
        required this.subscription,
        required this.sports
      });

  final String id;
  final String login;
  final String email;
  final String password;
  final String subscription;
  final String sports;

}