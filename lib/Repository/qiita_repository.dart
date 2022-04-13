import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qiitaapp/models/articles.dart';
import 'package:qiitaapp/models/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

class QiitaRepository {
  final clientID = "37ee46ec113748bb8a4a1dcaf873387db3b28356";
  final clientSecret = "e7dd2d81abda5ee86e0cf3eb09300a4c0bb84411";
  final keyAccessToken = 'qiita/accessToken';

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
          profileImageUrl: article['user']['profile_image_url'],
          name: article['user']['name'],
          description: article['user']['description'],
          itemsCount: article['user']['itemsCount'],
          followersCount: article['user']['followersCount'],
        ),
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
          profileImageUrl: article['user']['profile_image_url'],
          name: article['user']['name'],
          description: article['user']['description'],
          itemsCount: article['user']['itemsCount'],
          followersCount: article['user']['followersCount'],
        ),
      );
    }).toList();

    return articleList;
  }

  createAccessTokenFromCallbackUri(Uri uri, String expectedState) async {
    final String? state = uri.queryParameters['state'];
    final String? code = uri.queryParameters['code'];

    if (expectedState != state) {
      throw Exception('The state is different from expectedState.');
    }
    final response = await http.post(
      Uri.parse('https://qiita.com/api/v2/access_tokens'),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'client_id': clientID,
        'client_secret': clientSecret,
        'code': code,
      }),
    );

    final body = jsonDecode(response.body);
    final accessToken = body['token'];

    return accessToken;
  }

  Future<void> saveAccessToken(accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyAccessToken, accessToken);
  }

  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyAccessToken);
  }

  Future<void> deleteAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyAccessToken);
  }

  Future<bool> accessTokenIsSaved() async {
    final accessToken = await getAccessToken();
    return accessToken != null;
  }

  Future<User> getAuthenticatedUser() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('https://qiita.com/api/v2/authenticated_user'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final body = jsonDecode(response.body);
    final user = _mapToUser(body);
    return user;
  }

  _mapToUser(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      profileImageUrl: map['profile_image_url'],
      name: map['name'],
      description: map['description'],
      itemsCount: map['itemsCount'],
      followersCount: map['followersCount'],
    );
  }

  Future<void> revokeSavedAccessToken() async {
    final accessToken = await getAccessToken();
    final response = await http.delete(
      Uri.parse('https://qiita.com/api/v2/access_tokens/$accessToken'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to revoke the access token');
    }
  }
}
