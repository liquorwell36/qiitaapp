import 'package:flutter/material.dart';
import 'package:qiitaapp/screens/article_list_screen.dart';

class SearchResultScreen extends StatefulWidget {
  SearchResultScreen({Key? key, required this.searchString}) : super(key: key);
  final String searchString;
  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("検索結果"),
      ),
      body: ArticleListScreen(
        searchString: widget.searchString,
      ),
    );
  }
}
