import 'package:flutter/material.dart';
import 'package:qiitaapp/Models/tag.dart';
import 'package:qiitaapp/Repository/qiita_repository.dart';
import 'package:qiitaapp/Screens/tag_results_screen.dart';

class TagScreen extends StatefulWidget {
  TagScreen({Key? key}) : super(key: key);

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: FutureBuilder<List<Tag>>(
        future: QiitaRepository().getTagList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tagList = snapshot.data!;
            return ListView.builder(
              itemCount: tagList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: ListTile(
                    leading: Container(
                      width: 32,
                      height: 32,
                      child: ClipRRect(
                        child: Image.network(
                          tagList[index].iconUrl!,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.auto_awesome_mosaic);
                          },
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    title: Text(tagList[index].id),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            TagResultsScreen(tagID: tagList[index].id),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Text("not found tag");
          }
        },
      ),
    );
  }
}
