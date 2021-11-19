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
import 'competitions_list_page.dart';


class AllCompetitionsStat extends StatefulWidget {
  final User user;
  final bool isfavorit;
  AllCompetitionsStat({Key? key, required this.user,required this.isfavorit }) : super(key: key);

  @override
  _AllCompetitionsState createState() => _AllCompetitionsState();
}

class _AllCompetitionsState extends State<AllCompetitionsStat>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool multiple = false;
  final ScrollController _scrollController = ScrollController();
  MaterialColor stColor = Colors.amber ;
  int currentIndex = 2;
  String searchString = "";


  @override
  void initState() {
    if(widget.isfavorit){
      stColor = Colors.amber;
    }else{
      stColor = Colors.grey;
    }
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


        title:new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              new Text(
                "Список змагань",
                textScaleFactor: 1.3,
              ),
              new Container(
                margin: EdgeInsets.only(right: 15 , left: 15),
                child:
                IconButton(
                  icon: const Icon(Icons.star),
                  color: stColor,
                  onPressed: () {
                    if(widget.isfavorit){
                      setState(() {
                        stColor = Colors.grey;
                      });
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AllCompetitionsStat(user: widget.user , isfavorit: false,)));
                    }else{
                      setState(() {
                        stColor = Colors.amber;
                      });
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AllCompetitionsStat(user: widget.user , isfavorit: true,)));}
                  },
                ),
              ),
            ]),
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchString = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: getcomplist(widget.isfavorit , widget.user),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.length,
                      itemBuilder:
                      /*  (BuildContext context, int index) {
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
                        );
                      },*/
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
                        return snapshot.data![index].title
                            .toLowerCase()
                            .contains(searchString)
                            ? CompetitionListView(
                          listData: snapshot.data[index],
                          user: widget.user,
                          animation: animation,
                          animationController: animationController,
                        )
                            : Container();
                      },
                      /*   (BuildContext context, int index) {
                        return snapshot.data![index].title
                            .toLowerCase()
                            .contains(searchString)
                            ? ListTile(
                          title: Text('${snapshot.data?[index].title}'),
                        )
                            : Container();
                      },*/
                      separatorBuilder: (BuildContext context, int index) {
                        return snapshot.data![index].title
                            .toLowerCase()
                            .contains(searchString)
                            ? Divider()
                            : Container();
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong :('));
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {}
          if (index == 1) {}
          if (index == 3) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CompetitionsScreen(user: widget.user)));
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
  static  Future<List<Competition>> getcomplist(bool isfavorite , User u){
    if(isfavorite){
      return getDatahttp.getFavouriteCompetitions(u.id!);
    }else{
      return getDatahttp.getAllCompetitions();
    }
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