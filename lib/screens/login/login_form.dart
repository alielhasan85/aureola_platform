import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:aureola_platform/screens/login/email_verification.dart';
import 'package:aureola_platform/screens/login/reset_password.dart';
import 'package:aureola_platform/screens/main_page/main_page.dart';
import 'package:aureola_platform/widgest/progress_indicator.dart';
import 'package:aureola_platform/service/firebase/auth_user.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: delete this import
import 'package:flutter/foundation.dart';

class LoginForm extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onToggle;

  const LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onToggle,
    super.key,
  });

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  //TODO: to delete this method

  // @override
  // void initState() {
  //   super.initState();
  //   if (kDebugMode) {
  //     // Set test credentials
  //     widget.emailController.text = 'elhasan.ali@gmail.com';
  //     widget.passwordController.text = 'rotation';

  //     // Automatically trigger login after the first frame
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _logIn();
  //     });
  //   }
  // }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.translate('email_hint');
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.translate('email_hint');
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.translate('password_hint');
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.translate('password_hint');
    }
    return null;
  }

  // Future<void> _logIn() async {
  //   if (!widget.formKey.currentState!.validate()) return;

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     UserCredential userCredential =
  //         await _authService.signInWithEmailAndPassword(
  //       widget.emailController.text,
  //       widget.passwordController.text,
  //     );

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => MainPage(userId: userCredential.user!.uid),
  //       ),
  //     );
  //   } on AuthException catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.message)),
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // Fetch the user data from Firestore
  // await ref.read(userProvider.notifier).fetchUser(userId);

  // Fetch the list of venues associated with the user directly
  // final venueList = await FirestoreVenue().getAllVenues(userId);

  // if (venueList.isNotEmpty) {
  // Set the first venue as the selected venue
  //   ref.read(venueProvider.notifier).setVenue(venueList.first);
  // }

  // Navigate to the MainPage

  Future<void> _logIn() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Sign in the user
      UserCredential userCredential =
          await _authService.signInWithEmailAndPassword(
        widget.emailController.text,
        widget.passwordController.text,
      );

      User? user = userCredential.user;

      final userId = userCredential.user!.uid;

      // Fetch the user data from Firestore
      await ref.read(userProvider.notifier).fetchUser(userId);

      // Fetch the list of venues associated with the user directly
      final venueList = await FirestoreVenue().getAllVenues(userId);

      if (venueList.isNotEmpty) {
        // Set the first venue as the selected venue
        ref.read(venueProvider.notifier).setVenue(venueList.first);
      }

      if (user != null && user.emailVerified) {
        // Navigate to the MainPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      } else {
        // Email not verified
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.translate('please_verify_email')),
          ),
        );

        // Navigate to the email verification screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerificationScreen(),
          ),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// TODO: to add language selection tab, could be in the bottom
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.translate('log_in_to_your_account'),
            style: AppTheme.appBarTitle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 15.0),
          Text(
            AppLocalizations.of(context)!.translate('welcome_back'),
            style: AppTheme.paragraph.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            //TODO: to follow same startegy of info venue
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate('email_label'),
                  style: AppTheme.paragraph,
                ),
                const SizedBox(height: 6),
                TextFormField(
                  style: AppTheme.paragraph,
                  cursorColor: AppTheme.accent,
                  controller: widget.emailController,
                  validator: _validateEmail,
                  decoration: AppTheme.textFieldinputDecoration(
                    hint: AppLocalizations.of(context)!.translate('email_hint'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate('password_label'),
                  style: AppTheme.paragraph,
                ),
                const SizedBox(height: 6),
                TextFormField(
                  style: AppTheme.paragraph,
                  cursorColor: AppTheme.accent,
                  controller: widget.passwordController,
                  validator: _validatePassword,
                  obscureText: true,
                  decoration: AppTheme.textFieldinputDecoration(
                    hint: AppLocalizations.of(context)!
                        .translate('password_hint'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 400,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _logIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                textStyle: const TextStyle(fontSize: 16.0),
              ),
              child: _isLoading
                  ? CustomProgressIndicator()
                  : Text(
                      AppLocalizations.of(context)!.translate('log_in_button')),
            ),
          ),
          const SizedBox(height: 20.0),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ResetPasswordScreen()),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.translate('forgot_password'),
              style: TextStyle(color: Colors.blue),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!
                  .translate('dont_have_an_account')),
              TextButton(
                onPressed: widget.onToggle,
                child: Text(
                  AppLocalizations.of(context)!.translate('sign_up'),
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
