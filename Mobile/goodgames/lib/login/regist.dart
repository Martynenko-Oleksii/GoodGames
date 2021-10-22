import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/getdata.dart';
import 'package:goodgames/profile/ProfileScreen.dart';


import '../../../home_screen.dart';
import '../../../main.dart';

class RegistPage extends StatefulWidget {
  @override
  _RegistState createState() => _RegistState();
}

class _RegistState extends State<RegistPage> {
  final TextEditingController nameControl = TextEditingController();
  final TextEditingController loginControl = TextEditingController();
  final TextEditingController passControl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          /* flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
                0.2,
                0.6,
                0.9,
              ],
              colors: [
                Colors.orange.shade200,
                Colors.purple.shade100,
                Colors.indigo.shade200,
              ],
            )
        ),
        ),*/
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
                      height: 400.0,
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
                                  controller: nameControl,
                                  decoration: new InputDecoration(
                                    labelText: 'Username',
                                    filled: true,
                                    fillColor: Colors.white70,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !RegExp(r'^[a-z A-Z]+$')
                                            .hasMatch(value)) {
                                      //allow upper and lower case alphabets and space
                                      return "Enter Correct Username";
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
                                  keyboardType: TextInputType.emailAddress,
                                  controller: loginControl,
                                  decoration: new InputDecoration(
                                    labelText: 'Email',
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
                                  keyboardType: TextInputType.phone,
                                  controller: passControl,
                                  obscureText: true,
                                  decoration: new InputDecoration(
                                    labelText: 'Password',
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
                            new RaisedButton(
                              child: new Text("Create account"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  //check if form data are valid,
                                  // your process task ahed if all data are valid
                                  getDatahttp.postDateRegister(
                                            nameControl.text,
                                            loginControl.text,
                                            passControl.text);

                                      Navigator.push<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) =>
                                              ProfileScreen(),
                                        ),
                                      );
                                  print(1);
                                }
                              },
                              color: Colors.orange,
                            ),
                          ],
                        ),
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
