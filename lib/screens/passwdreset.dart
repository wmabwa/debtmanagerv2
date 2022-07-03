import 'package:debtmanagerv2/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class pswdrst extends StatefulWidget {
  static String id = 'pswdrst';

  @override
  _pswdrstState createState() => _pswdrstState();
}

class _pswdrstState extends State<pswdrst> {
  void _showAlertMessage() {
    var alert = new AlertDialog(
      title: new Text('Error'),
      content: new Text('Mail doesnt exist'),
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
  String rstemail;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Reset password'),
          centerTitle: true,
        ),
        body: new Container(
          child: new Center(
            child: new Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                new Text('Check mail for reset link'),
                new Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Enter E-Mail'),
                          onChanged: (value) {
                            rstemail = value;
                          },
                          validator: (username) {
                            if (username.isEmpty) {
                              return 'Enter Email used';
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
                              final user = await _auth
                                  .sendPasswordResetEmail(
                                      email: rstemail.trim())
                                  .then((value) =>
                                      {Navigator.pushNamed(context, login.id)});
                            } catch (e) {
                              _showAlertMessage();
                            }
                            //
                          }
                        },
                        child: Text('Reset Password'),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
