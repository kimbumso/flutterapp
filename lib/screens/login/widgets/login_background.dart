import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/palette.dart';
import 'package:flutter_app/screens/chat/widgets/widgets.dart';
import 'package:flutter_app/screens/home/view/view.dart';
import 'package:flutter_app/screens/login/view/view.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()..color = Colors.blue;
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.1), size.height * 0.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class LogoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: FittedBox(
          fit: BoxFit.contain,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/login_logo.jpg'),
          ),
        ),
      ),
    );
  }
}

class AuthTypeSelector extends StatelessWidget {
  // Navigates to a new page
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
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
  }
}

class AuthSignInPageTypeSelector extends StatelessWidget {
  // Navigates to a new page
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignInButtonBuilder(
        icon: Icons.verified_user,
        backgroundColor: Colors.orange,
        text: 'Sign In',
        onPressed: () => _pushPage(context, SignInPage()),
      ),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
    );
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
  }
}

class AuthSignInGoogleTypeSelector extends StatefulWidget {
  AuthSignInGoogleTypeSelector({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AuthSignInGoogleTypeSelectorState();
}

class AuthSignInGoogleTypeSelectorState
    extends State<AuthSignInGoogleTypeSelector> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  User currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                // ChatHomeScreen(currentUserId: prefs.getString('id'))),
                LoginOKScreen(currentUserId: prefs.getString('id'))),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        // Update data to server if new user
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoURL,
          'id': firebaseUser.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoURL);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0].data()['id']);
        await prefs.setString('nickname', documents[0].data()['nickname']);
        await prefs.setString('photoUrl', documents[0].data()['photoUrl']);
        await prefs.setString('aboutMe', documents[0].data()['aboutMe']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // ChatHomeScreen(currentUserId: firebaseUser.uid)));
                  NavigationHomeScreen(currentUserId: firebaseUser.uid)));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  onPressed: handleSignIn,
                  // child: Text(
                  //   'SIGN IN WITH GOOGLE',
                  //   style: TextStyle(fontSize: 16.0),
                  // ),
                  text: 'SIGN IN WITH GOOGLE',
                  icon: Icons.verified_user,
                  backgroundColor: Palette.redColor,
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                ),
              ),

              // Loading
              Positioned(
                child: isLoading ? const Loading() : Container(),
              ),
            ],
          )),
    );
  }
}
