import 'package:flutter/material.dart';
import 'package:qiitaapp/screens/search_results_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
            height: 64,
            child: TextFormField(
              decoration: const InputDecoration(hintText: '検索ワードを入力してください。'),
              onFieldSubmitted: (value) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchResultScreen(
                      searchString: value,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
