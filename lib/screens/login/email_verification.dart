// email_verification_screen.dart

import 'dart:async';
import 'package:aureola_platform/screens/main_page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:aureola_platform/service/localization/localization.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _timer;
  bool _isEmailVerified = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();

    // Start a timer to check email verification status every few seconds
    _timer = Timer.periodic(Duration(seconds: 5), (_) => _checkEmailVerified());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Refresh user data
    if (user != null && user.emailVerified) {
      _timer?.cancel();
      // Navigate to the main page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isResending = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .translate('verification_email_sent')),
          ),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .translate('error_sending_verification_email')),
        ),
      );
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You can style this Scaffold according to your theme
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context)!.translate('email_verification')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .translate('verification_email_sent_message'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isResending ? null : _resendVerificationEmail,
                child: _isResending
                    ? CircularProgressIndicator()
                    : Text(AppLocalizations.of(context)!
                        .translate('resend_verification_email')),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!
                    .translate('waiting_for_email_verification'),
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
