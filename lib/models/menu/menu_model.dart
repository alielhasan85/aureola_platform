import 'package:aureola_platform/models/menu/menu_availability.dart';
import 'package:aureola_platform/models/section/section_model.dart';

class MenuModel {
  final String menuId;
  final String venueId;
  final Map<String, String> menuName;
  final Map<String, String> description;
  final Map<String, String> notes;
  final String? imageUrl;
  final List<MenuSection> sections;
  final bool isOnline;
  final bool visibleOnTablet;
  final bool visibleOnQr;
  final bool visibleOnPickup;
  final bool visibleOnDelivery;

  /// Updated: store a `MenuAvailability` instead of a generic map
  final MenuAvailability? availability;

  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? settings;

  MenuModel({
    required this.menuId,
    required this.venueId,
    required this.menuName,
    required this.description,
    required this.notes,
    this.imageUrl,
    this.sections = const [],
    this.isOnline = true,
    this.visibleOnTablet = true,
    this.visibleOnQr = true,
    this.visibleOnPickup = false,
    this.visibleOnDelivery = false,
    this.availability, // now a MenuAvailability
    DateTime? createdAt,
    DateTime? updatedAt,
    this.settings,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'venueId': venueId,
      'menuName': menuName,
      'description': description,
      'notes': notes,
      'imageUrl': imageUrl,
      'sections': sections.map((s) => s.toMap()).toList(),
      'isOnline': isOnline,
      'visibleOnTablet': visibleOnTablet,
      'visibleOnQr': visibleOnQr,
      'visibleOnPickup': visibleOnPickup,
      'visibleOnDelivery': visibleOnDelivery,
      // If availability != null, store availability.toMap()
      'availability': availability?.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'settings': settings,
    };
  }

  // Create from Map
  factory MenuModel.fromMap(Map<String, dynamic> map, String menuId) {
    return MenuModel(
      menuId: menuId,
      venueId: map['venueId'] ?? '',
      menuName: Map<String, String>.from(map['menuName'] ?? {}),
      description: Map<String, String>.from(map['description'] ?? {}),
      notes: Map<String, String>.from(map['notes'] ?? {}),
      imageUrl: map['imageUrl'],
      sections: (map['sections'] as List<dynamic>?)
              ?.map((sectionMap) =>
                  MenuSection.fromMap(Map<String, dynamic>.from(sectionMap)))
              .toList() ??
          [],

      isOnline: map['isOnline'] ?? true,
      visibleOnTablet: map['visibleOnTablet'] ?? true,
      visibleOnQr: map['visibleOnQr'] ?? true,
      visibleOnPickup: map['visibleOnPickup'] ?? false,
      visibleOnDelivery: map['visibleOnDelivery'] ?? false,
      // Convert to MenuAvailability if not null
      availability: map['availability'] != null
          ? MenuAvailability.fromMap(
              Map<String, dynamic>.from(map['availability']))
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      settings: map['settings'] != null
          ? Map<String, dynamic>.from(map['settings'])
          : null,
    );
  }

  MenuModel copyWith({
    String? menuId,
    String? venueId,
    Map<String, String>? menuName,
    Map<String, String>? description,
    Map<String, String>? notes,
    String? imageUrl,
    List<String>? additionalImages,
    List<MenuSection>? sections,
    bool? isActive,
    bool? isOnline,
    bool? visibleOnTablet,
    bool? visibleOnQr,
    bool? visibleOnPickup,
    bool? visibleOnDelivery,
    MenuAvailability? availability,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? settings,
  }) {
    return MenuModel(
      menuId: menuId ?? this.menuId,
      venueId: venueId ?? this.venueId,
      menuName: menuName ?? this.menuName,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      sections: sections ?? this.sections,
      isOnline: isOnline ?? this.isOnline,
      visibleOnTablet: visibleOnTablet ?? this.visibleOnTablet,
      visibleOnQr: visibleOnQr ?? this.visibleOnQr,
      visibleOnPickup: visibleOnPickup ?? this.visibleOnPickup,
      visibleOnDelivery: visibleOnDelivery ?? this.visibleOnDelivery,
      availability: availability ?? this.availability,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      settings: settings ?? this.settings,
    );
  }
}
