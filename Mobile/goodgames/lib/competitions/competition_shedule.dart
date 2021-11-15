import 'package:goodgames/getdata.dart';
import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/regist.dart';
import 'package:goodgames/profile/ProfileScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../home_screen.dart';
import '../../../main.dart';
import '../apptheme.dart';
import '../getdata.dart';
import '../maket.dart';
import 'competition_info.dart';
import 'copetition_add.dart';

class CompetitionsheduleScreen extends StatefulWidget {
  final Competition comp;
  final User user;

  CompetitionsheduleScreen({Key? key, required this.comp, required this.user})
      : super(key: key);

  @override
  _CompetitionsheduleState createState() => _CompetitionsheduleState();
}

class _CompetitionsheduleState extends State<CompetitionsheduleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool multiple = false;
  final ScrollController _scrollController = ScrollController();

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
          "Розклад",
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
      body: ListView(
        children: <Widget>[
          new Container(
            height: 10,
            // padding: EdgeInsets.all( 100.0),
          ),
          Container(
            child: new Stack(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(top: 5.0),
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.height / 8,
                  //  width: 400.0,
                  //  width: MediaQuery.of(context).size.width,
                  // alignment: Alignment(0.00, -0.50),
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
                  // alignment: Alignment(0.00, -0.50),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                       // height: MediaQuery.of(context).size.height - 200,
                        child: FutureBuilder(
                          future: getDatahttp.getTimetable(widget.comp.id!),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox();
                            } else {
                             // List<TimetableCell> cells = [];
                             // cells.isEmpty
                              if (!snapshot.data.isEmpty) {
                                return Container(
                                  height: MediaQuery.of(context).size.height - 200,
                                  child:
                                  ListView.builder(
                                  itemCount: snapshot.data.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int count = snapshot.data.length > 10
                                        ? 10
                                        : snapshot.data.length;
                                    final Animation<double> animation =
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(CurvedAnimation(
                                                parent: animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn)));
                                    animationController.forward();
                                    if (widget.user.id !=
                                        widget.comp.user!.id) {
                                      return CompetitionsheduleListView(
                                        listData: snapshot.data[index],
                                        animation: animation,
                                        animationController:
                                            animationController,
                                        user: widget.user,
                                        context: this.context,
                                        comp: widget.comp,
                                        callBack: () {},
                                      );
                                    } else {
                                      return CompetitionsheduleListView(
                                        listData: snapshot.data[index],
                                        animation: animation,
                                        user: widget.user,
                                        context: this.context,
                                        animationController:
                                            animationController,
                                        comp: widget.comp,
                                        callBack: () {},
                                      );
                                    }
                                  },
                                ), );
                              } else {
                                return new Container(
                                  margin: EdgeInsets.only(top: 15.0 , left: 10 , right: 10),
                                  width:MediaQuery.of(context).size.width,
                                  height: 40,
                                  child: new RaisedButton(
                                    child: new Text(
                                      "Створити розклад",
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
                                      getDatahttp.generateSchedule(
                                          widget.comp.id!,
                                          '2021-11-05T10:00:00',
                                          '2021-11-05T19:00:00'); //TODO
                                    },
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                );
                              }
                            }
                          },
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
    );
  }

  void onPressed() {}
}

class CompetitionsheduleListView extends StatelessWidget {
  const CompetitionsheduleListView({
    Key? key,
    required this.listData,
    required this.animationController,
    required this.animation,
    required this.user,
    required this.callBack,
    required this.context,
    required this.comp,
  }) : super(key: key);

  final TimetableCell listData;
  final Competition comp;
  final User user;
  final context;
  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation<double> animation;
  static TextEditingController scoresendControlone = TextEditingController();
  static TextEditingController scoresendControltwo = TextEditingController();
  static GlobalKey<FormState> formKeyscore = GlobalKey<FormState>();

