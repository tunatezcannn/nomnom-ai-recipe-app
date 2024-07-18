import 'package:flutter/material.dart';
import 'package:nomnom/themes/apptheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessageEmail = '';
  String? errorMessagePassword = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      errorMessageEmail = '';
      errorMessagePassword = '';
    });

    if (_controllerEmail.text.isEmpty) {
      setState(() {
        errorMessageEmail = 'Email cannot be empty';
      });
      return;
    }

    if (_controllerPassword.text.isEmpty) {
      setState(() {
        errorMessagePassword = 'Password cannot be empty';
      });
      return;
    }

    try {
      UserCredential userCredential = await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      User? user = userCredential.user;
      
      if (user != null && !user.emailVerified) {
        await Auth().signOut();
        setState(() {
          errorMessageEmail = 'Email not verified';
        });
        return;
      }

      Navigator.pushNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'invalid-email' || e.code == 'user-not-found' || e.code == 'invalid-credential') {
          errorMessageEmail = e.message;
        } else if (e.code == 'wrong-password') {
          errorMessagePassword = e.message;
        } else {
          errorMessageEmail = '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'NomNom',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Lobster', // Title font
            fontSize: 50,
            color: AppTheme.whiteColor, // Color for the title
          ),
        ),
        centerTitle: true, // Set the AppBar color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 40),
              const Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryColor,
                  fontFamily: 'Poppins', // Font for the title
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: errorMessageEmail!.isNotEmpty ? Colors.red : Colors.grey,
                    ),
                  ),
                  errorText: errorMessageEmail!.isNotEmpty ? errorMessageEmail : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                controller: _controllerPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: errorMessagePassword!.isNotEmpty ? Colors.red : Colors.grey,
                    ),
                  ),
                  errorText: errorMessagePassword!.isNotEmpty ? errorMessagePassword : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/resetPassword');
                  },
                  child: const Text(
                    'Forgot your password?',
                    style: TextStyle(color: AppTheme.accentColor, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    primary: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    signInWithEmailAndPassword();
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      color: AppTheme.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: AppTheme.accentColor, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
