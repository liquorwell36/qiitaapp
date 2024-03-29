import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:qiitaapp/models/articles.dart';
import 'package:qiitaapp/models/user.dart';
import 'package:qiitaapp/Repository/qiita_repository.dart';
import 'package:qiitaapp/screens/article_screen.dart';

import '../Screens/top_screen.dart';
import '../components/article_card.dart';

class StockScreen extends StatefulWidget {
  StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: FutureBuilder(
                future: getStock(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null || snapshot.data.length == 0) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("ログインするとストックした記事の一覧表示されます。"),
                            const SizedBox(height: 8),
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  side: const BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  )),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const TopScreen()),
                                );
                              },
                              child: const Text(
                                "ログイン",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      List<Article> articleList = snapshot.data!;
                      return ListView(
                        children: articleList.map((value) {
                          return Material(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ArticleScreen(
                                      article: value,
                                    ),
                                  ),
                                );
                              },
                              child: ArticleCard(
                                title: value.title,
                                author: value.user.id,
                                profileImageIcon: value.user.profileImageUrl,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                  } else {
                    return const Text("Not connect.");
                  }
                  return const Text("Not found stock data.");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  getStock() async {
    var user = await QiitaRepository().getAuthenticatedUser();
    return QiitaRepository().fetchUserArticleList(userID: user.id);
  }
}
