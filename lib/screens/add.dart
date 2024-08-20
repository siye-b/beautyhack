import 'dart:io';
import 'package:beauty_hack/screens/Posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:beauty_hack/reusable_widgets/reusable_widget.dart';
import 'package:beauty_hack/screens/home_screen.dart';
import 'package:beauty_hack/screens/signin_screen.dart';
import 'package:beauty_hack/screens/welcome_screen.dart';
import 'package:beauty_hack/utils/color_utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';


class Addpost extends StatefulWidget {
  const Addpost({super.key});

  @override
  State<Addpost> createState() => AddpostState();
}

class AddpostState extends State<Addpost> {
  //File? _image;
  late CollectionReference imgRef;
  List<File> _image = [];
  String? pathd;
  static const isPressed = 0;
  int? _selectedIndex;
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');
  TextEditingController _captionController = TextEditingController();


  Future getImage (ImageSource source) async {

      try{
        final image = await ImagePicker().pickImage(source: source);

        if( image == null) return;

        final ImagePermanent = await saveFilePermanently(image.path);

        setState(() {
          _image.add(ImagePermanent);
          pathd = image.path;
        });
       
      } catch (e) {
          print('print error : , $e');
      }

  }

  Future<File> saveFilePermanently(String imagePath) async {

      final directory = await getApplicationDocumentsDirectory();
      final name = p.basename(imagePath);
      final image = File('${directory.path}/$name');

      return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Add Image', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
        backgroundColor: const Color.fromARGB(255, 31, 103, 170),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
         
          IconButton(
            icon: Icon(Icons.camera_alt), 
            onPressed: () {
              getImage(ImageSource.camera);
            },
            iconSize: 18,
          )
        ,],
       
        // automaticallyImplyLeading: false,
      ),
      
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: _image.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index - 1;
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(_image[index - 1]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (_selectedIndex != null && _selectedIndex == index - 1)
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _image.removeAt(_selectedIndex!);
                                      _selectedIndex = null;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                hintText: 'Add a caption...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
              uploadPost().whenComplete(() {
                 print("ghgAKDFKGFF DF");
              });
              Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PostScreen()));
        
        },
        backgroundColor: const Color.fromARGB(255, 196, 222, 243),
        child: const Icon(Icons.upload, color: Color.fromARGB(255, 19, 31, 41),)
      ),

      
    );
  }

  uploadPost () async {
    List<String> imageUrls = [];

    for (var img in _image){
      final storageRef = FirebaseStorage.instance.ref()
      .child('images')
      .child('${DateTime.now().toIso8601String()+ p.basename(img.path)}');

      final results = await storageRef.putFile(File(img.path));
      final fileurl = await results.ref.getDownloadURL();
      imageUrls.add(fileurl);
      
    }
    
       await postsCollection.add({
        'image_url': imageUrls,
        'caption': _captionController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

  }

  // @override
  // void initState () {
  //   super.initState();
  //   imgRef = FirebaseFirestore.instance.collection('imageUrls');
  // }
  
 

}