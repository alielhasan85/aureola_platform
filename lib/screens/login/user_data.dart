import 'package:aureola_platform/models/user/user_model.dart';
import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/screens/main_page/main_page.dart';
import 'package:aureola_platform/service/firebase/firestore_user.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:aureola_platform/models/user/contact.dart';
import 'package:aureola_platform/models/user/address.dart';
import 'package:aureola_platform/models/user/subscription.dart';

class SignUpUserData extends ConsumerStatefulWidget {
  final String userId;
  final String email; // Email passed from the authentication page

  const SignUpUserData({
    required this.userId,
    required this.email,
    super.key,
  });

  @override
  ConsumerState<SignUpUserData> createState() => _SignUpUserDataState();
}

class _SignUpUserDataState extends ConsumerState<SignUpUserData> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryCodeController =
      TextEditingController(); // For storing country code
  final TextEditingController _countryNameController =
      TextEditingController(); // For storing country name
  final TextEditingController _countryDialController =
      TextEditingController(); // For storing dial code

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final FirestoreUser _firestoreUser = FirestoreUser(); // Firestore instance

  Future<void> _submitInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Get phone number and country dial code
        String phoneNumber = _phoneController.text.trim();
        String countryDial = _countryDialController.text.trim();
        String countryCode = _countryCodeController.text.trim();
        String countryName = _countryNameController.text.trim();

        // Construct full phone number with dial code
        String fullPhoneNumber = '$countryDial$phoneNumber';

        // Check if the email or phone number already exists
        bool userExists = await _firestoreUser.checkIfUserExists(
          email: widget.email,
          phoneNumber: fullPhoneNumber,
        );

        if (userExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'This email or phone number is already associated with an account. Please use different credentials.',
              ),
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Create Contact and Address objects
        Contact contact = Contact(
          email: widget.email,
          phoneNumber: phoneNumber,
          countryCode: countryCode,
          countryDial: countryDial,
        );

        Address address = Address(
          country: countryName,
        );

        // Initialize default subscription (e.g., free trial)
        Subscription subscription = Subscription(
          type: 'free',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
        );

        // Create UserModel with the provided information
        UserModel user = UserModel(
          userId: widget.userId,
          name: _nameController.text.trim(),
          contact: contact,
          address: address,
          businessName: _businessController.text.trim(),
          subscription: subscription,
        );

        // Save user information to Firestore
        await _firestoreUser.addUser(user);

        // Set the UserProvider with the new user data
        ref.read(userProvider.notifier).setUser(user);

        // Navigate to the MainPage or next step
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save user information. Please try again.'),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Setup'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 450,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize:
                    MainAxisSize.min, // Adjusted to use MainAxisSize.min
                children: <Widget>[
                  Text(
                    'Welcome to Our Platform!',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppTheme.primary, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Tell us about yourself',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppTheme.accent),
                  ),
                  const SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Name Field
                        Text(
                          "What is your name?",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _nameController,
                          //TODO: localization needed
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        // Business Name Field
                        Text(
                          "What is your business name?",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _businessController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your business name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your business name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        // Phone Number Field
                        Text(
                          "What is your phone number?",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 5.0),
                        IntlPhoneField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your phone number',
                          ),
                          initialCountryCode: 'US', // Default country code
                          onChanged: (phone) {
                            _phoneController.text = phone.number;
                            _countryDialController.text = phone.countryCode;
                            _countryCodeController.text = phone.countryISOCode;
                          },
                          onCountryChanged: (country) {
                            _countryNameController.text = country.name;
                          },
                          validator: (value) {
                            if (value == null || value.number.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30.0),
                        // Submit Button
                        Center(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitInfo,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppTheme.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text('Start Your Free Trial'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: AppTheme.background, // Consistent background color
    );
  }
}
