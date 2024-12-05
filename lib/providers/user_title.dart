import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileSelectedMenuIndexProvider = StateProvider<int>((ref) => 0);
final userProfileAppBarTitleProvider = Provider<String>((ref) {
  final selectedIndex = ref.watch(userProfileSelectedMenuIndexProvider);
  switch (selectedIndex) {
    case 0:
      return 'Profile';
    case 1:
      return 'Billing';
    case 2:
      return 'Plan';
    case 3:
      return 'Notifications';
    case 4:
      return 'Cards';
    default:
      return 'User Profile';
  }
});
