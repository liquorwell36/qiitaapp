import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qiitaapp/Models/tag.dart';
import 'package:qiitaapp/models/articles.dart';
import 'package:qiitaapp/models/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

class QiitaRepository {
  final clientID = "37ee46ec113748bb8a4a1dcaf873387db3b28356";
  final clientSecret = "e7dd2d81abda5ee86e0cf3eb09300a4c0bb84411";
  final keyAccessToken = 'qiita/accessToken';

  String createAuthUrl(String state) {
    const scope = 'read_qiita';
    return 'https://qiita.com/api/v2/oauth/authorize?client_id=$clientID&scope=$scope&state=$state';
  }

  Future<List<Article>> fetchArticleList({
    int page = 1,
    String? searchText,
    String? tagID,
    String? userID,
  }) async {
    String url;
    if (searchText != null) {
      url = "https://qiita.com/api/v2/items?page=$page&query=$searchText";
    } else if (tagID != null) {
      url = "https://qiita.com/api/v2/tags/$tagID/items?page=$page";
    } else if (userID != null) {
      url = "https://qiita.com/api/v2/users/$userID/stocks?page=$page";
    } else {
      url = "https://qiita.com/api/v2/items?page=$page";
    }

    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    final articleList = (body as List<dynamic>).map((article) {
      return Article(
        title: article['title'],
        url: article['url'],
        renderedBody: article['rendered_body'],
        user: User(
          id: article['user']['id'] ?? "",
          profileImageUrl: article['user']['profile_image_url'] ?? "",
          name: article['user']['name'] ?? "",
          description: article['user']['description'] ?? "",
          itemsCount: article['user']['items_count'] ?? 0,
          followersCount: article['user']['followers_count'] ?? 0,
        ),
      );
    }).toList();
    return articleList;
  }

  Future<List<Article>> fetchUserArticleList({
    int page = 1,
    String? userID,
  }) async {
    String url = "https://qiita.com/api/v2/users/$userID/stocks?page=$page";
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
          itemsCount: article['user']['items_count'],
          followersCount: article['user']['followers_count'],
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
      id: map['id'] ?? "",
      profileImageUrl: map['profile_image_url'] ?? "",
      name: map['name'] ?? "",
      description: map['description'] ?? "",
      itemsCount: map['items_count'] ?? 0,
      followersCount: map['followers_count'] ?? 0,
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

  Future<List<Tag>> getTagList({int page = 1}) async {
    String url = "https://qiita.com/api/v2/tags?page=$page&sort=count";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'content-type': 'application/json',
      },
    );
    final body = jsonDecode(response.body);
    final tagsList = (body as List<dynamic>).map((item) {
      return Tag(
        followersCount: item['followers_count'],
        iconUrl: item['icon_url'],
        id: item['id'],
        itemsCount: item['items_count'],
      );
    }).toList();
    return tagsList;
  }
}
