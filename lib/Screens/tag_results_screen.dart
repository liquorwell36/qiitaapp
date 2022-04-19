import 'package:flutter/material.dart';
import 'package:qiitaapp/Screens/article_list_screen.dart';

class TagResultsScreen extends StatefulWidget {
  TagResultsScreen({Key? key, required this.tagID}) : super(key: key);
  final String tagID;
  @override
  State<TagResultsScreen> createState() => _TagResultsScreenState();
}

class _TagResultsScreenState extends State<TagResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tagID),
      ),
      body: ArticleListScreen(
        tagID: widget.tagID,
      ),
    );
  }
}
