import 'package:aureola_platform/models/common/address.dart';
import 'package:aureola_platform/models/common/contact.dart';
import 'package:aureola_platform/models/user/user_model.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/screens/main_page/main_page.dart';
import 'package:aureola_platform/service/firebase/firestore_user.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:aureola_platform/models/user/subscription.dart';

// sign_up_user_data.dart

import 'package:aureola_platform/models/common/contact.dart';
import 'package:aureola_platform/models/user/user_model.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/providers/venue_provider.dart'; // New import
import 'package:aureola_platform/screens/main_page/main_page.dart';
import 'package:aureola_platform/service/firebase/firestore_user.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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
  // Controllers for user inputs
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
  final FirestoreVenue _firestoreVenue = FirestoreVenue(); // Firestore instance

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

        // Create Contact object
        Contact contact = Contact(
          email: widget.email,
          phoneNumber: fullPhoneNumber, // Store full phone number if preferred
          countryCode: countryCode,
          // Optional fields are left as default ''
        );

        // Initialize default subscription (e.g., free trial)
        Subscription subscription = Subscription(
          type: 'free',
          featuresEnabled: [], // Define default features as needed
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
        );

        // Create UserModel with the provided information
        UserModel user = UserModel(
          userId: widget.userId,
          name: _nameController.text.trim(),
          contact: contact,
          address:
              Address(country: countryName), // Minimal address with country
          businessName: _businessController.text.trim(),
          subscription: subscription,
        );

        // Save user information to Firestore
        await _firestoreUser.addUser(user);

        // Create Contact object for Venue
        Contact venueContact = Contact(
          email: user.contact.email,
          phoneNumber: user.contact.phoneNumber,
          countryCode: user.contact.countryCode,
          // Optional fields left as default ''
        );

        // Create Address object for Venue with empty fields
        Address venueAddress = Address(
          country: countryName,
          // Other fields are default ''
        );

        // Create VenueModel
        VenueModel defaultVenue = VenueModel(
          userId: user.userId,
          venueId: '', // Firestore will generate the ID
          venueName: user.businessName,
          address: venueAddress,
          contact: venueContact,
        );

        // Add the venue to Firestore
        final venueId =
            await FirestoreVenue().addVenue(user.userId, defaultVenue);

        // Fetch the saved VenueModel with the generated venueId
        VenueModel savedVenue = VenueModel(
          userId: user.userId,
          venueId: venueId,
          venueName: user.businessName,
          address: venueAddress,
          contact: venueContact,
        );

        // Set the UserProvider with the new user data
        ref.read(userProvider.notifier).setUser(user);

        // Set the VenueProvider with the new venue data
        ref.read(venueProvider.notifier).setVenue(savedVenue);

        // Navigate to the MainPage or next step
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      } catch (e) {
        // Log the error if needed
        print('Error during signup: $e');

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
  void dispose() {
    // Dispose controllers to free resources
    _nameController.dispose();
    _businessController.dispose();
    _phoneController.dispose();
    _countryCodeController.dispose();
    _countryNameController.dispose();
    _countryDialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Setup'),
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
                          decoration: const InputDecoration(
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
                          decoration: const InputDecoration(
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
                          decoration: const InputDecoration(
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
