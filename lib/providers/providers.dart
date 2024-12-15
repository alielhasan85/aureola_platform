import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
// App general provider

enum AuthForm { login, signUp }

final authFormProvider = StateProvider<AuthForm>((ref) => AuthForm.login);

final languageProvider =
    StateProvider<String>((ref) => 'en'); // Default to 'en'

// draft provider - Branding and design
final displayNameProvider = StateProvider<String>((ref) => '');
final taglineProvider = StateProvider<String>((ref) => '');

final draftBackgroundColorProvider = StateProvider<Color?>((ref) => null);
final draftHighlightColorProvider = StateProvider<Color?>((ref) => null);
final draftTextColorProvider = StateProvider<Color?>((ref) => null);
