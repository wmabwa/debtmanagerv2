import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtmanagerv2/screens/topay.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class custom2_card extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;

  const custom2_card({Key key, this.snapshot, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var docID = snapshot.docs[index].id;

    TextEditingController borrowerinputcontroller = new TextEditingController(
        text: snapshot.docs[index].data()['Borrower']);

    TextEditingController paybackinputcontroller = new TextEditingController(
        text: snapshot.docs[index].data()['Payback_Date']);
    TextEditingController purposeinputcontroller =
        new TextEditingController(text: snapshot.docs[index].data()['Purpose']);
    TextEditingController amountinputcontroller = new TextEditingController(
        text: snapshot.docs[index].data()['Amount'].toString());

    return Container(
        child: new Column(
      children: [
        Card(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                  'Borrowed from: ${snapshot.docs[index].data()['Borrower']}'),
              new Text(
                  'Purpose given :${snapshot.docs[index].data()['Purpose']}'),
              new Text(
                'Amount :${snapshot.docs[index].data()['Amount'].toStringAsFixed(2)}',
                style: new TextStyle(color: Colors.red),
              ),
              new Text(
                  'Expected Payback date :${snapshot.docs[index].data()['Payback_Date']}'),
              new Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: 2.0,
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.edit),
                      onPressed: () async {

                        await showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[

                                        Text('Update data: Fill out the form.'),

                                        Expanded(
                                          child: TextField(
                                              autofocus: true,
                                              autocorrect: true,
                                              decoration: InputDecoration(
                                                  labelText: 'Lending to'),
                                              controller:
                                                  borrowerinputcontroller),
                                        ),

                                        Expanded(
                                          child: new Row(children: <Widget>[
                                            TextButton(
                                              onPressed: () => {
                                                showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2020),
                                                        lastDate:
                                                            DateTime(2025))
                                                    .then((date) {
                                                  setState(() {
                                                    recorddate2 = date;
                                                  });
                                                })
                                              },
                                              child: Text('Due Date'),
                                              autofocus: true,
                                            ),
                                            Text(recorddate2.toString()),
                                          ]),
                                        ),

                                        Expanded(
                                          child: TextField(
                                            autofocus: true,
                                            autocorrect: true,
                                            decoration: InputDecoration(
                                                labelText: 'Purpose'),
                                            controller: purposeinputcontroller,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            autofocus: true,
                                            autocorrect: true,
                                            decoration: InputDecoration(
                                                labelText: 'Amount'),
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
                                              if (borrowerinputcontroller
                                                      .text.isNotEmpty &&
                                                  purposeinputcontroller
                                                      .text.isNotEmpty &&
                                                  amountinputcontroller
                                                      .text.isNotEmpty) {
                                                FirebaseFirestore.instance
                                                    .collection('debtmanagerv2')
                                                    .doc(user.uid)
                                                    .collection('owed')
                                                    .doc(docID)
                                                    .set({
                                                  'Borrower':
                                                      borrowerinputcontroller
                                                          .text,
                                                  'Payback_Date':
                                                      recorddate2.toString(),
                                                  'Purpose':
                                                      purposeinputcontroller
                                                          .text,
                                                  'Amount': double.parse(
                                                      amountinputcontroller
                                                          .text),
                                                  "UserID": user.uid,
                                                  'timestamp':
                                                      new DateTime.now(),
                                                }).then((response) {
                                                  Navigator.pop(context);
                                                  borrowerinputcontroller
                                                      .clear();
                                                  paybackinputcontroller
                                                      .clear();
                                                  purposeinputcontroller
                                                      .clear();
                                                }).catchError((error) =>
                                                        print(error));
                                              }
                                            },
                                            child: Text('Save')),
                                      ]);
                                },
                              ),
                            );
                          },
                        );


                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,

                                    children: <Widget>[
                                      Text(
                                        'Confirm Record Deletion',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20.0,
                                            color: Colors.red),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                              'Borrower : ${snapshot.docs[index].data()['Borrower']}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                              'Amount : ${snapshot.docs[index].data()['Amount']}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                              'Purpose : ${snapshot.docs[index].data()['Purpose']}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                    ],
                                  ),
                                  contentPadding: EdgeInsets.all(20.0),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('debtmanagerv2')
                                              .doc(user.uid)
                                              .collection('owed')
                                              .doc(docID)
                                              .delete();
                                          Navigator.pop(context);
                                        },
                                        child: Text('Confirm Delete')),
                                  ],
                                );
                              });
                        })
                  ]),
            ],
          ),
        ),
        Divider(
          thickness: 1.0,
          color: Colors.blueGrey,
        )
      ],
    )



        );
  }
}
