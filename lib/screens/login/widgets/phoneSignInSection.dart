import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final FirebaseAuth _auth = FirebaseAuth.instance;

class _PhoneSignInSection extends StatefulWidget {
  _PhoneSignInSection(this._scaffold);

  final ScaffoldState _scaffold;

  @override
  State<StatefulWidget> createState() => _PhoneSignInSectionState();
}

class _PhoneSignInSectionState extends State<_PhoneSignInSection> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _message = '';
  String _verificationId;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Card(
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 16),
                  child: const Text('Test sign in with phone number',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  alignment: Alignment.center,
                ),
                Text(
                    "Sign In with Phone Number on Web is currently unsupported")
              ],
            )),
      );
    }
    return Card(
      child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: const Text('Test sign in with phone number',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                alignment: Alignment.center,
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                    labelText: 'Phone number (+x xxx-xxx-xxxx)'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Phone number (+x xxx-xxx-xxxx)';
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  icon: Icons.contact_phone,
                  backgroundColor: Colors.deepOrangeAccent[700],
                  text: "Verify Number",
                  onPressed: () async {
                    _verifyPhoneNumber();
                  },
                ),
              ),
              TextField(
                controller: _smsController,
                decoration:
                    const InputDecoration(labelText: 'Verification code'),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                    icon: Icons.phone,
                    backgroundColor: Colors.deepOrangeAccent[400],
                    onPressed: () async {
                      _signInWithPhoneNumber();
                    },
                    text: 'Sign In'),
              ),
              Visibility(
                visible: _message == null ? false : true,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _message,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          )),
    );
  }

  // Example code of how to verify phone number
  void _verifyPhoneNumber() async {
    setState(() {
      _message = '';
    });

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      widget._scaffold.showSnackBar(SnackBar(
        content: Text(
            "Phone number automatically verified and user signed in: ${phoneAuthCredential}"),
      ));
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      widget._scaffold.showSnackBar(const SnackBar(
        content: Text('Please check your phone for the verification code.'),
      ));
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      widget._scaffold.showSnackBar(SnackBar(
        content: Text("Failed to Verify Phone Number: ${e}"),
      ));
    }
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;

      widget._scaffold.showSnackBar(SnackBar(
        content: Text("Successfully signed in UID: ${user.uid}"),
      ));
    } catch (e) {
      print(e);
      widget._scaffold.showSnackBar(SnackBar(
        content: Text("Failed to sign in"),
      ));
    }
  }
}
