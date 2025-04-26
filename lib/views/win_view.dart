import 'package:flutter/material.dart';

class WinView extends StatelessWidget {
  const WinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Win View'),
      ),
      body: Center(
        child: Text('You Win!'),
      ),
    );
  }
}