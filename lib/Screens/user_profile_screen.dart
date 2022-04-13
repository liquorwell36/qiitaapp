import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/user.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  const UserProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.id),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _UserProfile(user: user),
            const Divider(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfile extends StatelessWidget {
  final User user;

  const _UserProfile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        ClipOval(
          child: Container(
            width: 64,
            height: 64,
            child: Image.network(user.profileImageUrl),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text('@${user.id}'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            user.description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  '${user.itemsCount}',
                  style: const TextStyle(fontSize: 20),
                ),
                const Text(
                  '投稿',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '${user.followersCount}',
                  style: const TextStyle(fontSize: 20),
                ),
                const Text(
                  'フォロワー',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
