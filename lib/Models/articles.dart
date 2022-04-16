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
}
