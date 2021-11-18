import 'package:goodgames/competitions/competition_info.dart';
import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/regist.dart';
import 'package:goodgames/profile/ProfileScreen.dart';

import '../../../main.dart';
import '../../../getdata.dart';
import '../apptheme.dart';

class CompetitionEnterPage extends StatefulWidget {

  final Competition comp;
  final User user;
  @override
  _CompetitionEnterState createState() => _CompetitionEnterState();

  CompetitionEnterPage({Key? key, required this.comp , required this.user}) : super(key: key);
}

class _CompetitionEnterState extends State<CompetitionEnterPage> {
  final TextEditingController emailControl = TextEditingController();
  final TextEditingController nameControl = TextEditingController();
  final TextEditingController ageControl = TextEditingController();
  final TextEditingController weigthControl = TextEditingController();
//  final TextEditingController healthStateControl = TextEditingController();
  final TextEditingController teamControl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String dropdownValuehealthState = 'Відмінне';
  String dropdownValuegender = 'm';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white.withOpacity(0),
          centerTitle: true,
          elevation: 0.0,

          title: new Text(
            "Прийняти участь",
            textScaleFactor: 1.3,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30) , bottomRight : Radius.circular(30)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [
                    0,
                    0.5,
                    1,
                  ],
                  colors: [
                    Colors.amber.shade200,
                    Colors.green.shade300,
                    Colors.teal.shade400,
                  ],
                )),
          ),
        ),
        body: Center(
          child: new Stack(
            children: <Widget>[
              new Container(
                // alignment: Alignment(0.00, -0.50),
                child: new ListView(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(height: 10,),
                    new Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(top: 15.0 , bottom: 5),
                              child: new Container(
                                width: 275.0,
                                child: new TextFormField(
                                  controller: nameControl,
                                  //  obscureText: true,
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    hintText: 'Ім\'я',
                                    filled: true,
                                    fillColor: Colors.white,
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
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    hintText: 'Пошта',
                                    filled: true,
                                    fillColor: Colors.white,
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
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    hintText: 'Вік',
                                    filled: true,
                                    fillColor: Colors.white,
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
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:[
                                new Container(
                                  // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                  padding: EdgeInsets.all(10.0),

                                  child: new Text(
                                    "Стать ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.darkText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            new DropdownButton<String>(
                              value: dropdownValuegender,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.green,
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
    ]),
                            new Padding(
                              padding: EdgeInsets.all( 5.0),
                              child: new Container(
                                width: 275.0,
                                child: new TextFormField(
                                  controller: weigthControl,
                                  //  obscureText: true,
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    hintText: 'Вага',
                                    filled: true,
                                    fillColor: Colors.white,
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
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:[
                                  new Container(
                                    // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                    padding: EdgeInsets.all(10.0),

                                    child: new Text(
                                      "Станн здоров'я",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),

                            new DropdownButton<String>(
                              value: dropdownValuehealthState,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.green,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValuehealthState = newValue!;
                                });
                              },
                              items: <String>[
                                'Відмінне',
                                'Спеціальна группа',
                                'Немаєзначення',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),]),
                            new Padding(
                              padding: EdgeInsets.only(top: 5.0, bottom: 15),
                              child: new Container(
                                width: 275.0,
                                child: new TextFormField(
                                  controller: teamControl,
                                  //obscureText: true,
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    hintText: 'Назва команди',
                                    filled: true,
                                    fillColor: Colors.white,
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

                          ],
                        ),
                      ),
                    ),
                    new Container(
                      //margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: new RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: new Text("Приєднатись"),
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
                                          comp: widget.comp , user: widget.user,),
                                  ),
                                ));

                          }

                          //getDatahttp.getCompetition(1);

                        },
                        color: Colors.pinkAccent.shade400,
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