  // static TextEditingController scoreone = TextEditingController();
//  static TextEditingController loginControl = TextEditingController();
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: getDatahttp.getAllAdmins(comp.id!),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      } else {
                        return isresolt(snapshot.data, listData);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget isresolt(List<User> users, TimetableCell listData) {
    if (listData.winResult != null) {
      return Container(
        child:  new Container(
          //height: 70,
          width: MediaQuery.of(context).size.width - 40,
          padding: EdgeInsets.only( left: 10.0 , right: 10 , top: 5),
          child: new Container(
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.all(Radius.circular(30)),
                color: Colors.amber.shade50,
                border: Border.all(
                    color: Colors.black, width: 2)),
            child: new Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  // margin: const EdgeInsets.symmetric(vertical: 0.0),
                  padding: EdgeInsets.all(10.0),

                  child: new Text(
                    listData.competitors![0].name! +
                        " - " +
                        listData.competitors![1].name!,
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
                    "Результат: "+
                    listData.winResult!.score!,
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


        //TODO winResult ne to
        /*child: Text(
          listData.competitors![0].name! +
              " - " +
              listData.competitors![1].name! +
              " :  " +
              listData.winResult!.score! +
              " ->  " +
              DateFormat('yyyy-MM-dd kk:mm').format(listData.dateTime!),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),*/
      );
    } else {
      return Container(
        child:  new Container(
          //height: 70,
          width: MediaQuery.of(context).size.width - 40,
          padding: EdgeInsets.only( left: 10.0 , right: 10 , top: 5),
          child: new Container(
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.all(Radius.circular(30)),
                color: Colors.amber.shade50,
                border: Border.all(
                    color: Colors.black, width: 2)),
            child: new Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  // margin: const EdgeInsets.symmetric(vertical: 0.0),
                  padding: EdgeInsets.all(10.0),

                  child: new Text(
                    listData.competitors![0].name! +
                        " - " +
                        listData.competitors![1].name!,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  width: 10,
                ),
                new Container(
                  // margin: const EdgeInsets.symmetric(vertical: 0.0),
                  padding: EdgeInsets.all(10.0),

                  child: new Text(
                    "Час: " +
                    DateFormat('yyyy-MM-dd kk:mm').format(listData.dateTime!),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 5,
                  ),
                  child: admin(users),
                )
              ],
            ),
          ),
        ),
        //TODO winResult ne to
       /* child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                listData.competitors![0].name! +
                    " - " +
                    listData.competitors![1].name! +
                    " :  " +
                    //  listData.winResult!.score! +
                    " ->  " +
                    DateFormat('yyyy-MM-dd kk:mm').format(listData.dateTime!),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 5,
                ),
                child: admin(users),
              )
            ]),
      */);
    }
  }

  Widget admin(List<User> users) {
    bool isdmin = false;
    for (User u in users) {
      if (user.id == u.id) {
        isdmin = true;
      }
    }
    if (isdmin) {
      return new Container(
        margin: EdgeInsets.only(left: 5.0),
        width: 50,
        height: 25,
        child: new RaisedButton(
          child: Container(child: Icon(Icons.edit)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => Form(
                key: formKeyscore,
                child: new AlertDialog(
                  title: const Text('Send score'),
                  content: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        // width: 275.0,
                        child: new TextFormField(
                          controller: scoresendControlone,
                          decoration: new InputDecoration(
                            hintText: '1 team Score',
                            filled: true,
                            fillColor: Colors.white70,
                          ),
                        ),
                      ),
                      new Container(
                        // width: 275.0,
                        child: new TextFormField(
                          controller: scoresendControltwo,
                          decoration: new InputDecoration(
                            hintText: '2 team Score',
                            filled: true,
                            fillColor: Colors.white70,
                          ),
                        ),
                      ),
                      // Text("Hello"),
                    ],
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () {
                        {
                          getDatahttp.postResults(
                              listData.id!,
                              listData.competitors![0].team!,
                              listData.competitors![0].team!,
                              scoresendControlone.text,
                              scoresendControltwo.text);

                          scoresendControlone.text = "";
                          scoresendControltwo.text = "";
                          Navigator.of(context).pop();
                        }
                      },
                      textColor: Theme.of(context).primaryColor,
                      child: const Text('Send'),
                    ),
                    new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      textColor: Theme.of(context).primaryColor,
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            );
          },
          color: Colors.redAccent.shade200,
        ),
      );
    } else {
      return new Container();
    }
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
