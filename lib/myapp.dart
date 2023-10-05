import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blog/notifier/favourite_post_notifier.dart';
import 'package:flutter_blog/widget/favorite.dart';
import 'package:flutter_blog/widget/home.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Widget> _pages = [
    Home(),
    Favorite(),
  ];
  int _pagenum = 0;
  void setpageNum(int n) {
    setState(() {
      _pagenum = n;
    });
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
  }

  void _checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //_showSnackBar("You're online.");
      }
    } on SocketException catch (_) {
      _showSnackBar("You're OFFLINE.");
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
            backgroundColor: Color.fromARGB(0, 2, 2, 2),
            color: Color.fromARGB(255, 20, 12, 12)),
      ),
      duration: const Duration(seconds: 5),
    );
    _scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteNotifier(),
      child: MaterialApp(
        scaffoldMessengerKey: _scaffoldMessengerKey,
        title: 'Blog App',
        theme: ThemeData.dark(),
        home: Builder(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(255, 35, 35, 33),
                    title: const Text('Blogs'),
                  ),
                  drawer: Drawer(
                    width: 200,
                    child: SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            dense: true,
                            title: const Text("Home"),
                            leading: const Icon(Icons.home),
                            onTap: () {
                              setpageNum(0);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            dense: true,
                            title: const Text("Favorites"),
                            leading: const Icon(Icons.favorite),
                            onTap: () {
                              setpageNum(1);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: _pages[_pagenum],
                )),
      ),
    );
  }
}
