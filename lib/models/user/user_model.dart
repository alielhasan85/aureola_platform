/* account setting to control the page of the client (will have access to read write menu and access to report also he will pay), 
the user will have this data: 
 - personal information: 
    first name 
    last name
    job title
    comnpany name
 - login information
    email 
    password 
    phone number
  - email notification
  - SMS notificatio
  - teams  (maybe need to creat a new model for team)
  - subscription {base , essential, premium}
  - invoice
  - billing and card


*/
// user_model.dart

import 'package:aureola_platform/models/common/address.dart';
import 'package:aureola_platform/models/common/contact.dart';
import 'package:aureola_platform/models/user/notification.dart';

import 'package:aureola_platform/models/user/user_setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'payment.dart';

class UserModel {
  final String userId;
  final String name;
  final String jobTitle;
  final Contact contact;
  final Address address;
  final String businessName;
  final Notifications notifications;
  final List<String> staff;
  final DateTime createdAt;
  final int loginCount;
  final String subscriptionType;
  final double totalPaid;
  final List<Payment> paymentHistory;
  final bool isActive;
  final DateTime? lastLogin;
  final UserSettings? userSettings;

  UserModel({
    required this.userId,
    required this.name,
    required this.contact,
    required this.address,
    required this.businessName,
    this.jobTitle = '',
    this.notifications = const Notifications(),
    this.staff = const [],
    DateTime? createdAt,
    this.loginCount = 0,
    this.subscriptionType = 'free',
    this.totalPaid = 0.0,
    this.paymentHistory = const [],
    this.isActive = true,
    this.lastLogin,
    this.userSettings,
  }) : createdAt = createdAt ?? DateTime.now();

  UserModel copyWith({
    String? name,
    String? jobTitle,
    Contact? contact,
    Address? address,
    String? businessName,
    Notifications? notifications,
    List<String>? staff,
    DateTime? createdAt,
    int? loginCount,
    String? subscriptionType,
    double? totalPaid,
    List<Payment>? paymentHistory,
    bool? isActive,
    DateTime? lastLogin,
    UserSettings? userSettings,
  }) {
    return UserModel(
      userId: this.userId, // userId remains unchanged
      name: name ?? this.name,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      businessName: businessName ?? this.businessName,
      jobTitle: jobTitle ?? this.jobTitle,
      notifications: notifications ?? this.notifications,
      staff: staff ?? this.staff,
      createdAt: createdAt ?? this.createdAt,
      loginCount: loginCount ?? this.loginCount,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      totalPaid: totalPaid ?? this.totalPaid,
      paymentHistory: paymentHistory ?? this.paymentHistory,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
      userSettings: userSettings ?? this.userSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'jobTitle': jobTitle,
      'contact': contact.toMap(),
      'address': address.toMap(),
      'businessName': businessName,
      'notifications': notifications.toMap(),
      'staff': staff,
      'createdAt': createdAt,
      'loginCount': loginCount,
      'subscriptionType': subscriptionType,
      'totalPaid': totalPaid,
      'paymentHistory': paymentHistory.map((p) => p.toMap()).toList(),
      'isActive': isActive,
      'lastLogin': lastLogin,
      'userSettings': userSettings?.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String userId) {
    return UserModel(
      userId: userId,
      name: map['name'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      contact: Contact.fromMap(map['contact'] ?? {}),
      address: Address.fromMap(map['address'] ?? {}),
      businessName: map['businessName'] ?? '',
      notifications: Notifications.fromMap(map['notifications'] ?? {}),
      staff: List<String>.from(map['staff'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      loginCount: map['loginCount'] ?? 0,
      subscriptionType: map['subscriptionType'] ?? 'free',
      totalPaid: (map['totalPaid'] as num?)?.toDouble() ?? 0.0,
      paymentHistory: (map['paymentHistory'] as List<dynamic>?)
              ?.map((p) => Payment.fromMap(p))
              .toList() ??
          [],
      isActive: map['isActive'] ?? true,
      lastLogin: (map['lastLogin'] as Timestamp?)?.toDate(),
      userSettings: map['userSettings'] != null
          ? UserSettings.fromMap(map['userSettings'])
          : null,
    );
  }
}
