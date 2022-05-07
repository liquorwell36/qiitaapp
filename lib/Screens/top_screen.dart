import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qiitaapp/Repository/qiita_repository.dart';
import 'package:qiitaapp/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:uni_links/uni_links.dart';

class TopScreen extends StatefulWidget {
  const TopScreen({Key? key}) : super(key: key);

  @override
  State<TopScreen> createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  final QiitaRepository repository = QiitaRepository();
  late String _state;
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _state = _randomString(40);
    _sub = uriLinkStream.listen((event) {
      if (event!.path == '/oauth/authorize/callback') {
        _onAuthorizedCallbackIsCalled(event);
      }
    }, onError: (error) {
      print("Error: ${error}");
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Qiitade',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none),
            ),
            const SizedBox(height: 64),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _onSignInButtonIsPressed();
                },
                child: const Text(
                  'Qiitaにログインする',
                  style: TextStyle(color: Colors.lightBlue),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (builder) => HomeScreen()));
                },
                child: const Text(
                  'ログインせずにスタート',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  void _onSignInButtonIsPressed() {
    launch(QiitaRepository().createAuthUrl(_state));
  }

  String _randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    final codeUnits = List.generate(length, (index) {
      final n = rand.nextInt(chars.length);
      return chars.codeUnitAt(n);
    });
    return String.fromCharCodes(codeUnits);
  }

  void _onAuthorizedCallbackIsCalled(Uri uri) async {
    closeWebView();
    final accessToken =
        await repository.createAccessTokenFromCallbackUri(uri, _state);
    await repository.saveAccessToken(accessToken);

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
  }
}
