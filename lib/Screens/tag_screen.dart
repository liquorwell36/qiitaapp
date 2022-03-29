import 'package:flutter/material.dart';

class TagScreen extends StatefulWidget {
  TagScreen({Key? key}) : super(key: key);

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[100],
      width: double.infinity,
      height: double.infinity,
      child: Text("tag"),
    );
  }
}
