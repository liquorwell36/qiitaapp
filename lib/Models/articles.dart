import 'dart:convert';

class Article {
  final String title;
  final String url;
  final String renderedBody;
  final User user;

  Article({
    required this.title,
    required this.url,
    required this.renderedBody,
    required this.user,
  });

  Article.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        url = json['url'],
        renderedBody = json['rendered_body'],
        user = User.fromJson(json['user']);

  Map<String, dynamic> toJson() => {
        'title': title,
        'url': url,
      };
}

class User {
  final String id;
  final String profileImageUrl;

  User({
    required this.id,
    required this.profileImageUrl,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        profileImageUrl = json['profile_image_url'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'profile_image_url': profileImageUrl,
      };
}
