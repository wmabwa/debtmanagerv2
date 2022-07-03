import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom2_card.dart';

User user;
DateTime recorddate2;

class topay extends StatefulWidget {
  static String id = 'topay';

  @override
  _topayState createState() => _topayState();
}

class _topayState extends State<topay> {
  DateTime _date = DateTime.now();
  final auth = FirebaseAuth.instance;

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

  @override
  Widget build(BuildContext context) {
    var _firestore = FirebaseFirestore.instance
        .collection('debtmanagerv2')
        .doc(user.uid)
        .collection('owed')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return StreamBuilder(
        stream: _firestore,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, int index) {
                return custom2_card(snapshot: snapshot.data, index: index);
              });
        });
  }
}
