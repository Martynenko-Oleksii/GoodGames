import 'package:goodgames/competitions/competitions_list_page.dart';
import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/login.dart';
import 'package:goodgames/login/regist.dart';
import 'package:goodgames/profile/ProfileScreen.dart';

import '../../../home_screen.dart';
import '../../../main.dart';
import '../../../getdata.dart';
import '../apptheme.dart';

class ProfileeditPage extends StatefulWidget {
  @override
  final User user;

  ProfileeditPage({Key? key, required this.user}) : super(key: key);

  _ProfileeditState createState() => _ProfileeditState();
}

class _ProfileeditState extends State<ProfileeditPage> {
  final TextEditingController emailControl = TextEditingController();
  final TextEditingController nameControl = TextEditingController();
  final TextEditingController oldpassControl = TextEditingController();
  final TextEditingController newpassControl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final formKeylog = GlobalKey<FormState>();
  final formKeyemail = GlobalKey<FormState>();
  final formKeypass = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
      child: new Stack(
        children: <Widget>[
          new Container(
            // alignment: Alignment(0.00, -0.50),
            child: new ListView(
              // TODO Column or ListView or ... ??????

              //crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    //  color: Colors.black54,
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.black, width: 3)),
                    // margin: EdgeInsets.only(right: 15 , left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Редагування профілю",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.4,
                            height: 0.9,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: IconButton(
                            iconSize: 20,
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      ProfileScreen(user: widget.user),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )),
                new Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10),
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.height - 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.only(left: 10.0, top: 10),
                          child: new Row(children: <Widget>[
                            new Container(
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                              //margin: const EdgeInsets.all(7.0),
                              //  padding: EdgeInsets.symmetric(horizontal: 10.0),

                              child: CircleAvatar(
                                radius: 45,
                                //encikllListd[index].imagePath,
                                backgroundImage: NetworkImage(
                                  "https://cdn.discordapp.com/attachments/839078982598131712/899743277576749126/avatar1.jpg",
                                ),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(left: 15.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                    child: new Container(
                                      width: 200,
                                      height: 40,
                                      child: new RaisedButton(
                                        child: new Text(
                                          "Змінити аватар",
                                          style: TextStyle(
                                            // h4 -> display1

                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 0.4,
                                            height: 0.9,
                                            color: Colors.white,
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: BorderSide(
                                                color: Colors.white, width: 3)),
                                        onPressed: () {},
                                        color: Colors.black.withOpacity(0.05),
                                      ),
                                    ),
                                  ),
                                  new Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                    child: new Container(
                                      child: new Container(
                                        width: 200,
                                        height: 40,
                                        child: new RaisedButton(
                                          child: new Text(
                                            "Видалити",
                                            style: TextStyle(
                                              // h4 -> display1

                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              letterSpacing: 0.4,
                                              height: 0.9,
                                              color: Colors.red.shade900,
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                  color: Colors.white,
                                                  width: 3)),
                                          onPressed: () {},
                                          color: Colors.black.withOpacity(0.05),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]),
                        ),
                        new Padding(
                            padding: EdgeInsets.only(
                                left: 15.0, right: 15, top: 5, bottom: 5),
                            child: new Divider(
                              height: 3,
                              color: Colors.black,
                            )),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: new Text(
                            "Персорнальна інформація",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 0.4,
                              height: 0.9,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        new Form(
                          key: formKeyemail,
                          child: new Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: new Container(
                              width: MediaQuery.of(context).size.width - 40,
                              child: new TextFormField(
                                controller: emailControl,
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
                        ),
                        new Form(
                          key: formKeylog,
                          child: new Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: new Container(
                              width: MediaQuery.of(context).size.width - 40,
                              child: new TextFormField(
                                controller: nameControl,
                                decoration: new InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  hintText: 'Username',
                                  suffixIcon: Icon(Icons.person_outline),
                                  filled: true,
                                  fillColor: Colors.white,
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
                        ),
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: new Container(
                            width: 200,
                            height: 40,
                            child: new RaisedButton(
                              child: new Text(
                                "Збрегти зміни",
                                style: TextStyle(
                                  // h4 -> display1

                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 0.4,
                                  height: 0.9,
                                  color: Colors.white,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      color: Colors.white, width: 3)),
                              onPressed: () {
                                if (formKeyemail.currentState!.validate()) {
                                  widget.user.email = emailControl.text;
                                  getDatahttp
                                      .changeEmail(widget.user)
                                      .then((value) => Navigator.push<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          ProfileScreen(user: value),
                                    ),
                                  ));
                                } else if (formKeylog.currentState!.validate()) {
                                  widget.user.login = nameControl.text;
                                  getDatahttp
                                      .changeLogin(widget.user)
                                      .then((value) => Navigator.push<dynamic>(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (BuildContext context) =>
                                                  ProfileScreen(user: value),
                                            ),
                                          ));
                                }
                              },
                              color: Colors.black.withOpacity(0.05),
                            ),
                          ),
                        ),
                        new Padding(
                            padding: EdgeInsets.only(
                                left: 15.0, right: 15, top: 5, bottom: 5),
                            child: new Divider(
                              height: 3,
                              color: Colors.black,
                            )),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: new Text(
                            "Зміна поролю",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 0.4,
                              height: 0.9,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        new Form(
                          key: formKeypass,
                          child: Column(
                            children: [
                              new Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: new Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: new TextFormField(
                                    controller: oldpassControl,
                                    obscureText: true,
                                    decoration: new InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      suffixIcon: Icon(Icons.lock_outline),
                                      hintText: 'Старий пароль',
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
                              new Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: new Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: new TextFormField(
                                    controller: newpassControl,
                                    obscureText: true,
                                    decoration: new InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      suffixIcon: Icon(Icons.lock_outline),
                                      hintText: 'Новий пароль',
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
                            ],
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: new Container(
                            width: 200,
                            height: 40,
                            child: new RaisedButton(
                              child: new Text(
                                "Змінити пароль",
                                style: TextStyle(
                                  // h4 -> display1

                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 0.4,
                                  height: 0.9,
                                  color: Colors.white,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      color: Colors.white, width: 3)),
                              onPressed: () {
                                if (formKeypass.currentState!.validate() && widget.user.password == oldpassControl.text) {
                                  widget.user.password = newpassControl.text;
                                  getDatahttp
                                      .changePassword(widget.user)
                                      .then((value) => Navigator.push<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          ProfileScreen(user: value),
                                    ),
                                  ));
                                }

                              },
                              color: Colors.black.withOpacity(0.05),
                            ),
                          ),
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
    ));
  }

  void onPressed() {}

  @override
  void dispose() {
    super.dispose();
  }
}
