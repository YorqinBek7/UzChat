import 'package:flutter/cupertino.dart';
import 'package:uzchat/screens/auth_screen/sign_in_screen.dart';
import 'package:uzchat/screens/auth_screen/sign_up_screen.dart';
import 'package:uzchat/screens/uzchat_group/uzchat_group.dart';
import 'package:uzchat/screens/profile_screen/profile_screen.dart';
import 'package:uzchat/screens/select_chat_screen/select_chat_screen.dart';
import 'package:uzchat/screens/users_list_screen/private_chat/private_chat_screen.dart';
import 'package:uzchat/screens/users_list_screen/users_list_screen.dart';
import 'package:uzchat/screens/splash_screen.dart';
import 'package:uzchat/utils/constanst/constants.dart';

class Routers {
  static final Routers instance = Routers._();
  factory Routers() => instance;
  Routers._();
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Constants.signInScreen:
        return CupertinoPageRoute(
          builder: (context) => SignInScreen(),
        );
      case Constants.signUpScreen:
        return CupertinoPageRoute(
          builder: (context) => SignUpScreen(),
        );
      case Constants.selectChatScreen:
        return CupertinoPageRoute(
          builder: (context) => SelectChatScreen(),
        );
      case Constants.groupChatScreen:
        return CupertinoPageRoute(
          builder: (context) => UzChatGroupScreen(),
        );
      case Constants.uzchatUsersScreen:
        return CupertinoPageRoute(
          builder: (context) => UsersListScreen(),
        );
      case Constants.profileScreen:
        return PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          pageBuilder: (context, animation, secondaryAnimation) =>
              ProfileScreen(),
        );
      case Constants.splashScreen:
        return CupertinoPageRoute(
          builder: (context) => SplashScreen(),
        );
      case Constants.privateChatScreen:
        return CupertinoPageRoute(
          builder: (context) => PrivateChatScreen(
            collectionName: settings.arguments as String,
          ),
        );
    }
  }
}
