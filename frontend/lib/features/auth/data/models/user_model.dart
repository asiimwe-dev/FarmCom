import 'package:farmcom/core/domain/entities/user.dart';

/// User DTO - JSON serializable
class UserModel extends User {
  const UserModel({
    required String id,
    required String phone,
    String? name,
    String? profilePicture,
    String? bio,
    required DateTime createdAt,
    DateTime? lastSignIn,
    required bool isLoggedIn,
    String? region,
    List<String> interests = const [],
  }) : super(
    id: id,
    phone: phone,
    name: name,
    profilePicture: profilePicture,
    bio: bio,
    createdAt: createdAt,
    lastSignIn: lastSignIn,
    isLoggedIn: isLoggedIn,
    region: region,
    interests: interests,
  );

  /// Create from JSON (from Supabase)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      lastSignIn: json['last_sign_in'] != null
          ? DateTime.parse(json['last_sign_in'])
          : null,
      isLoggedIn: json['is_logged_in'] ?? false,
      region: json['region'],
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  /// Convert to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'profile_picture': profilePicture,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
      'last_sign_in': lastSignIn?.toIso8601String(),
      'is_logged_in': isLoggedIn,
      'region': region,
      'interests': interests,
    };
  }

  /// Convert domain User to model
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      phone: user.phone,
      name: user.name,
      profilePicture: user.profilePicture,
      bio: user.bio,
      createdAt: user.createdAt,
      lastSignIn: user.lastSignIn,
      isLoggedIn: user.isLoggedIn,
      region: user.region,
      interests: user.interests,
    );
  }
}
