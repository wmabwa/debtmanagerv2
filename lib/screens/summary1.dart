import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

User user;

class summary1 extends StatefulWidget {
  final auth = FirebaseAuth.instance;

  static String id = 'summary1';

  @override
  _summary1State createState() => _summary1State();
}

class _summary1State extends State<summary1> {
  @override
  Future<void> getCurrentUsers() async {
    User userdata = await FirebaseAuth.instance.currentUser;
    setState(() {
      user = userdata;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUsers();
  }

  Widget build(BuildContext context) {
    var _firestore = FirebaseFirestore.instance
        .collection('debtmanagerv2')
        .doc(user.uid)
        .collection('debts')
        .orderBy('timestamp', descending: true)
        .snapshots();

    var _firestore2 = FirebaseFirestore.instance
        .collection('debtmanagerv2')
        .doc(user.uid)
        .collection('owed')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Container(
        child: new Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream: _firestore,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 1, // snapshot.data.docs.length,
                    itemBuilder: (context, int index) {
                      return tobepaidsum(snapshot: snapshot.data, index: 1);
                    });
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream: _firestore2,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 1, //snapshot.data.docs.length,
                    itemBuilder: (context, int index) {
                      return topaysum(snapshot: snapshot.data, index: 1);
                    });
              }),
        ),
        new Text(''),
      ],
    ));
  }
}

class topaysum extends StatelessWidget {
  static String id = 'topaysum';

  final QuerySnapshot snapshot;
  final int index;

  const topaysum({Key key, this.snapshot, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ds2 = snapshot.docs;
    double sum2 = 0.0;

    for (int k = 0; k < ds2.length; k++) sum2 += (ds2[k]['Amount']).toDouble();
    String total2 = sum2.toStringAsFixed(2);
    return Row(children: [
      Text(
        "To Pay Total    : $total2",
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    ]);
  }
}

class tobepaidsum extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;

  const tobepaidsum({Key key, this.snapshot, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sum = 0.0;
    var ds = snapshot.docs;
    for (int i = 0; i < ds.length; i++) sum += (ds[i]['Amount']).toDouble();
    String total = sum.toStringAsFixed(2);

    return Row(children: [
      Text("To be Paid       : $total",
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          )),
    ]);
  }
}
