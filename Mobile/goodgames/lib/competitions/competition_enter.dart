import 'package:goodgames/competitions/competition_info.dart';
import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/regist.dart';
import 'package:goodgames/profile/ProfileScreen.dart';

import '../../../home_screen.dart';
import '../../../main.dart';
import '../../../getdata.dart';

class CompetitionEnterPage extends StatefulWidget {

  final Competition comp;
  @override
  _CompetitionEnterState createState() => _CompetitionEnterState();

  CompetitionEnterPage({Key? key, required this.comp}) : super(key: key);
}

class _CompetitionEnterState extends State<CompetitionEnterPage> {
  final TextEditingController emailControl = TextEditingController();
  final TextEditingController nameControl = TextEditingController();
  final TextEditingController ageControl = TextEditingController();
  final TextEditingController weigthControl = TextEditingController();
//  final TextEditingController healthStateControl = TextEditingController();
  final TextEditingController teamControl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String dropdownValuehealthState = 'good';
  String dropdownValuegender = 'm';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.orange.shade200,
          centerTitle: true,
          elevation: 0.0,
          title: new Text(
            "Competition Add",
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
                    // alignment: Alignment(0.00, -0.50),
                    child: new ListView(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          // height: 300.0,
                          // width: 400.0,
                          //alignment: Alignment(0.00, -0.50),
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
                                    //  obscureText: true,
                                      decoration: new InputDecoration(
                                        hintText: 'name',
                                        filled: true,
                                        fillColor: Colors.white70,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !RegExp(r'^[a-zA-Z0-9]+$')
                                                .hasMatch(value)) {
                                          //  r'^[0-9]{10}$' pattern plain match number with length 10
                                          return "Enter Correct name";
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
                                      controller: emailControl,
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
                                      controller: ageControl,
                                    //  obscureText: true,
                                      decoration: new InputDecoration(
                                        hintText: 'age',
                                        filled: true,
                                        fillColor: Colors.white70,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !RegExp(r'^[0-9]+$')
                                                .hasMatch(value)) {
                                          //  r'^[0-9]{10}$' pattern plain match number with length 10
                                          return "Enter Correct age";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                new DropdownButton<String>(
                                  value: dropdownValuegender,
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValuegender = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'm',
                                    'f'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                new Padding(
                                  padding: EdgeInsets.all( 5.0),
                                  child: new Container(
                                    width: 275.0,
                                    child: new TextFormField(
                                      controller: weigthControl,
                                    //  obscureText: true,
                                      decoration: new InputDecoration(
                                        hintText: 'weigth',
                                        filled: true,
                                        fillColor: Colors.white70,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !RegExp(r'^[0-9]+$')
                                                .hasMatch(value)) {
                                          //  r'^[0-9]{10}$' pattern plain match number with length 10
                                          return "Enter Correct weigth";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                new DropdownButton<String>(
                                  value: dropdownValuehealthState,
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValuehealthState = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'good',
                                    'not good',
                                    'dead inside',
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                new Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: new Container(
                                    width: 275.0,
                                    child: new TextFormField(
                                      controller: teamControl,
                                      //obscureText: true,
                                      decoration: new InputDecoration(
                                        hintText: 'team',
                                        filled: true,
                                        fillColor: Colors.white70,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !RegExp(r'^[a-zA-Z0-9]+$')
                                                .hasMatch(value)) {
                                          //  r'^[0-9]{10}$' pattern plain match number with length 10
                                          return "Enter Correct team";
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
                                        margin: const EdgeInsets.only(bottom: 7.0),
                                        padding: EdgeInsets.only(right: 20.0),
                                        // width: 140.0,
                                        // height: 35.0,
                                        child: new RaisedButton(
                                          child: new Text("enter"),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(18.0),
                                          ),
                                          onPressed: () {
                                            if (formKey.currentState!.validate()) {
                                              getDatahttp
                                                  .postNewCompetitor(nameControl.text,
                                                  emailControl.text ,  int. parse(ageControl.text),dropdownValuegender,  int. parse(weigthControl.text) , dropdownValuehealthState , teamControl.text, widget.comp.id!)
                                                  .then((value) =>
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                      context) =>
                                                          CompetitionInfoScreen(
                                                              comp: widget.comp),
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
