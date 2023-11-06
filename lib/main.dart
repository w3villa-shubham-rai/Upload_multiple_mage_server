import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
  final homecontroller = Get.put(Homecontroller());
  @override
  Widget build(BuildContext context) {
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
                      onPressed: () {
                        homecontroller.selectImage();
                      },
                      child: Text("Pick Image"),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // homecontroller.uploadImage();
                      },
                      child: Text("Upload Image"),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                  child: GridView.builder(
                    itemBuilder: (context, index) {
                      return Image.file(
                        File(homecontroller.listimagespath[index]),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    },
                    itemCount: homecontroller.selectedFileCount.value,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class Homecontroller extends GetxController {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? images = [];
  List<String> listimagespath = [];

  var selectedFileCount = 0.obs;
  String? authToken;

  @override
  Future<void> onInit() async {
    super.onInit();
    authToken = await performAuthentication();
  }

  Future<String?> performAuthentication() async {
    return 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoyLCJ0aW1lIjoxNjk5MjQ3NjY2fQ.WebS3KfhUwQN1MhiO3oGLXonXNm9JdXRdxw_DyT8YYE';
  }

  List<ModelofsmallImage> imageModels = [];

  void selectImage() async {
    images = await _picker.pickMultiImage();
    if (images != null) {
      for (XFile file in images!) {
        listimagespath.add(file.path);
        String? response = await uploadImage(file.path);
        if (response != null) {
          print(
              "Response every image responsce that we need for $file.path: $response");
          final imageModel = ModelofsmallImage.fromJson(jsonDecode(response));
          print("checking model :$imageModel");
          imageModels.add(imageModel);
          for (ModelofsmallImage imageModel in imageModels) {
           print("Image ID: ${imageModel.id}");
         }

        } else {
          print("Error handling response for $file.path");
        }
      }
    } else {
      Get.snackbar("Failed", "Image not selected");
    }
    selectedFileCount.value = listimagespath.length;
  }

  Future<String?> uploadImage(String imagePath) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': authToken!,
    };

    var request = http.MultipartRequest(
      "POST",
      Uri.parse('https://staging.simmpli.com/api/v1/wall_posts.json'),
    );

    var file = File(imagePath);
    if (file.existsSync()) {
      request.fields['wall_post[post_body]'] = 'shubham';
      request.fields['wall_post[wall_post_type]'] = 'gallery';
      request.files.add(
        await http.MultipartFile.fromPath('wall_post[image]', file.path),
      );
      request.headers.addAll(headers);

      try {
        var response =
            await request.send().timeout(const Duration(seconds: 60));
        if (response.statusCode == 201 || response.statusCode == 200) {
          final responseString = await response.stream.bytesToString();
          return responseString;
        } else if (response.statusCode == 401) {
          print("Server returned a 401 Unauthorized error");
          return null;
        } else {
          print("Server returned an error status code: ${response.statusCode}");
          return null;
        }
      } catch (e) {
        print("Error during the request: $e");
        return null;
      }
    }

    print("File does not exist: $imagePath");
    return null;
  }
}

class ModelofsmallImage {
  int id;
  String postBody;
  String? body;
  String? formattedBody;
  String wallPostType;
  String? emojiName;
  bool isLiked;
  int totalLikes;
  String timeAgo;
  String attachmentUrl;
  String originalAttachmentUrl;
  bool isEdited;
  bool surveyTaken;
  int totalComments;
  String imageUrl;
  bool isVideo;
  String? outsideShowcaseImage;
  String? imgUrlSmall;
  Profile profile;
  List<dynamic> children;
  List<dynamic> surveyQuestions;
  List<dynamic> postComments;

  ModelofsmallImage({
    required this.id,
    required this.postBody,
    this.body,
    this.formattedBody,
    required this.wallPostType,
    this.emojiName,
    required this.isLiked,
    required this.totalLikes,
    required this.timeAgo,
    required this.attachmentUrl,
    required this.originalAttachmentUrl,
    required this.isEdited,
    required this.surveyTaken,
    required this.totalComments,
    required this.imageUrl,
    required this.isVideo,
    this.outsideShowcaseImage,
    this.imgUrlSmall,
    required this.profile,
    required this.children,
    required this.surveyQuestions,
    required this.postComments,
  });

  factory ModelofsmallImage.fromJson(Map<String, dynamic> json) {
    return ModelofsmallImage(
      id: json['id'],
      postBody: json['post_body'],
      body: json['body'],
      formattedBody: json['formatted_body'],
      wallPostType: json['wall_post_type'],
      emojiName: json['emoji_name'],
      isLiked: json['is_liked'],
      totalLikes: json['total_likes'],
      timeAgo: json['time_ago'],
      attachmentUrl: json['attachment_url'],
      originalAttachmentUrl: json['original_attachment_url'],
      isEdited: json['is_edited'],
      surveyTaken: json['survey_taken'],
      totalComments: json['total_comments'],
      imageUrl: json['image_url'],
      isVideo: json['is_video'],
      outsideShowcaseImage: json['outside_showcase_image'],
      imgUrlSmall: json['img_url_small'],
      profile: Profile.fromJson(json['profile']),
      children: json['children'],
      surveyQuestions: json['survey_questions'],
      postComments: json['post_comments'],
    );
  }
}

class Profile {
  int id;
  String firstName;
  String dpUrlSmall;
  String fullName;
  dynamic deletedAt;

  Profile({
    required this.id,
    required this.firstName,
    required this.dpUrlSmall,
    required this.fullName,
    this.deletedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      firstName: json['first_name'],
      dpUrlSmall: json['dp_url_small'],
      fullName: json['full_name'],
      deletedAt: json['deleted_at'],
    );
  }
}



