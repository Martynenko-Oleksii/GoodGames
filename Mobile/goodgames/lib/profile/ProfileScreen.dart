import 'package:goodgames/competitions/competitions_list_page.dart';
import 'package:goodgames/getdata.dart';
import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/login.dart';
import 'package:goodgames/login/regist.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../home_screen.dart';
import '../../../main.dart';
import '../apptheme.dart';
import '../maket.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  List<Sport> profileList = [];
  late AnimationController animationController;
  bool multiple = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();

    getDatahttp.getFavouriteSports(widget.user.id!).then((value) => profileList = value);
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
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,

        title: new Text(
          "Профіль користувача",
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
          new Stack(
            children: <Widget>[
              new Container(
                // alignment: Alignment(0.00, -0.50),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(left: 15.0),
                      // height: 190.0,
                      //  width: 300.0,
                      // alignment: Alignment(0.00, -0.50),
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
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          //margin: const EdgeInsets.all(7.0),
                          //  padding: EdgeInsets.symmetric(horizontal: 10.0),

                          child: CircleAvatar(
                            radius: 30,
                            //encikllListd[index].imagePath,
                            backgroundImage: NetworkImage( "https://cdn.discordapp.com/attachments/839078982598131712/899743277576749126/avatar1.jpg",),
                            child: Container(
                              margin: EdgeInsets.only(left: 33.0, top: 33),
                              child:  IconButton(
                                icon: const Icon(Icons.edit_outlined , color: Colors.black,),
                                onPressed: () {
                                },
                              ),
                            ),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.only(left: 15.0),
                          child:
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: new Container(
                                  width: 200,
                                  //  height:50,
                                  child: new Text(
                                    widget.user.login!,
                                    style: TextStyle(
                                      fontSize: 20,
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
                                    // height: 80,
                                    child: new Text(
                                      widget.user.email!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.only(right: 15 , left: 25),
                          child:
                          IconButton(
                            icon: const Icon(Icons.logout),
                            onPressed: () {
                              Navigator.push<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) => LoginPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ]),
                    ),
                    new Padding(
                        padding: EdgeInsets.only(left: 15.0 , right: 15 , top: 5 , bottom: 5),
                        child: new Divider(
                          height: 3,
                          color: Colors.black,
                        )
                    ),

                    new Container(
                      //  margin: const EdgeInsets.only( top: 5 ),
                      // width: 300,
                      //height: 30,
                      child:
                      /* new Text(
                          "Статус підписки:",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),*/

                      new Container(
                        child: sub(),
                      ),


                    ),
                    new Padding(
                        padding: EdgeInsets.only(left: 15.0 , right: 15 , top: 5),
                        child: new Divider(
                          height: 3,
                          color: Colors.black,
                        )
                    ),
                    /*new Container(
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
                    ),*/
                    new Container(
                      padding: EdgeInsets.only(left: 10.0),
                      //margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: new RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: new Text("Мої змагання"),
                        onPressed: () {
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => CompetitionsScreen(user: widget.user),
                            ),
                          );
                        },
                        color: Colors.redAccent.shade200,
                      ),
                    ),
                    new Container(
                      // margin: const EdgeInsets.symmetric(vertical: 0.0),
                      padding: EdgeInsets.only(left: 10.0),

                      child: new Text("Відстежуване:"),
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
        ],),);
  }

  Widget sub(){
    if( widget.user.subscription == null){
      return new Container(
          child: Column(
            children: [

              new Image.network(
                "https://cdn.discordapp.com/attachments/839078982598131712/905484434369826876/unknown.png",
              ),
              // margin: const EdgeInsets.only(left: 30.0),
              //  padding: EdgeInsets.only(left: 10.0),
              // color: Colors.white60,
              new RaisedButton(
                color: Colors.white70,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    side: BorderSide(color: Colors.black38, width: 1)
                ),
                child: new Text("Оформити підписку!",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: (){
                  //  widget.user.subscription = "123";
                  getDatahttp.subscribe(widget.user.id!).then((value) =>
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              ProfileScreen(user: widget.user),
                        ),
                      ));
                },
              ), ],
          )
      );
    }else{
      return  new Text(
        "діє до: " +

            DateFormat('yyyy-MM-dd – kk:mm').format( widget.user.subscription!.end!)

            + " lvl: " +   widget.user.subscription!.lvl.toString(),
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.darkText,
          fontWeight: FontWeight.w700,
        ),
      );
    }
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

  final Sport listData;
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