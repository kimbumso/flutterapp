import 'package:flutter/material.dart';
import 'package:flutter_app/config/palette.dart';
import 'package:flutter_app/screens/home/view/view.dart';
import 'package:flutter_app/screens/home/widgets/widgets.dart';

class NavigationHomeScreen extends StatefulWidget {
  final String currentUserId;
  NavigationHomeScreen({Key key, this.currentUserId}) : super(key: key);
  @override
  _NavigationHomeScreenState createState() =>
      _NavigationHomeScreenState(currentUserId: currentUserId);
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  _NavigationHomeScreenState({Key key, @required this.currentUserId});
  Widget screenView;
  DrawerIndex drawerIndex;
  final String currentUserId;
  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = LoginOKScreen(currentUserId: currentUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Palette.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = LoginOKScreen(currentUserId: currentUserId);
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = HelpScreen();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = FeedbackScreen();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = InviteFriend();
        });
      } else {
        //do in your way......
      }
    }
  }
}
