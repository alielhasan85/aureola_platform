import 'package:aureola_platform/models/items/items_model.dart';

class MenuSection {
  final String sectionId;

  /// Multilingual name, e.g. { "en": "Starters", "ar": "المقبلات" }
  final Map<String, String> sectionName;

  /// Optional: If you need a description or notes for the section
  /// final Map<String, String> sectionDescription;

  /// A list of embedded MenuItem objects.
  /// If you're using a subcollection for items, you can remove or minimize this.
  final List<MenuItem> items;

  MenuSection({
    required this.sectionId,
    required this.sectionName,
    this.items = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'sectionId': sectionId,
      // We can store the multilingual map directly in Firestore
      'sectionName': sectionName,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory MenuSection.fromMap(Map<String, dynamic> map) {
    return MenuSection(
      sectionId: map['sectionId'],
      // Convert whatever is in 'sectionName' into a Map<String, String>.
      // If 'sectionName' doesn't exist, fallback to an empty map.
      sectionName: Map<String, String>.from(map['sectionName'] ?? {}),
      items: (map['items'] as List<dynamic>?)
              ?.map((itemMap) =>
                  MenuItem.fromMap(Map<String, dynamic>.from(itemMap)))
              .toList() ??
          [],
    );
  }

  MenuSection copyWith({
    String? sectionId,
    Map<String, String>? sectionName,
    List<MenuItem>? items,
  }) {
    return MenuSection(
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return 'MenuSection(sectionId: $sectionId, '
        'sectionName: $sectionName, '
        'items: $items)';
  }
}
