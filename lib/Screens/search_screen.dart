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

  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _searchOptions = [
    "title:",
    "body:",
    "code:",
    "tag:",
    "-tag:",
    "stock:",
    "created:",
    "updated:",
    "OR",
  ];

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardBarColor: Colors.grey[200],
        nextFocus: false,
        actions: [
          KeyboardActionsItem(
            displayActionBar: false,
            footerBuilder: (context) => PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (final searchOption in _searchOptions)
                    GestureDetector(
                      onTap: (() {
                        _controller.text += searchOption;
                        _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _controller.text.length));
                      }),
                      child: Container(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(searchOption),
                        ),
                      ),
                    ),
                ]),
              ),
            ),
            displayArrows: false,
            focusNode: _textNode,
          ),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controller,
                      focusNode: _textNode,
                      decoration:
                          const InputDecoration(hintText: '?????????????????????????????????????????????'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "?????????????????????????????????????????????1???????????????????????????????????????";
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SearchResultScreen(
                                searchString: value,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      alignment: Alignment.centerLeft,
                      child: const Text("?????????????????????"),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: DataTable(
                        sortAscending: false,
                        columnSpacing: 0.0,
                        headingRowHeight: 50.0,
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        columns: const [
                          DataColumn(label: Text("??????")),
                          DataColumn(label: Text("???????????????")),
                        ],
                        rows: [
                          DataRow(
                            color: MaterialStateProperty.resolveWith((states) {
                              return Colors.grey[200];
                            }),
                            cells: const [
                              DataCell(Text("??????????????????2015????????????")),
                              DataCell(Text("title:2015")),
                            ],
                          ),
                          const DataRow(
                            cells: [
                              DataCell(Text("????????????Qiita????????????")),
                              DataCell(Text("body:Qiita")),
                            ],
                          ),
                          DataRow(
                            color: MaterialStateProperty.resolveWith((states) {
                              return Colors.grey[200];
                            }),
                            cells: const [
                              DataCell(Text("???????????????Ruby????????????")),
                              DataCell(Text("code:Ruby")),
                            ],
                          ),
                          const DataRow(
                            cells: [
                              DataCell(Text("???Ruby??????????????????")),
                              DataCell(Text("tag:Ruby")),
                            ],
                          ),
                          DataRow(
                            color: MaterialStateProperty.resolveWith((states) {
                              return Colors.grey[200];
                            }),
                            cells: const [
                              DataCell(Text("sampleuser???????????????")),
                              DataCell(Text("user:sampleuser")),
                            ],
                          ),
                          const DataRow(
                            cells: [
                              DataCell(Text("???tag:Ruby??????????????????")),
                              DataCell(Text("-tag:Ruby")),
                            ],
                          ),
                          DataRow(
                            color: MaterialStateProperty.resolveWith((states) {
                              return Colors.grey[200];
                            }),
                            cells: const [
                              DataCell(Text("3??????????????????????????????????????????")),
                              DataCell(Text("stocks:>3")),
                            ],
                          ),
                          const DataRow(
                            cells: [
                              DataCell(Text("2021-10-09????????????????????????")),
                              DataCell(Text("created:>2021-10-09")),
                            ],
                          ),
                          DataRow(
                            color: MaterialStateProperty.resolveWith((states) {
                              return Colors.grey[200];
                            }),
                            cells: const [
                              DataCell(Text("2021-10-01 ????????????????????????")),
                              DataCell(Text("updated:>2021-10")),
                            ],
                          ),
                          const DataRow(
                            cells: [
                              DataCell(Text("???Go???????????????AWS????????????")),
                              DataCell(Text("Go OR AWS")),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
