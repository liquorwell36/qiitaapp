import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qiitaapp/client_id.dart';
import 'package:qiitaapp/models/tag.dart';
import 'package:qiitaapp/models/articles.dart';
import 'package:qiitaapp/models/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

class QiitaRepository {
  final clientID = CLIENT_ID;
  final clientSecret = CLIENT_SECRET;
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
        createdAt: DateTime.parse(article['created_at']),
        updatedAt: DateTime.parse(article['updated_at']),
        tags: (article['tags'] as List<dynamic>).map((tag) {
          return Tags(
              name: tag['name'],
              versions: (tag['versions'] as List<dynamic>)
                  .map((v) => v as String)
                  .toList());
        }).toList(),
      );
    }).toList();
    return articleList;
  }

  Future<List<Article>> fetchUserArticleList({
    int page = 1,
    String? userID,
  }) async {
    String url = "https://qiita.com/api/v2/users/$userID/stocks?page=$page";
    print(url);
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
        createdAt: DateTime.parse(article['created_at']),
        updatedAt: DateTime.parse(article['updated_at']),
        tags: (article['tags'] as List<dynamic>).map((tag) {
          return Tags(
              name: tag['name'],
              versions: (tag['versions'] as List<dynamic>)
                  .map((v) => v as String)
                  .toList());
        }).toList(),
      );
    }).toList();
    print(articleList.length);
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

  bool isAccessToken() {
    final accessToken = getAccessToken();
    if (accessToken == null) {
      return false;
    } else {
      return true;
    }
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
    final body = await jsonDecode(response.body);
    if (body is Map<String, dynamic>) {
      print("リクエスト回数が超えてしまった。。。");
    }
    final tagsList = (body as List<dynamic>).map((item) {
      return Tag(
        followers_count: item['followers_count'],
        icon_url: item['icon_url'],
        id: item['id'],
        items_count: item['items_count'],
      );
    }).toList();
    return tagsList;
  }
}
