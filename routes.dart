import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/screens/login/login_screen.dart';
import 'package:smart_admin_dashboard/screens/home/home_screen.dart';

class Routes {
  Routes._();

  //static variables
  static const String login = '/login';
  static const String home = '/home';
  static const String product = '/product';

  static final routes = <String, WidgetBuilder>{
    // splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => Login(
          title: '',
        ),
    home: (BuildContext context) => HomeScreen(activeIndex: 0,),
    product: (BuildContext context) => HomeScreen(activeIndex: 1),
  };
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (BuildContext context) {
        return HomeScreen(activeIndex: 0,);
      });
    case "/product":
      return MaterialPageRoute(builder: (BuildContext context) {
        return HomeScreen(activeIndex: 1,);
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Login(title: "Hollo");
      });
  }
}
