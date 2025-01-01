import 'package:aureola_platform/models/menu/menu_availability.dart';

class MenuModel {
  final String menuId;
  final String venueId;

  /// For multi-lingual display
  final Map<String, String> menuName;
  final Map<String, String> description;
  final Map<String, String> notes;

  final String? imageUrl;

  /// If you want to reorder the list of menus, store an integer:
  final int sortOrder;

  /// Visibility & availability
  final bool isOnline;
  final bool visibleOnTablet;
  final bool visibleOnQr;
  final bool visibleOnPickup;
  final bool visibleOnDelivery;

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
    this.sortOrder = 0,
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

  MenuModel copyWith({
    String? menuId,
    String? venueId,
    Map<String, String>? menuName,
    Map<String, String>? description,
    Map<String, String>? notes,
    String? imageUrl,
    int? sortOrder,
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
      sortOrder: sortOrder ?? this.sortOrder,
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

  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'venueId': venueId,
      'menuName': menuName,
      'description': description,
      'notes': notes,
      'imageUrl': imageUrl,
      'sortOrder': sortOrder,
      'isOnline': isOnline,
      'visibleOnTablet': visibleOnTablet,
      'visibleOnQr': visibleOnQr,
      'visibleOnPickup': visibleOnPickup,
      'visibleOnDelivery': visibleOnDelivery,
      'availability': availability?.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'settings': settings,
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map, String menuId) {
    return MenuModel(
      menuId: menuId,
      venueId: map['venueId'] ?? '',
      menuName: Map<String, String>.from(map['menuName'] ?? {}),
      description: Map<String, String>.from(map['description'] ?? {}),
      notes: Map<String, String>.from(map['notes'] ?? {}),
      imageUrl: map['imageUrl'],
      sortOrder: map['sortOrder'] ?? 0,
      isOnline: map['isOnline'] ?? true,
      visibleOnTablet: map['visibleOnTablet'] ?? true,
      visibleOnQr: map['visibleOnQr'] ?? true,
      visibleOnPickup: map['visibleOnPickup'] ?? false,
      visibleOnDelivery: map['visibleOnDelivery'] ?? false,
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


}
