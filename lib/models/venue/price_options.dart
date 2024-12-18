// price_options.dart

class PriceOptions {
  PriceOptions();

  /// Creates a copy of this [PriceOptions].
  /// Since there are no fields currently, it simply returns a new instance.
  /// This method should be updated when fields are added to the [PriceOptions] class.
  PriceOptions copyWith() {
    return PriceOptions();
  }

  /// Converts this [PriceOptions] instance into a map.
  /// Currently, it returns an empty map but should include fields when they are added.
  Map<String, dynamic> toMap() {
    return {};
  }

  /// Creates a [PriceOptions] instance from a map.
  /// Currently, it ignores the map content but should initialize fields when they are added.
  factory PriceOptions.fromMap(Map<String, dynamic> map) {
    return PriceOptions();
  }

  @override
  String toString() {
    return 'PriceOptions()';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PriceOptions;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}
