import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aureola_platform/models/menu/menu_model.dart';

class FirestoreMenu {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add or update a Menu. If [menuId] is empty, will create a new doc.
  Future<String> addOrUpdateMenu({
    required String userId,
    required String venueId,
    required MenuModel menu,
  }) async {
    final menuCollection = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId)
        .collection('menus');

    final docRef = menu.menuId.isEmpty
        ? menuCollection.doc()
        : menuCollection.doc(menu.menuId);

    final updatedMenu = menu.copyWith(menuId: docRef.id);
    final data = updatedMenu.toMap();
    data['updatedAt'] = DateTime.now().toIso8601String();
    await docRef.set(data, SetOptions(merge: true));
    return docRef.id;
  }

  /// Get a single menu by ID
  Future<MenuModel?> getMenuById({
    required String userId,
    required String venueId,
    required String menuId,
  }) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId)
        .collection('menus')
        .doc(menuId)
        .get();

    if (!snapshot.exists) return null;
    return MenuModel.fromMap(snapshot.data()!, snapshot.id);
  }

  /// Get all menus for a venue, sorted by [sortOrder].
  Future<List<MenuModel>> getAllMenus({
    required String userId,
    required String venueId,
  }) async {
    final querySnap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId)
        .collection('menus')
        .orderBy('sortOrder', descending: false)
        .get();

    return querySnap.docs.map((doc) {
      return MenuModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  /// Partial update for an existing menu
  Future<void> updateMenuFields({
    required String userId,
    required String venueId,
    required String menuId,
    required Map<String, dynamic> fields,
  }) async {
    fields['updatedAt'] = DateTime.now().toIso8601String();

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId)
        .collection('menus')
        .doc(menuId)
        .update(fields);
  }

  /// Delete a menu
  Future<void> deleteMenu({
    required String userId,
    required String venueId,
    required String menuId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId)
        .collection('menus')
        .doc(menuId)
        .delete();
  }

  /// Reorder menus by new [sortOrder] (like "drag and drop" reordering).
  /// The caller can pass the entire new list with updated sortOrders,
  /// and we do a batch write.
  Future<void> reorderMenus({
    required String userId,
    required String venueId,
    required List<MenuModel> reorderedList,
  }) async {
    final batch = _firestore.batch();

    for (final menu in reorderedList) {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('venues')
          .doc(venueId)
          .collection('menus')
          .doc(menu.menuId);

      final data = {
        'sortOrder': menu.sortOrder,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      batch.update(docRef, data);
    }

    await batch.commit();
  }
}
