import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globox/login/register.dart';
import 'package:globox/login/reset_password_screen.dart';
import 'package:globox/services/internal/app_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthScreen();
}

class _AuthScreen extends State<AuthScreen> {
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit(BuildContext context) async {
    final tr = AppLocalizations.of(context)!;

    try {
      final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? tr.error),
          action: SnackBarAction(
            label: tr.dismiss,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();
    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tr.welcome,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: tr.email,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _enteredEmail = value;
                },
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: tr.password,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _enteredPassword = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submit(context),
                child: Text(tr.login),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()));
                },
                child: Text(tr.dontHavePassword),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen(
                                onResetPassword: (email) => FirebaseAuth
                                    .instance
                                    .sendPasswordResetEmail(email: email),
                              )));
                },
                child: Text(tr.forgotPassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
