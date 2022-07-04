import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
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
