import 'package:aureola_platform/models/section/section_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import your MenuSection model, if it too needs multilingual fields, update similarly

class MenuModel {
  final String menuId;
  final String venueId;

  /// Store menuName as a multilingual map.
  /// Example: { "en": "Breakfast Menu", "ar": "قائمة الإفطار" }
  final Map<String, String> menuName;

  /// Store description as a multilingual map.
  /// Example: { "en": "Morning delights", "ar": "وجبات صباحية لذيذة" }
  final Map<String, String> description;

  /// Store notes or disclaimers as a multilingual map.
  /// Example: { "en": "Allergen info ...", "ar": "تفاصيل مسببات الحساسية ..." }
  final Map<String, String> notes;

  /// If you have a single primary image for this menu, you can store its URL.
  /// Or, if you want multiple images, store them in a list of URLs.
  final String? imageUrl;

  /// Additional or multiple images
  final List<String> additionalImages;

  /// The menu sections (e.g., "Starters," "Main Courses," etc.)
  final List<MenuSection> sections;

  /// Whether the menu is currently published/active
  final bool isActive;

  /// Visibility toggles
  final bool isOnline;
  final bool visibleOnTablet;
  final bool visibleOnQr;
  final bool visibleOnPickup;
  final bool visibleOnDelivery;

  /// You might have an `availability` object or map describing when this menu is available
  final Map<String, dynamic>? availability;

  /// Create/Update timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Arbitrary settings or metadata
  final Map<String, dynamic>? settings;

  MenuModel({
    required this.menuId,
    required this.venueId,
    required this.menuName,
    required this.description,
    required this.notes,
    this.imageUrl,
    this.additionalImages = const [],
    this.sections = const [],
    this.isActive = true,
    this.isOnline = true,
    this.visibleOnTablet = true,
    this.visibleOnQr = true,
    this.visibleOnPickup = false,
    this.visibleOnDelivery = false,
    this.availability,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.settings,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // ---------------------------
  //  toMap()
  // ---------------------------
  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'venueId': venueId,

      // Store these maps directly
      'menuName': menuName,
      'description': description,
      'notes': notes,

      'imageUrl': imageUrl,
      'additionalImages': additionalImages,

      // Convert each MenuSection to a Map
      'sections': sections.map((section) => section.toMap()).toList(),

      'isActive': isActive,
      'isOnline': isOnline,
      'visibleOnTablet': visibleOnTablet,
      'visibleOnQr': visibleOnQr,
      'visibleOnPickup': visibleOnPickup,
      'visibleOnDelivery': visibleOnDelivery,

      'availability': availability,

      // Timestamps
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),

      'settings': settings,
    };
  }

  // ---------------------------
  //  fromMap()
  // ---------------------------
  factory MenuModel.fromMap(Map<String, dynamic> map, String menuId) {
    return MenuModel(
      menuId: menuId,
      venueId: map['venueId'] ?? '',
      menuName: Map<String, String>.from(map['menuName'] ?? {}),
      description: Map<String, String>.from(map['description'] ?? {}),
      notes: Map<String, String>.from(map['notes'] ?? {}),
      imageUrl: map['imageUrl'],
      additionalImages: List<String>.from(map['additionalImages'] ?? const []),
      sections: (map['sections'] as List<dynamic>?)
              ?.map((sectionMap) =>
                  MenuSection.fromMap(Map<String, dynamic>.from(sectionMap)))
              .toList() ??
          [],
      isActive: map['isActive'] ?? true,
      isOnline: map['isOnline'] ?? true,
      visibleOnTablet: map['visibleOnTablet'] ?? true,
      visibleOnQr: map['visibleOnQr'] ?? true,
      visibleOnPickup: map['visibleOnPickup'] ?? false,
      visibleOnDelivery: map['visibleOnDelivery'] ?? false,
      availability: map['availability'] != null
          ? Map<String, dynamic>.from(map['availability'])
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

  // ---------------------------
  //  copyWith()
  // ---------------------------
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
    Map<String, dynamic>? availability,
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
      additionalImages: additionalImages ?? this.additionalImages,
      sections: sections ?? this.sections,
      isActive: isActive ?? this.isActive,
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

  @override
  String toString() {
    return 'MenuModel(menuId: $menuId, '
        'venueId: $venueId, '
        'menuName: $menuName, '
        'description: $description, '
        'notes: $notes, '
        'imageUrl: $imageUrl, '
        'additionalImages: $additionalImages, '
        'sections: $sections, '
        'isActive: $isActive, '
        'isOnline: $isOnline, '
        'visibleOnTablet: $visibleOnTablet, '
        'visibleOnQr: $visibleOnQr, '
        'visibleOnPickup: $visibleOnPickup, '
        'visibleOnDelivery: $visibleOnDelivery, '
        'availability: $availability, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'settings: $settings)';
  }
}
