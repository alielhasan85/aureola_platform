enum AvailabilityType {
  always,
  periodic,
  specific, // a specific date range
}

class MenuAvailability {
  final AvailabilityType type;

  /// For periodic availability:
  /// E.g. ["monday", "tuesday"], or numeric [1,2] for Mon/Tue. Up to you.
  final List<String> daysOfWeek;

  /// Start/end times in "HH:mm" format, or use your own approach (e.g. DateTime).
  final String? startTime; // e.g., "06:00"
  final String? endTime; // e.g., "11:00"

  /// For specific date ranges:
  /// We store them as ISO strings or as a DateTime field.
  final DateTime? startDate;
  final DateTime? endDate;

  MenuAvailability({
    required this.type,
    this.daysOfWeek = const [],
    this.startTime,
    this.endTime,
    this.startDate,
    this.endDate,
  });

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'type': type
          .toString()
          .split('.')
          .last, // "always", "periodic", or "specific"
      'daysOfWeek': daysOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  /// Build from Firestore Map
  factory MenuAvailability.fromMap(Map<String, dynamic> map) {
    // Parse the type string back to enum
    final typeString = map['type'] as String? ?? 'always';
    AvailabilityType parsedType = AvailabilityType.always;
    if (typeString == 'periodic') parsedType = AvailabilityType.periodic;
    if (typeString == 'specific') parsedType = AvailabilityType.specific;

    return MenuAvailability(
      type: parsedType,
      daysOfWeek: List<String>.from(map['daysOfWeek'] ?? []),
      startTime: map['startTime'],
      endTime: map['endTime'],
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }

  @override
  String toString() {
    return 'MenuAvailability(type: $type, '
        'daysOfWeek: $daysOfWeek, '
        'startTime: $startTime, endTime: $endTime, '
        'startDate: $startDate, endDate: $endDate)';
  }
}
