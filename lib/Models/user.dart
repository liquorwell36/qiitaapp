import 'dart:convert';

class User {
  final String id;
  final String profileImageUrl;
  final String description;
  final String name;
  final int itemsCount;
  final int followersCount;

  User({
    required this.id,
    required this.profileImageUrl,
    required this.description,
    required this.name,
    required this.itemsCount,
    required this.followersCount,
  });

  // User.fromJson(Map<String, dynamic> json)
  //     : id = json['id'],
  //       profileImageUrl = json['profile_image_url'];

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'profile_image_url': profileImageUrl,
  //     };
}
