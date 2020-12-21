import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final FirebaseAuth _auth = FirebaseAuth.instance;

class _EmailLinkSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailLinkSignInSectionState();
}

class _EmailLinkSignInSectionState extends State<_EmailLinkSignInSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  String _userEmail = '';

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Card(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text('Test sign in with email and link',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                alignment: Alignment.center,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (String value) {
                  if (value.isEmpty) return 'Please enter your email.';
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  icon: Icons.insert_link,
                  text: "Sign In",
                  backgroundColor: Colors.blueGrey[700],
                  onPressed: () async {
                    await _signInWithEmailAndLink();
                  },
                ),
              ),
            ],
          ),
        )));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndLink() async {
    try {
      _userEmail = _emailController.text;

      await _auth.sendSignInLinkToEmail(
          email: _userEmail,
          actionCodeSettings: ActionCodeSettings(
              url:
                  'https://react-native-firebase-testing.firebaseapp.com/emailSignin',
              handleCodeInApp: true,
              iOSBundleId: 'io.flutter.plugins.firebaseAuthExample',
              androidPackageName: 'io.flutter.plugins.firebaseauthexample'));

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("An email has been sent to ${_userEmail}"),
      ));
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Sending email failed"),
      ));
    }
  }
}
