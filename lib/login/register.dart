import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _register(BuildContext context) async {
    final tr = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      var snackbarMsg = '';
      try {
        snackbarMsg = tr.successfullyRegistered;
        final registerResult =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        Navigator.pop(context);
      } on FirebaseAuthException catch (error) {
        print("Registration Error: ${error.message}");
        snackbarMsg = error.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMsg),
          action: SnackBarAction(
            label: tr.dismiss,
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(tr.register)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: tr.fullName),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr.fullNameError;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: tr.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return tr.emailError;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmEmailController,
                decoration: InputDecoration(labelText: tr.emailConfirm),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != _emailController.text) {
                    return tr.emailConfirmError;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: tr.password),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return tr.passwordError;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: tr.passwordConfirm),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return tr.passwordConfirmError;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _register(context);
                },
                child: Text(tr.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
