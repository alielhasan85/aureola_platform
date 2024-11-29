import 'package:aureola_platform/screens/main_page/main_page.dart';
import 'package:aureola_platform/service/firebase/auth_user.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onToggle;

  const SignUpForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onToggle,
    super.key,
  });

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  // Validate email input
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.translate('email_hint');
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.translate('email_invalid');
    }
    return null;
  }

  // Validate password input
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.translate('password_hint');
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.translate('password_too_short');
    }
    return null;
  }

  // Check if the fields are valid to show the confirm password field
  void _checkFields() {
    final isEmailValid = _validateEmail(widget.emailController.text) == null;
    final isPasswordValid =
        _validatePassword(widget.passwordController.text) == null;

    setState(() {
      _showConfirmPassword = isEmailValid && isPasswordValid;
    });
  }

  // Sign up process
  Future<void> _signUp() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Sign up the user using AuthService
      UserCredential userCredential =
          await _authService.signUpWithEmailAndPassword(
        widget.emailController.text,
        widget.passwordController.text,
      );

      // Navigate to the next page if sign-up is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()

            // ClSignUpUserData(
            //   userId: userCredential.user!.uid,
            //   email: widget.emailController.text,
            // ),
            ),
      );
    } on AuthException catch (e) {
      // Handle authentication errors
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      // Handle unexpected errors
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Title
          Text(
            AppLocalizations.of(context)!.translate('sign_up_page_title'),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 15.0),
          // Subtitle
          Text(
            AppLocalizations.of(context)!.translate('no_credit_card_required'),
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20.0),
          // Email input field

          // InputField(
          //   label: AppLocalizations.of(context)!.translate('email_label'),
          //   hintText: AppLocalizations.of(context)!.translate('email_hint'),
          //   controller: widget.emailController,
          //   validator: _validateEmail,
          //   onChanged: (value) => _checkFields(),
          // ),
          // const SizedBox(height: 20.0),
          // // Password input field
          // InputField(
          //   label: AppLocalizations.of(context)!.translate('password_label'),
          //   hintText: AppLocalizations.of(context)!.translate('password_hint'),
          //   controller: widget.passwordController,
          //   validator: _validatePassword,
          //   onChanged: (value) => _checkFields(),
          //   obscureText: true,
          // ),

          if (_showConfirmPassword) const SizedBox(height: 20.0),
          // Confirm Password input field
          if (_showConfirmPassword)
            // InputField(
            //   label: AppLocalizations.of(context)!
            //       .translate('confirm_password_label'),
            //   hintText: AppLocalizations.of(context)!
            //       .translate('confirm_password_hint'),
            //   controller: widget.confirmPasswordController,
            //   validator: (value) {
            //     if (value != widget.passwordController.text) {
            //       return AppLocalizations.of(context)!
            //           .translate('passwords_do_not_match');
            //     }
            //     return null;
            //   },
            //   obscureText: true,
            // ),
            const SizedBox(height: 20.0),
          // Sign up button
          SizedBox(
            width: 400,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(AppLocalizations.of(context)!
                      .translate('sign_up_button')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                textStyle: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          // Divider and alternative sign-up methods
          const Row(
            children: <Widget>[
              Expanded(child: Divider(color: Colors.black)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('or',
                    style: TextStyle(color: Color.fromARGB(255, 85, 85, 85))),
              ),
              Expanded(child: Divider(color: Color.fromARGB(255, 85, 85, 85))),
            ],
          ),
          const SizedBox(height: 20.0),
          // Sign up with Google button
          SizedBox(
            width: 400,
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle Google sign-up
              },
              icon: SvgPicture.asset(
                '/assets/icons/google.svg',
                // colorFilter: ColorFilter.mode(
                //   iconAndTextColor,
                //   BlendMode.srcIn,
                // ),
              ),
              label: Text(AppLocalizations.of(context)!
                  .translate('sign_up_with_google')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                textStyle: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          // Already have an account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('already_have_an_account'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: widget.onToggle,
                child: Text(
                  AppLocalizations.of(context)!.translate('log_in_button'),
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
