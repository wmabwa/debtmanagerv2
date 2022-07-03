import 'package:debtmanagerv2/screens/signup.dart';
import 'package:debtmanagerv2/screens/summary.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/summary.dart';
import '../screens/passwdreset.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';


class login extends StatefulWidget {
  static String id = 'login';

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    if (credential != null) {
      Navigator.pushNamed(context, summary.id);
    }
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }



  void _showAlertMessage() {
    var alert = new AlertDialog(
      title: new Text('Error'),
      content: new Text('Username or Password error'),
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
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await FirebaseAuth.instance.app;

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  String email;
  String pwd;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: new Scaffold(
            body: ListView(children: [
      new Container(
          child: new Column(
        children: [
          SizedBox(
            height: 100.0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Image.asset(
              'images/logo.png',
            ),
          ),
          new Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Enter username'),
                    onChanged: (value) {
                      email = value;
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
                      pwd = value;
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        //
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email.trim(), password: pwd.trim());
                          if (user != null) {
                            Navigator.pushNamed(context, summary.id);
                          }
                        } catch (e) {
                          _showAlertMessage();
                        }
                      }
                    },
                    child: Container(
                      height: 50.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        shadowColor: Colors.blueGrey,
                        color: Colors.blueGrey,
                        elevation: 7.0,
                        child: Center(
                            child: Text(
                          'login',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Trueno'),
                        )),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
              ])),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text('Sign Up:'),
              new Text('|'),
              new TextButton(
                  onPressed: () => {Navigator.pushNamed(context, signup.id)},
                  child: new Text('E-Mail')),
              new Text('|'),
              new TextButton(
                  onPressed: () async {
                    final fb = await FacebookLogin();

// Log in
                    final res = await fb.logIn(permissions: [
                      FacebookPermission.publicProfile,
                      FacebookPermission.email,
                    ]);

// Check result status
                    switch (res.status) {
                      case FacebookLoginStatus.success:
// Logged in

// Send access token to server for validation and auth
                        final FacebookAccessToken accessToken = res.accessToken;
                       // print('Access token: ${accessToken.token}');
                        final result = await FirebaseAuth.instance
                            .signInWithCredential(
                                FacebookAuthProvider.credential(
                                    accessToken.token));

// Get profile data
                        final profile = await fb.getUserProfile();
                        print(
                            'Hello, ${profile.name}! You ID: ${profile.userId}');

// Get user profile image url
                        final imageUrl =
                            await fb.getProfileImageUrl(width: 100);
                        print('Your profile image: $imageUrl');

// Get email (since we request email permission)
                        final email = await fb.getUserEmail();
// But user can decline permission
                        if (email != null)
                          Navigator.pushNamed(context, summary.id);
                        print('And your email is $email');

                        break;
                      case FacebookLoginStatus.cancel:
// User cancel log in
                        break;
                      case FacebookLoginStatus.error:
// Log in failed
                        print('Error while log in: ${res.error}');
                        break;
                    }

                    //end of trial
                  },
                  child: new Text('Facebook')),
              new Text('|'),
              new TextButton(
                  onPressed: () {
                    //

                    signInWithGoogle();
                  },
                  child: new Text('Google')),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new TextButton(
                  onPressed: () => {Navigator.pushNamed(context, pswdrst.id)},
                  child: new Text('Forgot Password')),
              new Text('|'),
              new TextButton(
                  onPressed: () => {
                    _launchURL(),

                  }, child: new Text('Privacy Policy')),
            ],
          ),
        ],
      )
          //alignment: Alignment.topCenter,

          )
    ])));
  }
}

_launchURL() async {
  const url = 'http://techpact.co.ke/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
