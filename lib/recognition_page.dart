import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RecognitionPage extends StatefulWidget {
  @override
  _RecognitionPageState createState() => _RecognitionPageState();
}

class _RecognitionPageState extends State<RecognitionPage> {
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Perform actions based on the selected navigation item
    if (_selectedIndex == 0) {
      // Handle Home action (navigate to the recognition page)
    } else if (_selectedIndex == 1) {
      Navigator.pushNamed(context, '/settings');
    } else if (_selectedIndex == 2) {
      Navigator.pushNamed(context, '/about');
    } else if (_selectedIndex == 3) {
      exit(0); // Close the app
    }
  }

  Future<void> _handleUploadPhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Handle the selected image
    }
  }

  Future<void> _handleOpenCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);

    if (pickedImage != null) {
      // Handle the captured image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 62, 95, 243),
        title: Text('Fish Detective'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 16), // Add some space above the buttons
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, 0, 0, 10), // Add bottom margin of 16 pixels
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: _handleUploadPhoto,
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Upload Photo',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Manrope',
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: _handleOpenCamera,
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Open Camera',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: BottomNavigationBar(
          selectedItemColor: const Color.fromARGB(255, 2, 2, 2),
          unselectedItemColor: const Color.fromARGB(255, 124, 123, 123),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'About',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app),
              label: 'Exit',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onNavItemTapped,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RecognitionPage(),
    routes: <String, WidgetBuilder>{
      '/settings': (BuildContext context) => Scaffold(
            appBar: AppBar(
              title: Text('Settings'),
            ),
            body: Center(
              child: Text('Settings Page'),
            ),
          ),
      '/about': (BuildContext context) => Scaffold(
            appBar: AppBar(
              title: Text('About'),
            ),
            body: Center(
              child: Text('About Page'),
            ),
          ),
    },
  ));
}
