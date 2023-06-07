import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Color.fromARGB(255, 62, 95, 243),
      ),
      body: Center(
        child: Text(
          'About Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
