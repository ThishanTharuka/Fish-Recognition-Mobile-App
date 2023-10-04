import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main() {
  runApp(MaterialApp(
    home: const RecognitionPage(),
    routes: <String, WidgetBuilder>{
      '/settings': (BuildContext context) => Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            body: const Center(
              child: Text('Settings Page'),
            ),
          ),
      '/about': (BuildContext context) => Scaffold(
            appBar: AppBar(
              title: const Text('About'),
            ),
            body: const Center(
              child: Text('About Page'),
            ),
          ),
    },
  ));
}

class RecognitionPage extends StatefulWidget {
  const RecognitionPage({Key? key}) : super(key: key);

  @override
  _RecognitionPageState createState() => _RecognitionPageState();
}

class _RecognitionPageState extends State<RecognitionPage> {
  int _selectedIndex = 0;
  late File _image;
  late List _results;
  bool imageSelect = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    ))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image) async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 20,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results = recognitions!;
      _image = image;
      imageSelect = true;
    });
  }

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

  Future<void> _handleOpenCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    File image = File(pickedImage!.path);
    imageClassification(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 250, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 128, 216, 255),
        title: const Text(
          'Fish Detective',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'product-sans',
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            height: 300, // Set a fixed height as per your requirement
            child: imageSelect
                ? Image.file(
                    _image,
                    fit: BoxFit.cover, // You can use different BoxFit options
                  )
                : const Opacity(
                    opacity: 1,
                    child: Center(
                      child: Text("No image selected"),
                    ),
                  ),
          ),
          SingleChildScrollView(
            child: Column(
              children: imageSelect
                  ? _results.map((result) {
                      double confidence =
                          result['confidence'] * 100; // Convert to percentage
                      if (confidence >= 75) {
                        return Card(
                          elevation: 0,
                          color: const Color.fromARGB(255, 238, 250, 255),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Scientific Name: ${result['label']}",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                    height: 10), // Add a 10-pixel space line
                                Text(
                                  "Probability: ${confidence.toStringAsFixed(0)}%",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Card(
                          elevation: 0,
                          color: const Color.fromARGB(255, 238, 250, 255),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "This image cannot be identified within the constraints of our dataset.",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }).toList()
                  : [],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: pickImage,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 13, 71, 161),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Upload Photo',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'product-sans',
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _handleOpenCamera,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 13, 71, 161),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Open Camera',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'product-sans',
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: BottomNavigationBar(
          selectedItemColor: const Color.fromARGB(255, 2, 2, 2),
          unselectedItemColor: const Color.fromARGB(255, 46, 46, 46),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Color.fromARGB(255, 128, 216, 255)),
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

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    File image = File(pickedFile!.path);
    imageClassification(image);
  }
}
