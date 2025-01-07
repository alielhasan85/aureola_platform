import 'package:aureola_platform/models/common/address.dart';
import 'package:aureola_platform/models/common/contact.dart';
import 'package:aureola_platform/models/user/user_model.dart';
import 'package:aureola_platform/models/venue/design_display.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/main_page/main_page.dart';
import 'package:aureola_platform/service/firebase/firestore_user.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:aureola_platform/models/common/subscription.dart';

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
  final TextEditingController _nameUserController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _countryNameController = TextEditingController();
  final TextEditingController _countryDialController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final FirestoreUser _firestoreUser = FirestoreUser(); // Firestore instance

  Future<void> _submitInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String phoneNumber = _phoneController.text.trim();
      String countryDial = _countryDialController.text.trim();
      String countryCode = _countryCodeController.text.trim();
      String countryName = _countryNameController.text.trim();

      // Check if the email or phone number already exists
      final userExists = await _firestoreUser.checkIfUserExists(
        email: widget.email,
        phoneNumber: phoneNumber,
      );

      if (userExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'This email or phone number is already associated with an account. Please use different credentials.',
            ),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Create Contact object for the user
      final contact = Contact(
        email: widget.email,
        phoneNumber: phoneNumber,
        countryDial: countryDial,
        countryName: countryName,
        countryCode: countryCode,
      );

      // Default subscription (e.g., free trial)
      final subscription = Subscription(
        type: 'free',
        featuresEnabled: [],
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
      );

      // Create UserModel
      final user = UserModel(
        userId: widget.userId,
        name: _nameUserController.text.trim(),
        contact: contact,
        businessName: _businessController.text.trim(),
        subscription: subscription,
      );

      // Save user information to Firestore (users/{userId})
      await _firestoreUser.addUser(user);

      // Create Contact object for Venue (same as user’s contact)
      final venueContact = Contact(
        email: user.contact.email,
        phoneNumber: user.contact.phoneNumber,
        countryDial: user.contact.countryDial,
        countryName: user.contact.countryName,
        countryCode: user.contact.countryCode,
      );

      // Create Address object for Venue
      final venueAddress = Address(
        country: user.contact.countryName,
        // Fill other fields if you want
      );

      // A default empty design
      final designAndDisplay = const DesignAndDisplay();

      // The initial language code (assuming 'en')
      // We'll store it at index 0 and store 'en' -> user.businessName in venueName
      final Map<String, String> nameMap = {'en': user.businessName};
      final Map<String, String> tagLineMap = {'en': ''};

      // Build the default venue
      final defaultVenue = VenueModel(
        userId: user.userId,
        venueId: '', // Firestore will generate this
        venueName: nameMap, // Multi-lingual map
        tagLine: tagLineMap, // Multi-lingual map
        address: venueAddress,
        contact: venueContact,
        designAndDisplay: designAndDisplay,
        // Start with 'en' as the only language
        languageOptions: ['en'],
        additionalInfo: {
          'mapImageUrl': '',
          'defaultLanguage': 'en',
        },
      );

      // Add the new venue ( /users/{userId}/venues/{venueId} )
      final venueId =
          await FirestoreVenue().addVenue(user.userId, defaultVenue);

      // Build the fully saved venue, or re-fetch from Firestore
      final savedVenue = defaultVenue.copyWith(venueId: venueId);

      // Set the user & venue in providers
      ref.read(userProvider.notifier).setUser(user);
      ref.read(venueProvider.notifier).setVenue(savedVenue);
      ref.read(draftVenueProvider.notifier).setVenue(savedVenue);

      // Navigate to MainPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save user information. Please try again.'),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameUserController.dispose();
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
        backgroundColor: AppThemeLocal.background,
        elevation: 0,
      ),
      backgroundColor: AppThemeLocal.background,
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome to Our Platform!',
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: AppThemeLocal.primary,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tell us about yourself',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: AppThemeLocal.accent),
                    ),
                    const SizedBox(height: 20),

                    // Name
                    Text(
                      "What is your name?",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _nameUserController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your name',
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter your name'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Business Name
                    Text(
                      "What is your business name?",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _businessController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your business name',
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter your business name'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Phone Number
                    Text(
                      "What is your phone number?",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    IntlPhoneField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your phone number',
                      ),
                      initialCountryCode: 'US',
                      onChanged: (phone) {
                        _phoneController.text = phone.number;
                        _countryDialController.text = phone.countryCode;
                        _countryCodeController.text = phone.countryISOCode;
                      },
                      onCountryChanged: (country) {
                        _countryNameController.text = country.name;
                      },
                      validator: (value) =>
                          (value == null || value.number.isEmpty)
                              ? 'Please enter your phone number'
                              : null,
                    ),
                    const SizedBox(height: 30),

                    // Submit
                    Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitInfo,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppThemeLocal.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text('Start Your Free Trial'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
