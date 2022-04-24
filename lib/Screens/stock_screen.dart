import 'package:flutter/material.dart';
import 'package:qiitaapp/models/articles.dart';
import 'package:qiitaapp/Models/user.dart';
import 'package:qiitaapp/Repository/qiita_repository.dart';
import 'package:qiitaapp/Screens/article_screen.dart';

class StockScreen extends StatefulWidget {
  StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  late String? _userID;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: FutureBuilder(
                future: getStock(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Article> articleList = snapshot.data!;

                    return ListView(
                      children: articleList.map((value) {
                        return Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ArticleScreen(
                                    article: value,
                                  ),
                                ),
                              );
                            },
                            child: articleCard(
                              title: value.title,
                              author: value.user.id,
                              profileImageIcon: value.user.profileImageUrl,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return const Text("サインインするとストックが一覧表示されます。");
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  getStock() async {
    var user = await QiitaRepository().getAuthenticatedUser();
    return QiitaRepository().fetchUserArticleList(userID: user.id);
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
