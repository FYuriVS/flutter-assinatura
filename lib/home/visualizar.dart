import 'package:flutter/material.dart';

class Visualizar extends StatelessWidget {
  final pngBytes;

  const Visualizar({super.key, this.pngBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.memory(pngBytes),
      ),
    );
  }
}
