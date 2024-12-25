class MenuItem {
  final String itemId;

  /// Multilingual name, e.g. { "en": "Caesar Salad", "ar": "سلطة سيزر" }
  final Map<String, String> itemName;

  /// Multilingual description, e.g. { "en": "Crisp romaine, croutons...", "ar": "وصف للسلطة..." }
  final Map<String, String> description;

  final double price;
  final String imageUrl;
  final bool isAvailable;
  final List<String> dietaryTags;
  final List<String> availability;

  MenuItem({
    required this.itemId,
    required this.itemName,
    required this.description,
    required this.price,
    this.imageUrl = '',
    this.isAvailable = true,
    this.dietaryTags = const [],
    this.availability = const ['dine-in', 'takeaway', 'delivery'],
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      // Store the multilingual maps directly
      'itemName': itemName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'dietaryTags': dietaryTags,
      'availability': availability,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      itemId: map['itemId'],
      // Convert to Map<String, String> (fallback to empty map if null).
      itemName: Map<String, String>.from(map['itemName'] ?? {}),
      description: Map<String, String>.from(map['description'] ?? {}),
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      dietaryTags: List<String>.from(map['dietaryTags'] ?? []),
      availability: List<String>.from(
          map['availability'] ?? ['dine-in', 'takeaway', 'delivery']),
    );
  }

  MenuItem copyWith({
    String? itemId,
    Map<String, String>? itemName,
    Map<String, String>? description,
    double? price,
    String? imageUrl,
    bool? isAvailable,
    List<String>? dietaryTags,
    List<String>? availability,
  }) {
    return MenuItem(
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      dietaryTags: dietaryTags ?? this.dietaryTags,
      availability: availability ?? this.availability,
    );
  }

  @override
  String toString() {
    return 'MenuItem(itemId: $itemId, '
        'itemName: $itemName, '
        'description: $description, '
        'price: $price, '
        'imageUrl: $imageUrl, '
        'isAvailable: $isAvailable, '
        'dietaryTags: $dietaryTags, '
        'availability: $availability)';
  }
}
