import 'package:goodgames/competitions/all_competitions.dart';
import 'package:goodgames/getdata.dart';
import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/regist.dart';
import 'package:goodgames/profile/ProfileScreen.dart';


import 'package:flutter/cupertino.dart';


import '../../../main.dart';
import '../apptheme.dart';
import '../getdata.dart';
import 'competition_info.dart';
import 'copetition_add.dart';

class CompetitionsScreen extends StatefulWidget {
  final User user;

  CompetitionsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _CompetitionsState createState() => _CompetitionsState();
}

class _CompetitionsState extends State<CompetitionsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  final ScrollController _scrollController = ScrollController();

  List<Competition> competitions = [];

  bool multiple = false;
  int currentIndex = 3;

  @override
  void initState() {
    getDatahttp.getCompetitions(widget.user.id!)
      .then((value) {
      if (value != false) {
        setState(() {
          competitions = value;
        });
      }
    });

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
          "Список змагань",
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
      body: ListView(
        children: <Widget>[
          new Container(
            height: 10,
          ),
          Container(
            child: new Stack(children: <Widget>[


              new Container(
                padding: EdgeInsets.only(top: 5.0),
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
                      padding: EdgeInsets.only( bottom: 15),
                      child: RaisedButton(
                        child: new Text("Додати змагання",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 0.4,
                            height: 0.9,
                            color: Colors.white,
                          ),),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white, width: 3)
                        ),
                        onPressed: () {
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  CompetitionAddPage(user: widget.user),
                            ),
                          );
                        },
                        color: Colors.black26.withOpacity(0.5),
                      ),
                    ),
                    new Container(
                      height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height/4,
                      child: FutureBuilder(
                        future: getData(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          } else {
                            return ListView.builder(
                              itemCount: competitions.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                final int count = competitions.length > 10
                                    ? 10
                                    : competitions.length;
                                final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval(
                                        (1 / count) * index, 1.0,
                                        curve:
                                        Curves.fastOutSlowIn)));
                                animationController.forward();

                                return CompetitionListView(
                                  listData: competitions[index],
                                  user: widget.user,
                                  animation: animation,
                                  animationController: animationController,
                                  callBack: this.callback,
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
            ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {}
          if (index == 1) {}
          if (index == 2) { Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      AllCompetitionsStat(user: widget.user , isfavorit: false,)));
          }
          if (index == 4) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ProfileScreen(user: widget.user)));
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Головна"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.videocam_outlined),
              label: "Трансляції"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_baseball_outlined),
              label: "Змагання"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              label: "Список"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: "Профіль"
          ),
        ],
      ),

    );
  }

  void callback(int competitionId) {
    setState(() {
      competitions.removeWhere((element) => element.id == competitionId);
    });
  }

  void onPressed() {}
}

class CompetitionListView extends StatelessWidget {
  const CompetitionListView({
    Key? key,
    required this.listData,
    required this.user,
    required this.animationController,
    required this.animation,
    required this.callBack,
  }) : super(key: key);

  final Competition listData;
  final User user;
  final AnimationController animationController;
  final Animation<double> animation;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0
            ),
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
                                Container(
                                  width: 250 ,
                                    child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: new Text(listData.title!,
                                    ),
                                    onPressed: () {
                                      Navigator.push<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) => CompetitionInfoScreen(comp: listData, user: user,),
                                        ),
                                      );
                                    },
                                    color: Colors.blue.shade200,
                                  ),

                                ),

                                new RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Icon(Icons.dangerous),
                                  onPressed: () {

                                    getDatahttp.deleteCompetition(listData.id!)
                                        .then((value) {
                                              if (value.id == listData.id) {
                                                callBack(value.id);
                                              }
                                            });
                                  },
                                  color: Colors.redAccent.shade200,
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
