import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qiitaapp/models/articles.dart';

import 'package:qiitaapp/screens/article_screen.dart';

import '../Repository/qiita_repository.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({Key? key, required this.searchString})
      : super(key: key);
  final String searchString;

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  @override
  Widget build(BuildContext context) {
    var _functionType = (widget.searchString == "")
        ? QiitaRepository().getArticleList()
        : QiitaRepository().searchArticleList(searchText: widget.searchString);

    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: FutureBuilder<List<Article>>(
                  future: _functionType,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Article> articleList = snapshot.data!;

                      return ListView(
                        children: articleList.map((article) {
                          return Material(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ArticleScreen(
                                          article: article,
                                        )));
                                print("tappped URL: ${article.url}");
                                print(
                                    "tapped Image URL: ${article.user.profileImageUrl}");
                                print("Function Type: ${_functionType}");
                              },
                              child: articleCard(
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

class articleCard extends StatelessWidget {
  const articleCard({
    Key? key,
    required this.title,
    required this.author,
    required this.profileImageIcon,
  }) : super(key: key);

  final String title;
  final String author;
  final String profileImageIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          child: ClipRRect(
            child: Image.network(
              profileImageIcon,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                  size: 32,
                );
              },
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(author),
      ),
    );
  }
}
