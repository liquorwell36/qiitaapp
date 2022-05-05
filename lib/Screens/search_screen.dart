import 'package:flutter/material.dart';
import 'package:qiitaapp/screens/article_list_screen.dart';
import 'package:qiitaapp/screens/search_results_screen.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _textNode = FocusNode();

  TextEditingController _controller = TextEditingController();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardBarColor: Colors.grey[50],
        nextFocus: false,
        actions: [
          KeyboardActionsItem(focusNode: _textNode, toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: (() {
                  _controller.text += "title:";
                  _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length));
                }),
                child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: const Text("title:")),
              );
            },
            (node) {
              return GestureDetector(
                onTap: (() {
                  _controller.text += "body:";
                  _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length));
                }),
                child: Container(
                    padding: const EdgeInsets.only(right: 4),
                    child: const Text("body:")),
              );
            },
            (node) {
              return GestureDetector(
                onTap: (() {
                  _controller.text += "code:";
                  _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length));
                }),
                child: Container(
                    padding: const EdgeInsets.only(right: 4),
                    child: const Text("code:")),
              );
            },
            (node) {
              return GestureDetector(
                onTap: (() {
                  _controller.text += "tag:";
                  _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length));
                }),
                child: Container(
                    padding: const EdgeInsets.only(right: 4),
                    child: const Text("tag:")),
              );
            },
            (node) {
              return GestureDetector(
                onTap: (() {
                  _controller.text += "-tag:";
                  _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length));
                }),
                child: Container(
                    padding: const EdgeInsets.only(right: 4),
                    child: const Text("-tag:")),
              );
            },
            (node) {
              return GestureDetector(
                onTap: (() {
                  _controller.text += "stock:";
                  _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length));
                }),
                child: Container(
                    padding: const EdgeInsets.only(right: 4),
                    child: const Text("stock:")),
              );
            },
            (node) {
              return GestureDetector(
                onTap: (() {
                  _controller.text += "created:";
                  _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length));
                }),
                child: Container(
                    padding: const EdgeInsets.only(right: 4),
                    child: const Text("created:")),
              );
            },
            (node) {
              return GestureDetector(
                onTap: (() {
                  _controller.text += "updated:";
                  _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length));
                }),
                child: Container(
                    padding: const EdgeInsets.only(right: 4),
                    child: const Text("updated:")),
              );
            },
            (node) {
              return GestureDetector(
                onTap: (() {
                  _controller.text += "OR ";
                  _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length));
                }),
                child: Container(
                    padding: const EdgeInsets.only(right: 16),
                    child: const Text("OR")),
              );
            },
          ]),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: KeyboardActions(
        config: _buildConfig(context),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 8, left: 16, right: 16, bottom: 16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _controller,
                    focusNode: _textNode,
                    decoration:
                        const InputDecoration(hintText: '検索ワードを入力してください。'),
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
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    alignment: Alignment.centerLeft,
                    child: const Text("検索オプション"),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: DataTable(
                        sortAscending: false,
                        columnSpacing: 0.0,
                        headingRowHeight: 50.0,
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        columns: const [
                          DataColumn(label: Text("項目")),
                          DataColumn(label: Text("オプション")),
                        ],
                        rows: [
                          DataRow(
                            color: MaterialStateProperty.resolveWith((states) {
                              return Colors.grey[200];
                            }),
                            cells: const [
                              DataCell(Text("タイトルに「2015」を含む")),
                              DataCell(Text("title:2015")),
                            ],
                          ),
                          const DataRow(
                            cells: [
                              DataCell(Text("本文に「Qiita」を含む")),
                              DataCell(Text("body:Qiita")),
                            ],
                          ),
                          DataRow(
                            color: MaterialStateProperty.resolveWith((states) {
                              return Colors.grey[200];
                            }),
                            cells: const [
                              DataCell(Text("コードに「Ruby」を含む")),
                              DataCell(Text("code:Ruby")),
                            ],
                          ),
                          const DataRow(
                            cells: [
                              DataCell(Text("「Ruby」タグが付く")),
                              DataCell(Text("tag:Ruby")),
                            ],
                          ),
                          DataRow(
                            color: MaterialStateProperty.resolveWith((states) {
                              return Colors.grey[200];
                            }),
                            cells: const [
                              DataCell(Text("sampleuserが作成した")),
                              DataCell(Text("user:sampleuser")),
                            ],
                          ),
                          const DataRow(
                            cells: [
                              DataCell(Text("「tag:Ruby」を含まない")),
                              DataCell(Text("-tag:Ruby")),
                            ],
                          ),
                          DataRow(
                            color: MaterialStateProperty.resolveWith((states) {
                              return Colors.grey[200];
                            }),
                            cells: const [
                              DataCell(Text("3件より多くストックされている")),
                              DataCell(Text("stocks:>3")),
                            ],
                          ),
                          const DataRow(
                            cells: [
                              DataCell(Text("2021-10-09以降に作成された")),
                              DataCell(Text("created:>2021-10-09")),
                            ],
                          ),
                          DataRow(
                            color: MaterialStateProperty.resolveWith((states) {
                              return Colors.grey[200];
                            }),
                            cells: const [
                              DataCell(Text("2021-10-01 以降に更新された")),
                              DataCell(Text("updated:>2021-10")),
                            ],
                          ),
                          const DataRow(
                            cells: [
                              DataCell(Text("「Go」または「AWS」を含む")),
                              DataCell(Text("Go OR AWS")),
                            ],
                          ),
                        ]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
