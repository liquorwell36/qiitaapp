import 'dart:convert';

import '../models/user.dart';

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
