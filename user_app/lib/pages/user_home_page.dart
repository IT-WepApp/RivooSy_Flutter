import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar:  AppBar(
        title:  Text('Home'),
      ),
      body:  Center(
        child:  Text('Welcome to the User App!'),
        ),
    );
  }
}
