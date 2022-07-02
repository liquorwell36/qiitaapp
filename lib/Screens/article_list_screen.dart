import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qiitaapp/models/articles.dart';

import 'package:qiitaapp/screens/article_screen.dart';

import '../Repository/qiita_repository.dart';
import '../components/article_card.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({Key? key, this.searchString, this.tagID})
      : super(key: key);
  final String? searchString;
  final String? tagID;

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: FutureBuilder<List<Article>>(
                  future: QiitaRepository().fetchArticleList(
                    searchText: widget.searchString,
                    tagID: widget.tagID,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Article> articleList = snapshot.data!;
                      return ListView(
                        children: articleList.map((article) {
                          return Material(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ArticleScreen(
                                      article: article,
                                    ),
                                  ),
                                );
                              },
                              child: ArticleCard(
                                title: article.title,
                                author: article.user.id,
                                profileImageIcon: article.user.profileImageUrl,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return const Text("not found API data");
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
