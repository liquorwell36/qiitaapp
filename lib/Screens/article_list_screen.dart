import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qiitaapp/models/articles.dart';

import 'package:qiitaapp/screens/article_screen.dart';

import '../Repository/qiita_repository.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({Key? key, this.searchString, this.tagID})
      : super(key: key);
  final String? searchString;
  final String? tagID;

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  var _currentPage = 1;
  List<Article> _articleList = [];
  Object? _error;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadArticleList(1);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Text(_error.toString()),
      );
    }

    if (_articleList != null) {
      return _articleListView(
        articleList: _articleList,
        onTapArticle: (Article article) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ArticleScreen(article: article)),
          );
        },
        onScrollEnd: () {
          if (_isLoading == false) {
            _loadArticleList(_currentPage + 1);
          }
        },
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _loadArticleList(int page) {
    QiitaRepository()
        .fetchArticleList(
            page: page, searchText: widget.searchString, tagID: widget.tagID)
        .then((value) {
      setState(() {
        if (page == 1) {
          _articleList = value;
        } else {
          _articleList.addAll(value);
        }
        _currentPage = page;
      });
    }).catchError((e) {
      setState(() {
        _error = e;
      });
    }).whenComplete(() {
      _isLoading = false;
    });
    _isLoading = true;
  }
}

class _articleListView extends StatelessWidget {
  final List<Article> articleList;
  final Function(Article article) onTapArticle;
  final Function() onScrollEnd;

  const _articleListView({
    Key? key,
    required this.articleList,
    required this.onTapArticle,
    required this.onScrollEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter == 0.0) {
          onScrollEnd();
        }
        return true;
      },
      child: ListView.builder(
        itemBuilder: (context, index) {
          final Article article = articleList[index];
          return InkWell(
            onTap: () => onTapArticle(article),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: articleCard(
                  title: article.title,
                  author: article.user.id,
                  profileImageIcon: article.user.profileImageUrl),
            ),
          );
        },
        itemCount: articleList.length,
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
            child: FadeInImage(
              placeholder: const AssetImage("assets/person_filled.png"),
              image: NetworkImage(profileImageIcon),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset("assets/person_filled.png");
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
