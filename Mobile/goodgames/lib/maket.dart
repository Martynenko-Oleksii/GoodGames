import 'package:goodgames/global.dart';
import 'package:flutter/material.dart';
import 'package:goodgames/login/regist.dart';
import 'package:goodgames/profile/ProfileScreen.dart';

import '../../../home_screen.dart';
import '../../../main.dart';
import '../../../getdata.dart';
import '../apptheme.dart';
import 'competitions/competitions_list_page.dart';

class macetAddPage extends StatefulWidget {
  @override
  final User user;

  macetAddPage({Key? key, required this.user}) : super(key: key);

  _macetAddState createState() => _macetAddState();
}

class _macetAddState extends State<macetAddPage> {
  final TextEditingController titleControl = TextEditingController();
  final TextEditingController sportControl = TextEditingController();
  final TextEditingController agelimitControl = TextEditingController();
  final TextEditingController cityControl = TextEditingController();
  final TextEditingController streamControl = TextEditingController();
  bool isOpen = false;
  bool isPublic = false;
  final formKey = GlobalKey<FormState>();

  Sport dropdownValueSport = new Sport(
    id: 1,

    title: "Оберіть спорт",
    minCompetitorsCount: 0,
    hasTeam: false,

    minTeamsCount: 0,
    teamSize: 0,
    hasGrid: false,);


  DateTime selectedDatestart = DateTime.now();
  DateTime selectedDateend = DateTime.now();

  //List<Sport> sports = [];

  Future<void> _selectDatestart(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDatestart,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDatestart)
      setState(() {
        selectedDatestart = picked;
      });
  }

  Future<void> _selectDateend(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateend,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateend)
      setState(() {
        selectedDateend = picked;
      });
  }

  @override
  void initState() {
    //getDatahttp.getSports().then((value) => sports = value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white.withOpacity(0),
          centerTitle: true,
          elevation: 0.0,

          title: new Text(
            "Створення змагання",
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
        body: Center(
              child: new Stack(
                children: <Widget>[
                  new Container(
                    // alignment: Alignment(0.00, -0.50),
                    child: new ListView(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(height: 10,),
                        new Container(
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
                          child: Form(
                            key: formKey,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.only( top: 15.0 , bottom: 5 , left: 10, right: 10),
                                  child: new Container(
                                    // width: 275.0,
                                    child: new TextFormField(
                                      controller: titleControl,
                                      decoration: new InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        hintText: 'title',
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      /* validator: (value) {
                                    if (value!.isEmpty ||
                                        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                            .hasMatch(value)) {
                                      return "Enter Correct Email Address";
                                    } else {
                                      return null;
                                    }
                                  },*/
                                    ),
                                  ),
                                ),
                                new Row(
                                  children: [
                                    new Checkbox(
                                      checkColor: Colors.white,
                                      fillColor: MaterialStateProperty.resolveWith(
                                          getColor),
                                      value: isOpen,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isOpen = value!;
                                        });
                                      },
                                    ),
                                    new Container(
                                      // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                      padding: EdgeInsets.all(10.0),

                                      child: new Text(
                                        "isOpen",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.darkText,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // TODO
                                new Row(children: [
                                  new Container(
                                    padding: EdgeInsets.all(5.0),
                                    child: FutureBuilder(
                                      future: getDatahttp.getSports(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {

                                        if (!snapshot.hasData) {
                                          return const SizedBox();
                                        } else {

                                          return new Container(
                                            child: DropdownButton<Sport>(
                                              hint: Text(
                                                dropdownValueSport.title,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppTheme.darkText,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.green),
                                              underline: Container(
                                                height: 2,
                                                color: Colors.green,
                                              ),
                                              onChanged: (Sport? newValue) {
                                                setState(()
                                                {
                                                  dropdownValueSport = newValue!;
                                                });
                                              },
                                              //value: dropdownValueSport,
                                              items: snapshot.data
                                                  .map<DropdownMenuItem<Sport>>(
                                                      (Sport value) {
                                                    return DropdownMenuItem<Sport>(
                                                      value: value,
                                                      child: Text(
                                                        value.title,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: AppTheme.darkText,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  new Container(
                                    child: new Text(
                                      "sport",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ]),

                                new Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: new Container(
                                    // width: 275.0,
                                    child: new TextFormField(
                                      controller: agelimitControl,
                                      decoration: new InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        hintText: 'ageLimit',
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      /* validator: (value) {
                                    if (value!.isEmpty ||
                                        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                            .hasMatch(value)) {
                                      return "Enter Correct Email Address";
                                    } else {
                                      return null;
                                    }
                                  },*/
                                    ),
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: new Container(
                                    // width: 275.0,
                                    child: new TextFormField(
                                      controller: cityControl,
                                      decoration: new InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        hintText: 'city',
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      /* validator: (value) {
                                    if (value!.isEmpty ||
                                        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                            .hasMatch(value)) {
                                      return "Enter Correct Email Address";
                                    } else {
                                      return null;
                                    }
                                  },*/
                                    ),
                                  ),
                                ),
                                Container(
                                  //margin: EdgeInsets.only(top: 5.0,bottom: 5 , left: 15 , right: 15),
                                  padding:EdgeInsets.only(top: 5.0,bottom: 5 , left: 15 , right: 15),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.white, width: 3)
                                      ),
                                      onPressed: () => _selectDatestart(context),
                                      child: Text('Select startDate'),
                                    ),),
                                    Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        "${selectedDatestart.toLocal()}"
                                            .split(' ')[0],
                                      ),
                                    ),
                                  ]),
                                ),
                                Container(
                                  padding:EdgeInsets.only(top: 5.0,bottom: 5 , left: 15 , right: 15),
                                  child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                                side: BorderSide(color: Colors.white, width: 3)
                                            ),
                                            onPressed: () => _selectDatestart(context),
                                            child: Text('Select endDate'),
                                          ),),
                                    Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        "${selectedDateend.toLocal()}"
                                            .split(' ')[0],
                                      ),
                                    ),
                                  ]),
                                ),
                                new Row(
                                  children: [
                                    new Checkbox(
                                      checkColor: Colors.white,
                                      fillColor: MaterialStateProperty.resolveWith(
                                          getColor),
                                      value: isPublic,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isPublic = value!;
                                        });
                                      },
                                    ),
                                    new Container(
                                      // margin: const EdgeInsets.symmetric(vertical: 0.0),
                                      padding: EdgeInsets.all(10.0),

                                      child: new Text(
                                        "isPublic",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.darkText,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        new Container(
                          //margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: new RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: new Text("Create"),
                            onPressed: () {
                              getDatahttp
                                  .postNewCompetition(
                                  titleControl.text,
                                  isOpen,
                                  // sportId TODO,
                                  //1,
                                  dropdownValueSport.id,
                                  agelimitControl.text,
                                  cityControl.text,
                                  selectedDatestart,
                                  selectedDateend,
                                  isPublic,
                                  widget.user.id!)
                                  .then((value) => {
                                if (value.title == titleControl.text)
                                  {
                                    print(value),
                                    Navigator.push<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            CompetitionsScreen(
                                                user: widget.user),
                                      ),
                                    )
                                  }
                              });
                            },
                            color: Colors.pinkAccent.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.green;
  }

  void onPressed() {}

  @override
  void dispose() {
    super.dispose();
  }
}


