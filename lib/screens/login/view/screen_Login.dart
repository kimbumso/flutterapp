import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/palette.dart';
import 'package:flutter_app/screens/login/widgets/widgets.dart';
import 'package:flutter_app/screens/chat/chat.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseApp secondaryApp = Firebase.app('Flutter_App');

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: size,
            painter: LoginBackground(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              LogoImage(),
              Text('로그인 화면'),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64),
                      ),
                      elevation: 24,
                      child: Container(
                        width: size.width * 0.8,
                        height: size.height * 0.25,
                        color: Palette.lightBlue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: AuthTypeSelector(),
                  ),
                  Container(),
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: AuthSignInGoogleTypeSelector(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Provides a UI to select a authentication type page
//
