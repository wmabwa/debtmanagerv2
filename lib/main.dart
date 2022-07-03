import 'package:debtmanagerv2/screens/login.dart';
import 'package:debtmanagerv2/screens/signup.dart';
import 'package:debtmanagerv2/screens/summary.dart';
import 'package:debtmanagerv2/screens/tobepaid.dart';
import 'package:debtmanagerv2/screens/topay.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/passwdreset.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp();
  runApp(new MaterialApp(
    title: 'Debt Manager Version 2',
    home: login(),
    debugShowCheckedModeBanner: false,

    routes:
    {
      login.id:(context)=>login(),
      signup.id:(context)=>signup(),
      summary.id:(context)=>summary(),
      pswdrst.id:(context)=>pswdrst(),
      topay.id:(context)=>topay(),
      tobepaid.id:(context)=>tobepaid()
    },
  ));
}