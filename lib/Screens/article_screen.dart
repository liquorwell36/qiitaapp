import 'package:flutter/material.dart';
import 'package:qiitaapp/models/articles.dart';
import 'package:flutter_html/flutter_html.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;

  const ArticleScreen({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
                alignment: Alignment.centerLeft,
                child: Text(
                  article.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Html(
                data: article.renderedBody,
                style: {
                  'h2': Style(
                    border: const Border(
                      bottom: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                  ),
                  'p code': Style(
                    backgroundColor: Colors.blueGrey[100],
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  '.code-frame': Style(
                    color: Colors.white,
                    backgroundColor: Colors.blueGrey[900],
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  '.code-lang span': Style(
                    backgroundColor: Colors.blueGrey[300],
                    display: Display.INLINE_BLOCK,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  'pre': Style(
                    padding: const EdgeInsets.only(top: 16),
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
