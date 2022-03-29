import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qiitaapp/models/articles.dart';

class QiitaRepository {
  final clientID = "37ee46ec113748bb8a4a1dcaf873387db3b28356";
  final clientSecret = "e7dd2d81abda5ee86e0cf3eb09300a4c0bb84411";

  String createAuthUrl(String state) {
    final scope = 'read_qiita';
    return 'https://qiita.com/api/v2/oauth/authorize?client_id=$clientID&scope=$scope&state=$state';
  }

  Future<List<Article>> getArticleList({int page = 1}) async {
    String url = "https://qiita.com/api/v2/items?page=$page";

    final response = await http.get(
      Uri.parse(url),
    );
    final body = jsonDecode(response.body);
    final articleList = (body as List<dynamic>).map((article) {
      return Article(
        title: article['title'],
        url: article['url'],
        renderedBody: article['rendered_body'],
        user: User(
            id: article['user']['id'],
            profileImageUrl: article['user']['profile_image_url']),
      );
    }).toList();
    return articleList;
  }

  Future<List<Article>> searchArticleList({
    int page = 1,
    required String searchText,
  }) async {
    String url = "https://qiita.com/api/v2/items?page=$page&query=$searchText";
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    final articleList = (body as List<dynamic>).map((article) {
      return Article(
        title: article['title'],
        url: article['url'],
        renderedBody: article['rendered_body'],
        user: User(
            id: article['user']['id'],
            profileImageUrl: article['user']['profile_image_url']),
      );
    }).toList();

    return articleList;
  }
}
