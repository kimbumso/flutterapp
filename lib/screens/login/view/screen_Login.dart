import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/palette.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_app/screens/login/view/register_page.dart';
import 'package:flutter_app/screens/login/view/signin_page.dart';
import 'package:flutter_app/screens/chat/chat.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseApp secondaryApp = Firebase.app('Flutter_App');

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('세력을 찾아라!'),
        backgroundColor: Palette.themeColor,
      ),
      body: AuthTypeSelector(),
    );
  }
}

/// Provides a UI to select a authentication type page
class AuthTypeSelector extends StatelessWidget {
  // Navigates to a new page
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login App"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: SignInButtonBuilder(
              icon: Icons.person_add,
              backgroundColor: Colors.indigo,
              text: 'Registration',
              onPressed: () => _pushPage(context, RegisterPage()),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          Container(
            child: SignInButtonBuilder(
              icon: Icons.verified_user,
              backgroundColor: Colors.orange,
              text: 'Sign In',
              onPressed: () => _pushPage(context, SignInPage()),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          // Container(
          //   child: SignInButtonBuilder(
          //     icon: Icons.verified_user,
          //     backgroundColor: Colors.red,
          //     text: 'Chat APP',
          //     onPressed: () =>
          //         _pushPage(context, ChatLoginScreen(title: 'CHAT DEMO')),
          //   ),
          //   padding: const EdgeInsets.all(16),
          //   alignment: Alignment.center,
          // ),
        ],
      ),
    );
  }
}
