import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:debtmanagerv2/screens/summary.dart';

class signup extends StatefulWidget {
  static String id = 'signup';

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  void _showAlertMessage() {
    var alert = new AlertDialog(
      title: new Text('Error'),
      content:
          new Text('Username or Password error, or Account already exists'),
      actions: <Widget>[
        new TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text('OK')),
      ],
    );
    showDialog(
      context: context,
      builder: (AlertDialog) => alert,
    );
  }

  final _auth = FirebaseAuth.instance;

  String newemail;
  String newpwd;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('Sign Up with E-Mail'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Center(child: new Text('Create Account')),
            new Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Enter username'),
                      onChanged: (value) {
                        newemail = value;
                      },
                      validator: (username) {
                        if (username.isEmpty) {
                          return 'Enter username';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Enter password'),
                      obscureText: true,
                      onChanged: (value) {
                        newpwd = value;
                      },
                      validator: (password) {
                        if (password.isEmpty) {
                          return 'Please enter  password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        //
                        try {
                          final user =
                              await _auth.createUserWithEmailAndPassword(
                                  email: newemail.trim(),
                                  password: newpwd.trim());

                          if (user != null) {
                            Navigator.pushNamed(context, summary.id);
                          }
                        } catch (e) {
                          _showAlertMessage();
                        }
                        //
                      }
                    },
                    child: Text('Create Account'),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}
