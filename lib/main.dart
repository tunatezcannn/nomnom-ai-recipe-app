import 'package:flutter/material.dart';
import 'package:nomnom/firebase_options.dart';
import 'package:nomnom/screens/favouriterecipeScreen.dart';
import 'package:nomnom/screens/homeScreen.dart';
import 'package:nomnom/screens/loadingScreen.dart';
import 'package:nomnom/screens/loginScreen.dart';
import 'package:nomnom/screens/matchingrecipeScreen.dart';
import 'package:nomnom/screens/profileScreen.dart';
import 'package:nomnom/screens/recipeScreen.dart';
import 'package:nomnom/screens/resetpasswordScreen.dart';
import 'package:nomnom/screens/settingsScreen.dart';
import 'package:nomnom/screens/signupScreen.dart';
import 'package:nomnom/screens/splashScreen.dart';
import 'package:nomnom/screens/surveyScreen.dart';
import 'package:nomnom/systems/recipeClass.dart';
import 'package:nomnom/systems/saveSystem.dart';
import 'themes/appTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PreferenceManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NomNom',
      theme: AppTheme.themeData,
      initialRoute: '/',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/favourite': (context) => FavouriteRecipeScreen(),
        '/matching': (context) => MatchingRecipeScreen(recipe: []),
        '/recipe': (context) => RecipeScreen(recipe: Recipe(name: "", ingredients: [], instructions: [])),
        '/settings': (context) => SettingsScreen(),
        '/signup': (context) => SignUpScreen(),
        '/resetPassword': (context) => ResetPasswordScreen(),
        '/survey': (context) => SurveyScreen(),
        '/loading': (context) => LoadingScreen(),
        '/login': (context) => LoginScreen(),
        '/': (context) => AuthenticationWrapper(), // Set AuthenticationWrapper as the initial route
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null && !PreferenceManager.getAllKeys().contains("preferencesSet")) {
            return LoginScreen();
          } else if(PreferenceManager.getAllKeys().contains("preferencesSet")) {
            return HomeScreen();
          }
          else{
            return LoginScreen();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
