import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/regist.dart';
import 'package:goodgames/profile/profile_intereslist.dart';
import 'package:flutter/cupertino.dart';

import '../../../home_screen.dart';
import '../../../main.dart';
import '../apptheme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  List<InteresList> profileList = InteresList.profileList;
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
          backgroundColor: Colors.orange.shade200,
          centerTitle: true,
          elevation: 0.0,
          title: new Text(
            "Profile",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    new Container(
                      // height: 190.0,
                      //  width: 300.0,
                      alignment: Alignment(0.00, -0.50),
                      /*



                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 5,
                        )
                    ),
                      */
                      child: new Row(children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.all(7.0),
                          //  padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Image.network(
                            "https://cdn.discordapp.com/attachments/839078982598131712/899743277576749126/avatar1.jpg",
                            //encikllListd[index].imagePath,

                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: new Container(
                                width: 200,
                                height: 50,
                                child: new Text(
                                  "name",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: AppTheme.darkText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: new Container(
                                child: new Container(
                                  width: 200,
                                  height: 50,
                                  child: new Text(
                                    "email",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: AppTheme.darkText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ]),
                    ),
                    new Container(
                      margin: const EdgeInsets.all(7.0),
                      width: 300,
                      height: 30,
                      child: new Row(children: <Widget>[
                        new Text(
                          "podpicka",
                          style: TextStyle(
                            fontSize: 22,
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        new Container(
                          // margin: const EdgeInsets.symmetric(vertical: 0.0),
                          padding: EdgeInsets.only(left: 100.0),

                          child: new RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: new Text("Prodliti"),
                            onPressed: onPressed,
                          ),
                        ),
                      ]),
                    ),
                    new Container(
                      padding: EdgeInsets.only(left: 10.0),
                      //margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: new RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: new Text("redact"),
                        onPressed: () {
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
                    new Container(
                      // margin: const EdgeInsets.symmetric(vertical: 0.0),
                      padding: EdgeInsets.only(left: 10.0),

                      child: new Text("ProfileInteresList"),
                    ),
                    new Container(
                      height: MediaQuery.of(context).size.height - 360,
                      child: FutureBuilder(
                        future: getData(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          } else {
                            return ListView.builder(
                              itemCount: profileList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                final int count = profileList.length > 10
                                    ? 10
                                    : profileList.length;
                                final Animation<double> animation =
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                        CurvedAnimation(
                                            parent: animationController,
                                            curve: Interval(
                                                (1 / count) * index, 1.0,
                                                curve: Curves.fastOutSlowIn)));
                                animationController.forward();

                                return ProfileInteresListView(
                                  listData: profileList[index],
                                  animation: animation,
                                  animationController: animationController,
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
        )));
  }

  void onPressed() {}
}

class ProfileInteresListView extends StatelessWidget {
  const ProfileInteresListView({
    Key? key,
    required this.listData,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final InteresList listData;
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
                                            listData.title,
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
