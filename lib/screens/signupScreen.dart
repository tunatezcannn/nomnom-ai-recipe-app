import 'package:flutter/material.dart';
import 'package:nomnom/themes/apptheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? errorMessageEmail = '';
  String? errorMessagePassword = '';
  String? errorMessageName = '';
  String? errorMessageRepeatPassword = '';

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerRepeatPassword = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    setState(() {
      errorMessageEmail = '';
      errorMessagePassword = '';
      errorMessageRepeatPassword = '';
      errorMessageName = '';
    });

    if (_controllerName.text.isEmpty) {
      setState(() {
        errorMessageName = 'Name cannot be empty';
      });
      return;
    }

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

    if (_controllerPassword.text != _controllerRepeatPassword.text) {
      setState(() {
        errorMessageRepeatPassword = 'Passwords do not match';
      });
      return;
    }

    try {
      UserCredential userCredential = await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);

      await userCredential.user?.updateProfile(displayName: _controllerName.text);
      await userCredential.user?.reload();

      await userCredential.user?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email has been sent')),
      );

      Navigator.pushReplacementNamed(context, '/login');

    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'invalid-email' || e.code == 'email-already-in-use') {
          errorMessageEmail = e.message;
        } else if (e.code == 'weak-password') {
          errorMessagePassword = e.message;
        } else {
          errorMessageEmail = 'An unexpected error occurred';
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.code)),
      );
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
            fontFamily: 'Lobster',
            fontSize: 50,
            color: AppTheme.whiteColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'Cook Smart Now!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryColor,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controllerName,
                decoration: InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: errorMessageName!.isNotEmpty ? Colors.red : Colors.grey,
                    ),
                  ),
                  errorText: errorMessageName!.isNotEmpty ? errorMessageName : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                controller: _controllerRepeatPassword,
                decoration: InputDecoration(
                  labelText: 'Repeat Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: errorMessageRepeatPassword!.isNotEmpty ? Colors.red : Colors.grey,
                    ),
                  ),
                  errorText: errorMessageRepeatPassword!.isNotEmpty ? errorMessageRepeatPassword : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "You have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    child: const Text(
                      'Log In',
                      style: TextStyle(color: AppTheme.accentColor, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ],
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
                    createUserWithEmailAndPassword();
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: AppTheme.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
