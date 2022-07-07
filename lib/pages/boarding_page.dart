import 'package:cassiere/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';

class BoardingPage extends StatelessWidget {
  BoardingPage({Key? key}) : super(key: key);

  final pages = [
    PageModel(
      color: Colors.blue,
      title: 'Welcome to Cassiere',
      body: 'The best way to manage your business',
      imageAssetPath: 'assets/images/man_thinking.png',
    ),
    PageModel(
      color: Colors.red,
      title: 'Welcome to Cassiere',
      body: 'The best way to manage your business',
      imageAssetPath: 'assets/images/man_thinking.png',
    ),
    PageModel(
      color: Colors.amber,
      title: 'Welcome to Cassiere',
      body: 'The best way to manage your business',
      imageAssetPath: 'assets/images/man_thinking.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OverBoard(
          pages: pages,
          skipCallback: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) {
              return const SignUpPage();
            }), (route) => false);
          },
          finishCallback: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              return const SignUpPage();
            }));
          }),
    );
  }
}
