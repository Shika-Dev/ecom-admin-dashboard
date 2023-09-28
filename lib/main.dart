import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin_dashboard/core/auth/auth.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/init/provider_list.dart';
import 'package:smart_admin_dashboard/firebase_options.dart';
import 'package:smart_admin_dashboard/injector/injector.dart';
import 'package:smart_admin_dashboard/screens/home/home_screen.dart';
import 'package:smart_admin_dashboard/screens/login/login_screen.dart';
import 'package:smart_admin_dashboard/storage/shared_preferences_manager.dart';

void main() async {
  await setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
  isSignIn();
}

Widget build(BuildContext context) {
  return MultiProvider(
      providers: [...ApplicationProvider.instance.dependItems], child: MyApp());
}

class MyApp extends StatelessWidget {
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Dashboard - Admin Panel v0.1 ',
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(backgroundColor: bgColor, elevation: 0),
        scaffoldBackgroundColor: bgColor,
        primaryColor: greenColor,
        dialogBackgroundColor: secondaryColor,
        buttonTheme: ButtonThemeData(buttonColor: greenColor),
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
        cardColor: secondaryColor,
      ),
      home: pref.getBool(SharedPreferencesManager.keyAuth) ?? false
          ? HomeScreen(activeIndex: 1)
          : Login(title: "Wellcome to the Admin & Dashboard Panel"),
    );
  }
}
