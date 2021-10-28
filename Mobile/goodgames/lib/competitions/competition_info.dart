import 'package:goodgames/getdata.dart';
import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/regist.dart';
import 'package:flutter/cupertino.dart';

import '../../../home_screen.dart';
import '../../../main.dart';
import '../apptheme.dart';
import '../getdata.dart';

class CompetitionInfoScreen extends StatefulWidget {
  final Competition comp;

  @override
  _CompetitionState createState() => _CompetitionState();

  CompetitionInfoScreen({Key? key, required this.comp}) : super(key: key);
}

class _CompetitionState extends State<CompetitionInfoScreen>
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
        backgroundColor: Colors.orange.shade200,
        centerTitle: true,
        elevation: 0.0,
        title: new Text(
          "Competition",
          textScaleFactor: 1.3,
        ),
      ),
      body: Center(
        child: Container(
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
                                    new Row(
                                      children: [
                                        new Container(
                                          // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                          padding: EdgeInsets.all(10.0),

                                          child: new Text(
                                            snapshot.data.title,
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
                                        snapshot.data.sport.title,
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
                                        snapshot.data.state,
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
                                                builder: (BuildContext
                                                        context) =>
                                                    _buildPopupDialog(context),
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
                                                builder:
                                                    (BuildContext context) =>
                                                        RegistPage(),
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
                                        borderRadius:
                                            BorderRadius.circular(18.0),
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
                                        borderRadius:
                                            BorderRadius.circular(18.0),
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
                            new Container(
                              height: 400,
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
                                        "list of participants",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.darkText,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    new Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              500,
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
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final int count = snapshot
                                                            .data
                                                            .competitors
                                                            .length >
                                                        10
                                                    ? 10
                                                    : snapshot.data.competitors
                                                        .length;
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
                                        "tournament grid",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.darkText,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    new Container(
                                      // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                      padding: EdgeInsets.only(left: 10.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController emailsendControl = TextEditingController();
  final formKeyinvite = GlobalKey<FormState>();

  Widget _buildPopupDialog(BuildContext context) {
    return Form(
      key: formKeyinvite,
      child: new AlertDialog(
        title: const Text('Send invition'),
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
                getDatahttp.postEmail(emailsendControl.text).then((value) =>
                    Navigator.of(context).pop()
              );
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
