import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      var snackbarMsg = '';
      try {
        snackbarMsg = 'Successfuly registered!';
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
            label: 'Dismiss',
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
    return Scaffold(
      appBar: AppBar(title: Text("רישום")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "שם מלא"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "נא להזין שם מלא";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "אימייל"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return "נא להזין אימייל תקף";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmEmailController,
                decoration: InputDecoration(labelText: "אישור אימייל"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != _emailController.text) {
                    return "האימיילים אינם תואמים";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "סיסמה"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "הסיסמה חייבת להכיל לפחות 6 תווים";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: "אישור סיסמה"),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "הסיסמאות אינן תואמות";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text("הירשם"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
