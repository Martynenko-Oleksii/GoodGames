import 'package:goodgames/getdata.dart';
import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/regist.dart';
import 'package:goodgames/profile/ProfileScreen.dart';

import 'package:flutter/cupertino.dart';

import '../../../home_screen.dart';
import '../../../main.dart';
import '../apptheme.dart';
import '../getdata.dart';
import '../maket.dart';
import 'competition_info.dart';
import 'copetition_add.dart';

class CompetitionsheduleScreen extends StatefulWidget {
  final Competition comp;

  CompetitionsheduleScreen({Key? key, required this.comp}) : super(key: key);

  @override
  _CompetitionsheduleState createState() => _CompetitionsheduleState();
}

class _CompetitionsheduleState extends State<CompetitionsheduleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool multiple = false;
  final ScrollController _scrollController = ScrollController();
  final formKeyscore = GlobalKey<FormState>();
  final TextEditingController scoresendControl = TextEditingController();
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
          "shedule",
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
                        height: MediaQuery.of(context).size.height - 200,
                        child: FutureBuilder(
                          future: getDatahttp.getTimetable(widget.comp.id!),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox();
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.vertical,

                                itemBuilder: (BuildContext context, int index) {
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

                                  return CompetitionsheduleListView(
                                    listData: snapshot.data[index],
                                    animation: animation,
                                    animationController: animationController,
                                    callBack: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (BuildContext context) =>
                                            Form(
                                              key: formKeyscore,
                                              child: new AlertDialog(
                                                title: const Text(
                                                    'Send score'),
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
                                                        scoresendControl,
                                                        decoration:
                                                        new InputDecoration(
                                                          hintText: 'Score',
                                                          filled: true,
                                                          fillColor: Colors
                                                              .white70,
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
                                                      }
                                                      //  Navigator.of(context).pop();
                                                    },
                                                    textColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                    child:
                                                    const Text('Send'),
                                                  ),
                                                  new FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
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
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /*   new Expanded(
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
                            onPressed:(){
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
                  ),*/
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
    required this.callBack,
  }) : super(key: key);

  final TimetableCell listData;

  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation<double> animation;

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
                children: [
                  Container(
                    child: Text(
                      listData.winResult!.competitors![0].name! +
                          " - " +
                          listData.winResult!.competitors![1].name! +
                          " : " +
                          listData.winResult!.score! +
                          " -> " +
                          listData.dateTime.toString(),

                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
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