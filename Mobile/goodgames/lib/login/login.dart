import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/regist.dart';
import 'package:goodgames/profile/ProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../main.dart';
import '../../../getdata.dart';
import '../apptheme.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final TextEditingController loginControl = TextEditingController();
  final TextEditingController passControl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Stack(
            children: <Widget>[
              new Container(
                child: new Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [
                          0,
                          0.5,
                          1,
                        ],
                        colors: [
                          Colors.red.shade100,
                          Colors.red.shade400,
                          Colors.pinkAccent.shade700,
                        ],
                      )),
                  child: Form(
                    key: formKey,
                    child: new Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 50.0, bottom: 10),
                          child: new Image.network(
                            "https://cdn.discordapp.com/attachments/839078982598131712/905486145171886150/8bf870ad-b849-4c4e-b2dc-67925f5cc3e0.jpg",
                            //encikllListd[index].imagePath,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10),
                          child: new Text(
                            "GoodGames",
                            style: AppTheme.display1,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: new Text(
                            "вітає вас!",
                            style: AppTheme.headline,
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: new Container(
                            width: 275.0,
                            child: new TextFormField(
                              controller: loginControl,
                              decoration: new InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Email',
                                suffixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                        .hasMatch(value)) {
                                  return "Enter Correct Email Address";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: new Container(
                            width: 275.0,
                            child: new TextFormField(
                              controller: passControl,
                              obscureText: true,
                              decoration: new InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                suffixIcon: Icon(Icons.lock_outline),
                                hintText: 'Password',
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'^[a-zA-Z0-9]+$')
                                        .hasMatch(value)) {
                                  //  r'^[0-9]{10}$' pattern plain match number with length 10
                                  return "Enter Correct Password";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        new Container(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height / 4 -
                        40,
                    left: MediaQuery.of(context).size.width / 2 - 140),
                width: 280.0,
                height: 70.0,
                child: new RaisedButton(
                  child: new Text(
                    "Вхід",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      letterSpacing: 0.4,
                      height: 0.9,
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white, width: 3)),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      getDatahttp
                          .postDateLogin(loginControl.text, passControl.text)
                          .then((value) => {
                        prefs.setString('email_Key',value.email ?? ""),
                        prefs.setString('pass_Key',value.password ?? ""),
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfileScreen(user: value),
                              ),
                              (route) => false)});
                    }
                  },
                  color: Colors.black.withOpacity(0.05),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height / 5,
                    left: MediaQuery.of(context).size.width / 2 - 140),
                width: 280.0,
                height: 70.0,
                child: new Column(
                  children: <Widget>[
                    Text(
                      "Немае акаунту?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      onPressed: () {
                        Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => RegistPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Cтворіть його зараз!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),),
    );
  }

  void onPressed() {}

  @override
  void dispose() {
    super.dispose();
  }
}
