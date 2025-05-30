import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final Future<void> Function(String email) onResetPassword;

  const ResetPasswordScreen({super.key, required this.onResetPassword});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    Future<void> _submit() async {
      if (!_formKey.currentState!.validate()) return;

      setState(() {
        _isLoading = true;
        _error = null;
      });

      try {
        await widget.onResetPassword(_emailController.text.trim());

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr.sentResetPasswordLink)),
          );

          Navigator.of(context).pop(); // ✅ סוגר את המסך
        }
      } catch (err) {
        setState(() {
          _error = err.toString();
        });
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(tr.resetPassword)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_error != null) ...[
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: tr.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value != null && value.contains('@') ? null : tr.emailError,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(tr.sendResetPasswordLink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
