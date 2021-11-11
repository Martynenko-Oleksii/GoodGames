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

class CompetitionsScreen extends StatefulWidget {
  final User user;

  CompetitionsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _CompetitionsState createState() => _CompetitionsState();
}

class _CompetitionsState extends State<CompetitionsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool multiple = false;
  final ScrollController _scrollController = ScrollController();

  int currentIndex = 3;

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
            // padding: EdgeInsets.all( 100.0),
          ),
          Container(
            child: new Stack(children: <Widget>[


              new Container(
                padding: EdgeInsets.only(top: 5.0),
                //height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height/4,
                //  width: 400.0,
                // alignment: Alignment(0.00, -0.50),
                /*



                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 5,
                        )
                    ),
                      */

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
                  //  mainAxisAlignment: MainAxisAlignment.start,

                  children: <Widget>[
                    // height: 190.0,
                    //  width: 300.0,
                    //alignment: Alignment(0.00, -0.50),
                    /*



                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 5,
                        )
                    ),
                      */




                    new Container(
                      padding: EdgeInsets.only( bottom: 15),
                      child: RaisedButton(

                        child: new Text("Add Competition",
                          style: TextStyle( // h4 -> display1

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


                    /* new Container(
                    // margin: const EdgeInsets.symmetric(vertical: 0.0),
                    //padding: EdgeInsets.only(left: 15.0),

                    child: new Text("Competitions List:"),
                  ),*/

                    new Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: FutureBuilder(
                        future: getDatahttp.getCompetitions(widget.user.id!),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          } else {
                            return ListView.builder(
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

                                return CompetitionListView(
                                  listData: snapshot.data[index],
                                  user: widget.user,
                                  animation: animation,
                                  animationController: animationController,
                                  /*callBack: () {
                                        Navigator.push<dynamic>(
                                          context,
                                          MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context) =>
                                            CompetitionInfoScreen(comp: snapshot.data[index]),
                                            //snapshot.data[index].navigateScreen,
                                          ),
                                        );
                                      },*/
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {}
          if (index == 1) {}
          if (index == 2) {}
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

  void onPressed() {}
}

class CompetitionListView extends StatelessWidget {
  const CompetitionListView({
    Key? key,
    required this.listData,
    required this.user,
    required this.animationController,
    required this.animation,
    //required this.callBack,
  }) : super(key: key);

  final Competition listData;
  final User user;
  //final VoidCallback callBack;
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
                                ButtonTheme(
                                  minWidth: 250.0,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: new Text(listData.title!),
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
                                /*Expanded(
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
                                            listData.title.toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22,
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                ),*/
                                new RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Icon(Icons.dangerous),
                                  onPressed: () {

                                    getDatahttp.deleteCompetition(listData.id!)
                                        .then(
                                            (value) => {
                                              if (value.id == listData.id) {
                                                Navigator.push<dynamic>(
                                                  context,
                                                  MaterialPageRoute<dynamic>(
                                                    builder: (BuildContext context) => CompetitionsScreen(user: user),
                                                  ),
                                                )
                                              }
                                            });

                                    /*Navigator.push<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            RegistPage(),
                                      ),
                                    );*/
                                  },
                                  color: Colors.redAccent.shade200,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      /*Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.grey.withOpacity(0.2),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                          onTap: () {
                            callBack();
                          },
                        ),
                      ),*/
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
