import 'package:aureola_platform/localization/localization.dart';
import 'package:aureola_platform/screens/main_page/main_page.dart';
import 'package:aureola_platform/providers/lang_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:naya_menu/client_app/main_page/cl_main_page.dart';
// import 'package:naya_menu/client_app/notifier.dart';
// import 'package:naya_menu/service/firebase/firestore_venue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // bool _isLoggedIn = false;
  // String? _userId;

  @override
  void initState() {
    super.initState();
    // _logInDevelopmentAccount();
  }

  // Future<void> _logInDevelopmentAccount() async {
  //   try {
  //     const String email =
  //         'elhasana.ali@gmail.com'; // Replace with your dev email
  //     const String password = 'rotation'; // Replace with your dev password

  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     final userId = userCredential.user!.uid;

  //     // Fetch and set user data in Riverpod
  //     await ref.read(userProvider.notifier).fetchUser(userId);

  //     // Fetch associated venues
  //     final venueList = await FirestoreVenue().getAllVenues(userId);
  //     if (venueList.isNotEmpty) {
  //       ref.read(venueProvider.notifier).setVenue(venueList.first);
  //     }

  //     // Update the state when logged in successfully
  //     setState(() {
  //       _isLoggedIn = true;
  //       _userId = userId;
  //     });
  //   } catch (e) {
  //     // Handle login errors, such as showing a Snackbar or dialog
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final currentLanguage = ref.watch(languageProvider);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aureola Platform',
        supportedLocales: const [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale(currentLanguage == 'English' ? 'en' : 'ar'),
        builder: (context, child) {
          return Directionality(
            textDirection: currentLanguage == 'Arabic'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child!,
          );
        },
        home: const MainPage());
  }
}
