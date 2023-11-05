import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   final  homecontroller =  Get.put(Homecontroller());
  @override
  Widget build(BuildContext context) {
   
    var arrcolors = [
      Colors.red,
      Colors.green,
      Colors.red,
      Colors.green,
      Colors.red,
      Colors.green,
      Colors.red,
      Colors.green,
      Colors.red,
      Colors.green
    ];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Pick Image"),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Upload Image"),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                child: GridView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      color: arrcolors[index],
                    );
                  },
                  itemCount: arrcolors.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8),
                ),
              ),
            ),
          ],
        ));
  }
}

class Homecontroller extends GetxController {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? images = [];
  List<String> listimagespath = [];

  var selectedFileCount = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onInit();
  }

  void selectimage() async {
    images = await _picker.pickMultiImage();
    if (images != null) {
      for (XFile file in images!) {
        listimagespath.add(file.path);
      }
    } else {
      Get.snackbar("failed", "image not selected");
    }
    selectedFileCount.value = listimagespath.length;
  }

  void imageupload() {}
}
