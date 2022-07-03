import 'package:debtmanagerv2/screens/login.dart';
import 'package:debtmanagerv2/screens/tobepaid.dart';
import 'package:debtmanagerv2/screens/topay.dart';
import 'package:debtmanagerv2/screens/summary1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User user;
var borrowerinputcontroller = new TextEditingController();
var paybackinputcontroller = new TextEditingController();
var purposeinputcontroller = new TextEditingController();
var amountinputcontroller = new TextEditingController();

class summary extends StatefulWidget {
  static String id = 'summary';

  @override
  _summaryState createState() => _summaryState();
}

class _summaryState extends State<summary> {


  int sharedValue = 0;
  final Map<int, Widget> logoWidgets = const <int, Widget>{
    0: Text('  Summary  '),
    1: Text('   To Pay  '),
    2: Text(' To be Paid  '),
  };

  final Map<int, Widget> content = <int, Widget>{
    0: summary1(),
    1: topay(),
    2: tobepaid(),
  };

  Future<void> getCurrentUsers() async {
    User userdata = await FirebaseAuth.instance.currentUser;
    setState(() {
      user = userdata;
    });
  }



  @override
  Widget build(BuildContext context) {


    void initState() {
      super.initState();
      getCurrentUsers();
    }

    setState(() {
      getCurrentUsers();
    });




    return Scaffold(
      appBar: new AppBar(
        title: new Text('Debt Manager v2'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Welcome ${user.email}'),
                //Cupertino switch

                CupertinoSegmentedControl<int>(
                  children: logoWidgets,
                  onValueChanged: (int val) {
                    setState(() {
                      sharedValue = val;
                    });
                  },
                  groupValue: sharedValue,
                ),

                //end of switch

                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: new Row(
                    children: [
                      Expanded(child: content[sharedValue]),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),

      //

      //

      //start
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Debt Manager V2',
                style: new TextStyle(color: Colors.white, fontSize: 24.0),
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.blueGrey,
            ),
            ListTile(
              title: Text('Add To be paid record'),
              onTap: () {
                Navigator.pop(_showDialog(context));
                Navigator.pop(context);
              },
              //Navigator.pop(context),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.blueGrey,
            ),
            ListTile(
              title: Text('Add To Pay Record'),
              onTap: () {
                Navigator.pop(_showDialog2(
                    context)); //change record to add data to other db
                Navigator.pop(context);
              },
              //Navigator.pop(context),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.blueGrey,
            ),
            ListTile(
              title: Text(' Log out'),
              onTap: () {
                Navigator.pushNamed(context, login.id);
              },
            ),
            Divider(
              thickness: 1.0,
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),

      //end
    );

  }

  _showDialog(BuildContext context) async {
    //start of trial
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                //start
                Text('Add to be paid Data.'),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(labelText: 'Lending to'),
                    controller: borrowerinputcontroller,
                  ),
                ),
                Expanded(
                  child: new Row(children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: () => {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2025))
                              .then((date) {
                            setState(() {
                              recorddate = date;
                            });
                          })
                        },
                        child: Text('Due Date'),
                        autofocus: true,
                      ),
                    ),
                    Text(recorddate.toString()),
                  ]),
                ),

                Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(labelText: 'Purpose'),
                    controller: purposeinputcontroller,
                  ),
                ),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: amountinputcontroller,
                    keyboardType: TextInputType.number,
                  ),
                ),

                TextButton(
                    onPressed: () {
                      borrowerinputcontroller.clear();
                      paybackinputcontroller.clear();
                      purposeinputcontroller.clear();
                      amountinputcontroller.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      if (borrowerinputcontroller.text.isNotEmpty &&
                          purposeinputcontroller.text.isNotEmpty &&
                          amountinputcontroller.text.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection('debtmanagerv2')
                            .doc(user.uid)
                            .collection('debts')
                            .add({
                          'Borrower': borrowerinputcontroller.text,
                          'Payback_Date': recorddate.toString(),
                          'Purpose': purposeinputcontroller.text,
                          'Amount': double.parse(amountinputcontroller.text),
                          "UserID": user.uid,
                          'timestamp': new DateTime.now(),
                        }).then((response) {
                          Navigator.pop(context);
                          borrowerinputcontroller.clear();
                          paybackinputcontroller.clear();
                          purposeinputcontroller.clear();
                        }).catchError((error) => print(error));
                      }
                    },
                    child: Text('Save')),
              ]);
            },
          ),
        );
      },
    );
    //end of trial
  }

  _showDialog2(BuildContext context) async {
    //start of trial
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                //start
                Text('Add To Pay Data.'),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(labelText: 'Lending from'),
                    controller: borrowerinputcontroller,
                  ),
                ),
                Expanded(
                  child: new Row(children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: () => {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2025))
                              .then((date) {
                            setState(() {
                              recorddate = date;
                            });
                          })
                        },
                        child: Text('Pay by'),
                        autofocus: true,
                      ),
                    ),
                    Text(recorddate.toString()),
                  ]),
                ),

                Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(labelText: 'Purpose'),
                    controller: purposeinputcontroller,
                  ),
                ),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: amountinputcontroller,
                    keyboardType: TextInputType.number,
                  ),
                ),

                TextButton(
                    onPressed: () {
                      borrowerinputcontroller.clear();
                      paybackinputcontroller.clear();
                      purposeinputcontroller.clear();
                      amountinputcontroller.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      if (borrowerinputcontroller.text.isNotEmpty &&
                          purposeinputcontroller.text.isNotEmpty &&
                          amountinputcontroller.text.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection('debtmanagerv2')
                            .doc(user.uid)
                            .collection('owed')
                            .add({
                          'Borrower': borrowerinputcontroller.text,
                          'Payback_Date': recorddate.toString(),
                          'Purpose': purposeinputcontroller.text,
                          'Amount': double.parse(amountinputcontroller.text),
                          "UserID": user.uid,
                          'timestamp': new DateTime.now(),
                        }).then((response) {
                          Navigator.pop(context);
                          borrowerinputcontroller.clear();
                          paybackinputcontroller.clear();
                          purposeinputcontroller.clear();
                        }).catchError((error) => print(error));
                      }
                    },
                    child: Text('Save')),
              ]);
            },
          ),
        );
      },
    );
    //end of trial
  }

}





//
