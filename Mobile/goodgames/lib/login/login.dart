import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/regist.dart';
import 'package:goodgames/profile/ProfileScreen.dart';

import '../../../home_screen.dart';
import '../../../main.dart';
import '../../../getdata.dart';

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
        appBar: new AppBar(
          backgroundColor: Colors.orange.shade200,
          centerTitle: true,
          elevation: 0.0,
          title: new Text(
            "Welcome",
            textScaleFactor: 1.3,
          ),
        ),
        body: Center(
            child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [
              0.1,
              0.3,
              0.8,
              0.9,
            ],
            colors: [
              Colors.orange.shade200,
              Colors.purple.shade100,
              Colors.indigo.shade200,
              Colors.lightBlue.shade200,
            ],
          )),
          child: new Stack(
            children: <Widget>[
              new Container(
                alignment: Alignment(0.00, -0.50),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      height: 300.0,
                      width: 400.0,
                      alignment: Alignment(0.00, -0.50),
                      /*



                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 5,
                        )
                    ),
                      */
                      child: Form(
                        key: formKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: new Container(
                                width: 275.0,
                                child: new TextFormField(
                                  controller: loginControl,
                                  decoration: new InputDecoration(
                                    hintText: 'Email',
                                    filled: true,
                                    fillColor: Colors.white70,
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
                                    hintText: 'Password',
                                    filled: true,
                                    fillColor: Colors.white70,
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
                              //margin: const EdgeInsets.only( bottom: 150.0),
                              child: new Row(
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                //mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: <Widget>[
                                  new Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 0.0),
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: new RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      child: new Text("Forgot Password"),
                                      onPressed: onPressed,
                                    ),
                                  ),
                                  new Container(
                                    margin: const EdgeInsets.only(bottom: 7.0),
                                    padding:
                                        EdgeInsets.only(right: 20.0),
                                    width: 140.0,
                                    height: 35.0,
                                    child: new RaisedButton(
                                      child: new Text("Login"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          getDatahttp.postDateLogin(
                                            loginControl.text,
                                            passControl.text)
                                              .then((value) =>
                                              Navigator.push<dynamic>(
                                                context,
                                                MaterialPageRoute<dynamic>(
                                                  builder: (BuildContext context) =>
                                                      ProfileScreen(user: value),
                                                ),
                                              ));
                                        }

                                        //getDatahttp.getCompetition(1);
                                      },
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Container(
                      //margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: new RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: new Text("Register"),
                        onPressed: () {
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => RegistPage(),
                            ),
                          );
                        },
                        color: Colors.redAccent.shade200,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }

  void onPressed() {}

  @override
  void dispose() {
    super.dispose();
  }
}
