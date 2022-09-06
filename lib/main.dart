import 'package:flutter/material.dart';
import 'package:qiitaapp/Repository/qiita_repository.dart';
import 'package:qiitaapp/screens/home_screen.dart';
import 'package:qiitaapp/screens/top_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const _LoadAccessToken(),
    );
  }
}

class _LoadAccessToken extends StatefulWidget {
  const _LoadAccessToken({Key? key}) : super(key: key);

  @override
  State<_LoadAccessToken> createState() => __LoadAccessTokenState();
}

class __LoadAccessTokenState extends State<_LoadAccessToken> {
  Error? _error;

  @override
  void initState() {
    super.initState();

    QiitaRepository().accessTokenIsSaved().then((value) {
      if (value) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const TopScreen()));
      }
    }).catchError((e) {
      setState(() {
        _error = e;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: (_error == null)
            ? const CircularProgressIndicator()
            : Text(_error.toString()),
      ),
    );
  }
}
