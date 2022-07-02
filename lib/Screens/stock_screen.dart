import 'package:flutter/material.dart';
import 'package:qiitaapp/models/articles.dart';
import 'package:qiitaapp/Repository/qiita_repository.dart';
import 'package:qiitaapp/Screens/article_screen.dart';

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
                  if (snapshot.hasData) {
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
                  } else {
                    return const Text("サインインするとストックが一覧表示されます。");
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  getStock() async {
    var user = await QiitaRepository().getAuthenticatedUser();
    return QiitaRepository().fetchUserArticleList(userID: user.id);
  }
}
