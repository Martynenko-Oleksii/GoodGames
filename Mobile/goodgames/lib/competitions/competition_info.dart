import 'package:goodgames/getdata.dart';
import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/regist.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../home_screen.dart';
import '../../../main.dart';
import '../apptheme.dart';
import '../getdata.dart';
import 'competition_enter.dart';
import 'competition_shedule.dart';

class CompetitionInfoScreen extends StatefulWidget {
  final Competition comp;
  final User user;
  @override
  _CompetitionState createState() => _CompetitionState();

  CompetitionInfoScreen({Key? key, required this.comp ,required this.user }) : super(key: key);
}

class _CompetitionState extends State<CompetitionInfoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool multiple = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController emailsendControl = TextEditingController();
  final formKeyinvite = GlobalKey<FormState>();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        centerTitle: true,
        elevation: 0.0,
        title: new Text(
          "Перегляд змагання",
          textScaleFactor: 1.3,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
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
      body: Container(
        child: new Stack(
          children: <Widget>[
            new Container(
              // alignment: Alignment(0.00, -0.50),
              child: FutureBuilder(
                  future: getDatahttp.getCompetition(widget.comp.id!),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    } else {
                      return new ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        //  mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            // height: 300,
                            padding: EdgeInsets.all(10.0),
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    stops: [
                                      0,
                                      0.25,
                                      0.75,
                                      1,
                                    ],
                                    colors: [
                                      Colors.red.shade200,
                                      Colors.indigo.shade200,
                                      Colors.red.shade200,
                                      Colors.indigo.shade200,
                                    ],
                                  )),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      new Container(
                                        margin: const EdgeInsets.only(),
                                        padding: EdgeInsets.all(10.0),
                                        child: new Text(
                                          snapshot.data.title,
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: AppTheme.darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  /*new Container(
                                    // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                    padding: EdgeInsets.all(10.0),

                                    child: new Text(
                                      snapshot.data.sport.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),*/
                                  /*  new Row(
                                    children: [
                                      new Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                        padding: EdgeInsets.all(10.0),

                                        child: new Text(
                                          "start data",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      new Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                        padding: EdgeInsets.all(10.0),
                                        child: new Text(
                                          snapshot.data.startDate.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    children: [
                                      new Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                        padding: EdgeInsets.all(10.0),

                                        child: new Text(
                                          "end data",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      new Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                        padding: EdgeInsets.all(10.0),

                                        child: new Text(
                                          snapshot.data.endDate.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),*/
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      new Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                        padding: EdgeInsets.only(left: 15.0 , top: 10),

                                        child: new Text(
                                          "By: ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      new Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                        padding: EdgeInsets.all(10.0),

                                        child: new Text(
                                          snapshot.data.user.login,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      new Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                        padding: EdgeInsets.only(left: 15.0 , bottom: 15 , top: 10),

                                        child: new Text(
                                          "Місто: ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      new Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                        padding: EdgeInsets.all(10.0),

                                        child: new Text(
                                          snapshot.data.city,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      new Container(
                                        padding: EdgeInsets.only( bottom: 15 ),
                                        child: new RaisedButton(
                                          padding: EdgeInsets.all(10.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(5.0),
                                          ),
                                          child: new Text(
                                            "Підписатися",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppTheme.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          onPressed: () {

                                          },
                                          color: Colors.redAccent.shade200,
                                        ),
                                      ),
                                    ],
                                  )


                                ],
                              ),
                            ),
                          ),
                          new Padding(
                              padding: EdgeInsets.only(left: 15.0 , right: 15 , top: 5 , bottom: 5),
                              child: new Divider(
                                height: 3,
                                color: Colors.black,
                              )
                          ),
                          new Container(
                            height: 500,
                            padding: EdgeInsets.all(10.0),
                            child: new Container(
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
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[

                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children :[
                                      new Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                        padding: EdgeInsets.all(10.0),
                                        child: new Text(
                                          "Учасники: ",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: AppTheme.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      new Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                        padding: EdgeInsets.all(10.0),

                                        child: new Text(
                                          snapshot.data.competitors.length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: AppTheme.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Container(
                                    height: 350,
                                    child: FutureBuilder(
                                      future: getData(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot2) {
                                        if (!snapshot2.hasData) {
                                          return const SizedBox();
                                        } else {
                                          return ListView.builder(
                                            itemCount: snapshot
                                                .data.competitors.length,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final int count = snapshot.data
                                                  .competitors.length >
                                                  10
                                                  ? 10
                                                  : snapshot
                                                  .data.competitors.length;
                                              final Animation<
                                                  double> animation = Tween<
                                                  double>(
                                                  begin: 0.0, end: 1.0)
                                                  .animate(CurvedAnimation(
                                                  parent:
                                                  animationController,
                                                  curve: Interval(
                                                      (1 / count) * index,
                                                      1.0,
                                                      curve: Curves
                                                          .fastOutSlowIn)));
                                              animationController.forward();

                                              return CompetitionMemberListView(
                                                listData: snapshot
                                                    .data.competitors[index],
                                                animation: animation,
                                                animationController:
                                                animationController,
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),

                                  new Container(
                                    padding: EdgeInsets.only( bottom: 5 , top: 10 ),
                                    child: new RaisedButton(
                                      padding: EdgeInsets.all(10.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(5.0),
                                      ),
                                      child: new Text(
                                        "Запросити участь!",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push<dynamic>(
                                          context,
                                          MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context) =>
                                                CompetitionEnterPage(
                                                    comp: widget.comp , user: widget.user,),
                                          ),
                                        );
                                      },
                                      color: Colors.redAccent.shade200,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Padding(
                              padding: EdgeInsets.only(left: 15.0 , right: 15 , top: 5 , bottom: 5),
                              child: new Divider(
                                height: 3,
                                color: Colors.black,
                              )
                          ),
                          new Container(
                            height: 300,
                            padding: EdgeInsets.all(10.0),
                            child: new Container(

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  color: Colors.amber.shade50,
                                  border:  Border.all(color: Colors.black , width: 2)
                              ),
                              child: new Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                    padding: EdgeInsets.all(10.0),

                                    child: new Text(
                                      "Трансляції",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  new Padding(
                                      padding: EdgeInsets.only(left: 25.0 , right: 25 , bottom: 5),
                                      child: new Divider(
                                        height: 3,
                                        color: Colors.black,
                                      )
                                  ),
                                  /* new RaisedButton(
                                    padding: EdgeInsets.all(10.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: new Text(
                                      "streams",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) =>
                                              RegistPage(),
                                        ),
                                      );
                                    },
                                    color: Colors.redAccent.shade200,
                                  ),
                                  new RaisedButton(
                                    padding: EdgeInsets.all(10.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: new Text(
                                      "official web",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) =>
                                              RegistPage(),
                                        ),
                                      );
                                    },
                                    color: Colors.redAccent.shade200,
                                  ),*/
                                ],
                              ),
                            ),
                          ),
/*
                          new Container(
                            height: 200,
                            padding: EdgeInsets.all(10.0),
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16.0)),
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
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Row(
                                    children: [
                                      new Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                        padding: EdgeInsets.all(10.0),

                                        child: new Text(
                                          "number of participants",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      new Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                        padding: EdgeInsets.all(10.0),

                                        child: new Text(
                                          snapshot.data.competitors.length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Container(
                                    // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                    padding: EdgeInsets.all(10.0),

                                    child: new Text(
                                      snapshot.data.state.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  new Row(
                                    children: [
                                      new Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: new RaisedButton(
                                          padding: EdgeInsets.all(10.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                          child: new Text(
                                            "send invitation",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppTheme.darkText,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  Form(
                                                key: formKeyinvite,
                                                child: new AlertDialog(
                                                  title: const Text(
                                                      'Send invitation'),
                                                  content: new Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      new Container(
                                                        // width: 275.0,
                                                        child:
                                                            new TextFormField(
                                                          controller:
                                                              emailsendControl,
                                                          decoration:
                                                              new InputDecoration(
                                                            hintText: 'Email',
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white70,
                                                          ),
                                                          validator: (value) {
                                                            if (value!
                                                                    .isEmpty ||
                                                                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                                                    .hasMatch(
                                                                        value)) {
                                                              return "Enter Correct Email Address";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      // Text("Hello"),
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    new FlatButton(
                                                      onPressed: () {
                                                        if (formKeyinvite
                                                            .currentState!
                                                            .validate()) {
                                                          getDatahttp
                                                              .postEmail(
                                                                  emailsendControl
                                                                      .text,
                                                                  snapshot
                                                                      .data.id,
                                                                  snapshot.data
                                                                      .user.id)
                                                              .then((value) =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop());
                                                          emailsendControl
                                                              .text = '';
                                                        }
                                                        //  Navigator.of(context).pop();
                                                      },
                                                      textColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      child: const Text('Send'),
                                                    ),
                                                    new FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        emailsendControl.text =
                                                            '';
                                                      },
                                                      textColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      child:
                                                          const Text('Close'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          color: Colors.redAccent.shade200,
                                        ),
                                      ),
                                      new RaisedButton(
                                        padding: EdgeInsets.all(10.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        child: new Text(
                                          "enter",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push<dynamic>(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (BuildContext context) =>
                                                  CompetitionEnterPage(
                                                      comp: widget.comp),
                                            ),
                                          );
                                        },
                                        color: Colors.redAccent.shade200,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Container(
                            height: 200,
                            padding: EdgeInsets.all(10.0),
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16.0)),
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
                              child: new Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                    padding: EdgeInsets.all(10.0),

                                    child: new Text(
                                      "links",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  new RaisedButton(
                                    padding: EdgeInsets.all(10.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: new Text(
                                      "streams",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) =>
                                              RegistPage(),
                                        ),
                                      );
                                    },
                                    color: Colors.redAccent.shade200,
                                  ),
                                  new RaisedButton(
                                    padding: EdgeInsets.all(10.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: new Text(
                                      "official web",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) =>
                                              RegistPage(),
                                        ),
                                      );
                                    },
                                    color: Colors.redAccent.shade200,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Container(
                            height: 300,
                            padding: EdgeInsets.all(10.0),
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16.0)),
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
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                    padding: EdgeInsets.all(10.0),

                                    child: new Text(
                                      "description",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    width: 200,
                                    height: 40,
                                    child: new RaisedButton(
                                      child: new Text(
                                        "shedule",
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
                                      onPressed: () {
                                        Navigator.push<dynamic>(
                                          context,
                                          MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context) =>
                                                CompetitionsheduleScreen(
                                              comp: widget.comp,
                                            ),
                                          ),
                                        );
                                      },
                                      color: Colors.black.withOpacity(0.05),
                                    ),
                                  ),
                                  new Container(
                                    // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                    padding: EdgeInsets.all(10.0),

                                    child: new Text(
                                      "description ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
*/

                          new Padding(
                              padding: EdgeInsets.only(left: 15.0 , right: 15 , top: 5 , bottom: 5),
                              child: new Divider(
                                height: 3,
                                color: Colors.black,
                              )
                          ),
                          new Container(
                            height: 400,
                            padding: EdgeInsets.all(10.0),
                            child: new Container(
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
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                    padding: EdgeInsets.all(10.0),

                                    child: new Text(
                                      "tournament grid",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    height: 270,
                                    // width: 100,
                                    margin: const EdgeInsets.only(
                                        left: 5.0, right: 5),
                                    padding: EdgeInsets.only(),
                                    child: WebView(
                                      initialUrl:
                                      "https://www.goodgames.kh.ua/game/grid/?id=" +
                                          widget.comp.id.toString(),
                                      javascriptMode:
                                      JavascriptMode.unrestricted,
                                    ),
                                  ),

                                  new Container(
                                    width: 200,
                                    height: 40,
                                    margin: const EdgeInsets.only(top: 15.0),
                                    child: new RaisedButton(
                                      child: new Text(
                                        "shedule",
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
                                      onPressed: () {
                                        Navigator.push<dynamic>(
                                          context,
                                          MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context) =>
                                                CompetitionsheduleScreen(
                                                  comp: snapshot.data, user: widget.user,
                                                ),
                                          ),
                                        );
                                      },
                                      color: Colors.black.withOpacity(0.05),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                            admin(snapshot.data),
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget admin(Competition compet){
    if(widget.user.id == compet.user!.id){
      return Container(
       child: Container(
          height: 200,
          padding: EdgeInsets.all(10.0),
          child: new Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular(16.0)),
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
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                new Row(
                  children: [
                    new Container(
                      padding: EdgeInsets.all(10.0),
                      child: new RaisedButton(
                        padding: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(18.0),
                        ),
                        child: new Text(
                          "send invitation",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                Form(
                                  key: formKeyinvite,
                                  child: new AlertDialog(
                                    title: const Text(
                                        'Send invitation'),
                                    content: new Column(
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        new Container(
                                          // width: 275.0,
                                          child:
                                          new TextFormField(
                                            controller:
                                            emailsendControl,
                                            decoration:
                                            new InputDecoration(
                                              hintText: 'Email',
                                              filled: true,
                                              fillColor:
                                              Colors.white70,
                                            ),
                                            validator: (value) {
                                              if (value!
                                                  .isEmpty ||
                                                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                                      .hasMatch(
                                                      value)) {
                                                return "Enter Correct Email Address";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                        // Text("Hello"),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                        onPressed: () {
                                          if (formKeyinvite
                                              .currentState!
                                              .validate()) {
                                            getDatahttp
                                                .postEmail(
                                                emailsendControl
                                                    .text,
                                                compet.id!,
                                                compet.user!.id!)
                                                .then((value) =>
                                                Navigator.of(
                                                    context)
                                                    .pop());
                                            emailsendControl
                                                .text = '';
                                          }
                                          //  Navigator.of(context).pop();
                                        },
                                        textColor:
                                        Theme.of(context)
                                            .primaryColor,
                                        child: const Text('Send'),
                                      ),
                                      new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop();
                                          emailsendControl.text =
                                          '';
                                        },
                                        textColor:
                                        Theme.of(context)
                                            .primaryColor,
                                        child:
                                        const Text('Close'),
                                      ),
                                    ],
                                  ),
                                ),
                          );
                        },
                        color: Colors.redAccent.shade200,
                      ),
                    ),
                    new Container(
                      width: 200,
                      height: 40,
                      child: new RaisedButton(
                        child: new Text(
                          "generateSchedule",
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
                          getDatahttp.generateSchedule(widget.comp.id!, '2021-11-05T10:00:00', '2021-11-05T19:00:00');//TODO
                        },
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }else{
   return Container();
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return Form(
      key: formKeyinvite,
      child: new AlertDialog(
        title: const Text('Send invitation'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              // width: 275.0,
              child: new TextFormField(
                controller: emailsendControl,
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
            // Text("Hello"),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              if (formKeyinvite.currentState!.validate()) {
                getDatahttp
                    .postEmail(emailsendControl.text, widget.comp.id!,
                    widget.comp.user!.id!)
                    .then((value) => Navigator.of(context).pop());
                emailsendControl.text = '';
              }
              //  Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Send'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              emailsendControl.text = '';
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void onPressed() {}
}

class CompetitionMemberListView extends StatelessWidget {
  const CompetitionMemberListView({
    Key? key,
    required this.listData,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final Competitor listData;
  final AnimationController animationController;
  final Animation<double> animation;

  // InteresList listData
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding:
              const EdgeInsets.only(left: 10, right: 24, top: 8, bottom: 1),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      offset: const Offset(4, 4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, top: 8, bottom: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            listData.name.toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
      this.searchUI,
      );

  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}