import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/models/menu/menu_model.dart';
import 'package:aureola_platform/service/firebase/firestore_menu.dart';
import 'package:aureola_platform/providers/user_provider.dart';

class MenuNotifier extends StateNotifier<MenuModel?> {
  MenuNotifier(this.ref) : super(null);

  final Ref ref;

  // Load a menu from Firestore
  Future<void> fetchMenu(String venueId, String menuId) async {
    final user = ref.read(userProvider);
    if (user == null) return;

    final menu = await FirestoreMenu().getMenuById(
      userId: user.userId,
      venueId: venueId,
      menuId: menuId,
    );
    state = menu;
  }

  // Set the local menu directly
  void setMenu(MenuModel menu) {
    state = menu;
  }

  // Clear the local menu
  void clearMenu() {
    state = null;
  }

  // Update a single field locally
  void updateMenuName(String locale, String newName) {
    if (state == null) return;
    final newNames = {...state!.menuName};
    newNames[locale] = newName;
    state = state!.copyWith(menuName: newNames);
  }

  // Example: Toggle isOnline
  void toggleIsOnline() {
    if (state == null) return;
    state = state!.copyWith(isOnline: !state!.isOnline);
  }

  // Save current state to Firestore
  Future<void> saveChanges(String venueId) async {
    if (state == null) return;
    final user = ref.read(userProvider);
    if (user == null) return;

    await FirestoreMenu().addOrUpdateMenu(
      userId: user.userId,
      venueId: venueId,
      menu: state!,
    );
  }
}

/// We may create a .family to manage a specific menu if we wish:
/// final singleMenuNotifierProvider = StateNotifierProvider.autoDispose
///    .family<MenuNotifier, MenuModel?, (String venueId, String menuId)>((ref, tuple) {
///   final (venueId, menuId) = tuple;
///   final notifier = MenuNotifier(ref);
///   notifier.fetchMenu(venueId, menuId);
///   return notifier;
/// });
