import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider will store the index of the selected tab
final selectedMenuIndexProvider = StateProvider<int>((ref) => 7);
