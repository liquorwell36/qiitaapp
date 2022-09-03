import 'package:flutter/material.dart';
import 'package:qiitaapp/models/articles.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qiitaapp/screens/tag_results_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;

  const ArticleScreen({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String htmlData = article.renderedBody;
    initializeDateFormatting('ja');

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    _UserProfileIcon(
                        size: 32,
                        profileImageUrl: article.user.profileImageUrl),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(article.user.id),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text("投稿日 " + _showDate(article.createdAt)),
                    const SizedBox(width: 8),
                    Text("更新日 " + _showDate(article.updatedAt)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                alignment: Alignment.centerLeft,
                child: Text(
                  article.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(Icons.tag),
                    _TagList(tags: article.tags),
                  ],
                ),
              ),
              Html(
                data: article.renderedBody,
                onLinkTap: (String? url, RenderContext context,
                    Map<String, String> attributes, Element) {
                  url != null ? launch(url!) : print("not valid url");
                },
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

String _showDate(DateTime time) {
  return DateFormat.yMMMd('ja').format(time);
}

class _UserProfileIcon extends StatelessWidget {
  final double size;
  final String profileImageUrl;

  const _UserProfileIcon(
      {Key? key, required this.size, required this.profileImageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        profileImageUrl,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            color: Colors.grey,
          );
        },
      ),
    );
  }
}

class _TagList extends StatelessWidget {
  final List<Tags> tags;
  const _TagList({Key? key, required this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                child: Text(
                  "${tag.name},",
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => TagResultsScreen(tagID: tag.name)));
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
