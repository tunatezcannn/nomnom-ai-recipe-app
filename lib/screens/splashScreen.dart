import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nomnom/screens/loginScreen.dart';
import 'package:nomnom/themes/apptheme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: AppTheme.primaryColor, // Using the AppTheme color you defined earlier
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              CircleAvatar(
                  radius: 80.0,
                  backgroundColor: AppTheme.whiteColor,
                  child: Text(
                    "NomNom",
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 40,
                      fontFamily: "lobster"
                    ),
                  ),
                ),
              Text(
                'Your AI recipe finder',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: "poppins"
                ),
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              Spacer(),
              Text(
                textAlign: TextAlign.end,
                'Provided by G14',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
