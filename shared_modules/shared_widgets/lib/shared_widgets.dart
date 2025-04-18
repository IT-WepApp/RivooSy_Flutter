library shared_widgets;

import 'package:flutter/material.dart';

class SharedCustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const SharedCustomButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(title),
    );
  }
}
