import 'package:aureola_platform/models/user/user_model.dart';
import 'package:aureola_platform/providers/user_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});
