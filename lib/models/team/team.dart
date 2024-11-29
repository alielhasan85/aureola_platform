// to add model for the staff of our client
// he will have access to reservation page and manager dashboard (here we see ocupied tables, orders time of the order
// staff who serving the table)

class StaffModel {
  String id; // Firebase UID
  final String name; // Required
  final String email; // Retrieved from FirebaseAuth
  final String phoneNumber; // Required
  final String jobTitle; // Required
  final String role; // Role within the platform (e.g., manager, waiter)
  final bool isActive; // Employment status
  final List<String> assignedTables; // List of assigned tables
  final List<String> assignedOrders; // List of assigned orders
  final DateTime hireDate; // Date of hire
  final List<String> shifts; // List of assigned shifts
  final List<String> permissions; // List of permissions

  StaffModel({
    this.id = '',
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.jobTitle,
    this.role = 'staff', // Default role is 'staff'
    this.isActive = true, // Default to active
    this.assignedTables = const [],
    this.assignedOrders = const [],
    DateTime? hireDate,
    this.shifts = const [],
    this.permissions = const [], // Default to an empty list
  }) : hireDate = hireDate ?? DateTime.now(); // Default to now if not provided

  // Convert a StaffModel into a Map. The keys must correspond to the names of the fields in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'jobTitle': jobTitle,
      'role': role,
      'isActive': isActive,
      'assignedTables': assignedTables,
      'assignedOrders': assignedOrders,
      'hireDate': hireDate.toIso8601String(),
      'shifts': shifts,
      'permissions': permissions,
    };
  }

  // Create a StaffModel from a Map (from Firestore).
  factory StaffModel.fromMap(Map<String, dynamic> map, String id) {
    return StaffModel(
      id: id,
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      jobTitle: map['jobTitle'],
      role: map['role'] ?? 'staff',
      isActive: map['isActive'] ?? true,
      assignedTables: List<String>.from(map['assignedTables'] ?? []),
      assignedOrders: List<String>.from(map['assignedOrders'] ?? []),
      hireDate: DateTime.parse(map['hireDate']),
      shifts: List<String>.from(map['shifts'] ?? []),
      permissions: List<String>.from(map['permissions'] ?? []),
    );
  }
}
