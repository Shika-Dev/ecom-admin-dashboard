import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:smart_admin_dashboard/injector/injector.dart';
import 'package:smart_admin_dashboard/models/sign_in_model.dart';
import 'package:smart_admin_dashboard/storage/shared_preferences_manager.dart';

const List<String> scopes = <String>['email', 'profile'];

GoogleSignIn signIn = GoogleSignIn(scopes: scopes);

Future<bool> handleSignIn() async {
  try {
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    UserCredential? userCredential;
    bool isAuth = await isSignIn();
    SharedPreferencesManager pref = locator<SharedPreferencesManager>();
    bool isAdmin = pref.getBool(SharedPreferencesManager.keyAuth) ?? false;
    if (!isAuth || !isAdmin) {
      try {
        userCredential =
            await FirebaseAuth.instance.signInWithPopup(authProvider);
      } catch (e) {
        print(e);
        // TODO: Handle the error. Maybe inform the user.
        return false;
      }

      final User? user = userCredential.user;
      final String? token = await user?.getIdToken();
      print(token);
      if (token != null && user != null) {
        SignInModel model = await signInJWT(token);
        if (model.errors == null || model.errors!.errorCode == null) {
          pref.putString(
              SharedPreferencesManager.keyAccessToken, model.data!.token.token);
          print(model.data!.token.token);
          setSharedPref(
              name: user.displayName,
              token: model.data!.token.token,
              imageUrl: user.photoURL);
          return true;
        }
      }
    }
    return false;
  } catch (error) {
    print(error);
    return false;
  }
}

setSharedPref({String? name, String? token, String? imageUrl}) {
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  pref.putBool(SharedPreferencesManager.keyAuth, true);
  pref.putString(SharedPreferencesManager.keyName, name ?? '');
  pref.putString(SharedPreferencesManager.keyAccessToken, token ?? '');
  pref.putString(SharedPreferencesManager.keyProfileImage, imageUrl ?? '');
}

Future<bool> isSignIn() async {
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  bool _isSignIn = await signIn.isSignedIn();
  if (!_isSignIn) {
    pref.clearAll();
  }
  return _isSignIn;
}

Future<void> handleSignOut() async {
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  signIn.disconnect();
  FirebaseAuth.instance.signOut();
  pref.clearAll();
  pref.putBool(SharedPreferencesManager.keyAuth, false);
}

Future<SignInModel> signInJWT(String token) async {
  var headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> body = {'accessToken': token};
  final response = await http.post(
      Uri.parse('https://api.sevva.co.id/api/auth/signin'),
      headers: headers,
      body: json.encode(body));
  return SignInModel.fromJson(json.decode(response.body));
}
