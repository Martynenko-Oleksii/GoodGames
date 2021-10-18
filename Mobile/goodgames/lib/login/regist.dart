import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';


import '../../../home_screen.dart';
import '../../../main.dart';

class RegistPage extends StatefulWidget{
  @override
  _RegistState createState() => _RegistState();
}


class _RegistState extends State<RegistPage> {
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
    )
    ),
    child:new Stack(
        children: <Widget>[
          new Container(
            alignment: Alignment(0.00,-0.50),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,


              children: <Widget>[
                new Container(
                  height: 250.0,
                  width: 300.0,
                  alignment: Alignment(0.00,-0.50),
                  /*



                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 5,
                        )
                    ),
                      */

                  child: new Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: new Container(
                          width: 275.0,
                          child: new TextField(
                            controller: new TextEditingController(),
                            decoration: new InputDecoration(
                              hintText: 'Username',
                              filled: true,
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: new Container(
                          width: 275.0,
                          child: new TextField(
                            controller: new TextEditingController(),
                            decoration: new InputDecoration(
                              hintText: 'Email',
                              filled: true,
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                      ),

                      new Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child:  new Container(

                          width: 275.0,
                          child: new TextField(
                            controller: new TextEditingController(),
                            obscureText: true,
                            decoration: new InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                      ),


                      new Container(
                        //margin: const EdgeInsets.only( bottom: 150.0),
                        child: new Row(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: <Widget>[
                            new Container(
                             // margin: const EdgeInsets.only(bottom: 100.0),
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              width: 220.0,
                              height: 40.0,
                              child: new RaisedButton(
                                child: new Text("Create account"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                onPressed:(){
                                  Navigator.push<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) => MyApp(),
                                    ),
                                  );
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
              ],
            ),
          ),
        ],
      ),
    ))
    );
  }

  void onPressed() {}
  @override
  void dispose() {
    super.dispose();
  }

}
