import 'dart:convert';

import '../models/user.dart';

class Article {
  final String title;
  final String url;
  final String renderedBody;
  final User user;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Tags> tags;

  Article({
    required this.title,
    required this.url,
    required this.renderedBody,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
  });
}

class Tags {
  final String name;
  final List<String> versions;

  Tags({
    required this.name,
    required this.versions,
  });
}
