import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/models/menu/menu_model.dart';
import 'package:aureola_platform/service/firebase/firestore_menu.dart';
import 'package:aureola_platform/providers/user_provider.dart'; // Where your userProvider is

/// StateNotifier that holds a list of menus for a venue
class MenusListNotifier extends StateNotifier<AsyncValue<List<MenuModel>>> {
  MenusListNotifier({
    required this.ref,
    required this.venueId,
  }) : super(const AsyncValue.loading()) {
    _fetchMenus();
  }

  final Ref ref;
  final String venueId;

  /// Load all menus
  Future<void> _fetchMenus() async {
    final user = ref.read(userProvider);
    if (user == null) {
      state = const AsyncValue.data([]);
      return;
    }
    try {
      final allMenus = await FirestoreMenu().getAllMenus(
        userId: user.userId,
        venueId: venueId,
      );
      state = AsyncValue.data(allMenus);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Refresh the list forcibly (e.g. pull to refresh)
  Future<void> refreshMenus() async {
    state = const AsyncValue.loading();
    await _fetchMenus();
  }

  /// Delete a menu locally and in Firestore
  Future<void> deleteMenu(String menuId) async {
    final user = ref.read(userProvider);
    if (user == null) return;

    try {
      await FirestoreMenu().deleteMenu(
        userId: user.userId,
        venueId: venueId,
        menuId: menuId,
      );
      // Remove from local state
      final current = state.valueOrNull ?? [];
      final updated = current.where((m) => m.menuId != menuId).toList();
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Reorder the menus (like a drag-and-drop).
  /// 1) We reorder locally
  /// 2) We batch-update Firestore
  Future<void> reorderMenus(List<MenuModel> newOrderList) async {
    final user = ref.read(userProvider);
    if (user == null) return;

    // Example: call reorder in Firestore
    try {
      await FirestoreMenu().reorderMenus(
        userId: user.userId,
        venueId: venueId,
        reorderedList: newOrderList,
      );
      // Update local state
      state = AsyncValue.data(newOrderList);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Add or Update a menu in the list (like after "save" from a draft)
  Future<void> upsertMenu(MenuModel menu) async {
    final user = ref.read(userProvider);
    if (user == null) return;

    try {
      final newMenuId = await FirestoreMenu().addOrUpdateMenu(
        userId: user.userId,
        venueId: venueId,
        menu: menu,
      );
      // Re-fetch from server or update locally
      final updatedMenu =
          await FirestoreMenu().getMenuById(
            userId: user.userId,
            venueId: venueId,
            menuId: newMenuId,
          ) ??
          menu.copyWith(menuId: newMenuId);

      // Insert or replace in local list
      final current = state.valueOrNull ?? [];
      final idx = current.indexWhere((m) => m.menuId == newMenuId);
      List<MenuModel> newList;
      if (idx == -1) {
        newList = [...current, updatedMenu];
      } else {
        newList = [...current];
        newList[idx] = updatedMenu;
      }
      // Sort by sortOrder if you want consistent ordering
      newList.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      state = AsyncValue.data(newList);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// A public provider for the list of menus. We pass [venueId].
final menusListProvider = StateNotifierProvider.autoDispose
    .family<MenusListNotifier, AsyncValue<List<MenuModel>>, String>(
  (ref, venueId) {
    return MenusListNotifier(ref: ref, venueId: venueId);
  },
);
