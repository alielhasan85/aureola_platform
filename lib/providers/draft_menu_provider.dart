import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/models/menu/menu_model.dart';

/// Holds a temporary "draft" state for editing a menu.
class DraftMenuNotifier extends StateNotifier<MenuModel?> {
  DraftMenuNotifier() : super(null);

  // Initialize draft with an existing Menu
  void loadMenu(MenuModel original) {
    state = original;
  }

  // Clear the draft
  void clear() {
    state = null;
  }

  // Update some fields
  void updateMenuName(String locale, String newName) {
    if (state == null) return;
    final newNames = {...state!.menuName};
    newNames[locale] = newName;
    state = state!.copyWith(menuName: newNames);
  }

  void toggleIsOnline() {
    if (state == null) return;
    state = state!.copyWith(isOnline: !state!.isOnline);
  }

  // or any other fields...
}

/// A provider for the draft
final draftMenuProvider =
    StateNotifierProvider.autoDispose<DraftMenuNotifier, MenuModel?>((ref) {
  return DraftMenuNotifier();
});
