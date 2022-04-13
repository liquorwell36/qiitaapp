import 'package:flutter/material.dart';
import 'package:qiitaapp/Repository/qiita_repository.dart';
import 'package:qiitaapp/Screens/top_screen.dart';
import 'package:qiitaapp/Screens/user_profile_screen.dart';
import 'package:qiitaapp/screens/search_screen.dart';
import 'package:qiitaapp/screens/stock_screen.dart';
import 'package:qiitaapp/screens/tag_screen.dart';

import '../models/user.dart';
import 'article_list_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _pageWidgets = [
    const ArticleListScreen(
      searchString: '',
    ),
    TagScreen(),
    SearchScreen(),
    StockScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qiita App'),
        actions: [
          FutureBuilder(
            future: QiitaRepository().getAuthenticatedUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final Widget icon = snapshot.hasData
                  ? _UserProfileIcon(
                      size: 32,
                      profileImageUrl: snapshot.data.profileImageUrl,
                    )
                  : const Icon(Icons.person);
              return PopupMenuButton(
                onSelected: (value) {
                  if (value == 'profile') {
                    _onProfileMenuIsSelected(snapshot.data);
                  } else {
                    _onLogoutMenuIsSelected();
                  }
                },
                icon: icon,
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Text("プロフィール"),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Text("ログアウト"),
                    ),
                  ];
                },
              );
            },
          ),
        ],
      ),
      body: _pageWidgets[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.tag), label: 'タグ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '検索'),
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add_check), label: 'ストック'),
        ],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  void _onProfileMenuIsSelected(User user) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => UserProfileScreen(user: user)));
  }

  void _onLogoutMenuIsSelected() async {
    await QiitaRepository().revokeSavedAccessToken();
    await QiitaRepository().deleteAccessToken();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const TopScreen()),
    );
  }
}

class _UserProfileIcon extends StatelessWidget {
  final double size;
  final String profileImageUrl;

  const _UserProfileIcon({
    Key? key,
    required this.size,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          profileImageUrl,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: size,
              height: size,
              color: Colors.grey,
            );
          },
        ));
  }
}
