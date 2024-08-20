import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:beauty_hack/screens/Posts.dart';
import 'package:beauty_hack/screens/add.dart';
import 'package:beauty_hack/screens/home_screen.dart';
import 'package:beauty_hack/screens/make_payment.dart';
import 'package:beauty_hack/screens/reset_password.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

var color_index = 0;

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  
  var _current_index = 0;
  final user = FirebaseAuth.instance.currentUser;
  String? pathd;
  final CollectionReference postCollection = FirebaseFirestore.instance.collection('profile');
  late File? imge = null;

  Future getImage (ImageSource source) async {

      try{
        final image = await ImagePicker().pickImage(source: source);
        print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%: ${image!.path}');
        if( image == null) return;
        final value = await saveFilePermanently(image.path);
        setState(() {
          //_image.add(ImagePermanent);
          imge = value;
          pathd = image.path;
        });
        print('H**************************************: ${imge!.path}');
       
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

  
  uploadPost() async {
    print('*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: NULL');
    if (imge != null){
      final storageRef = FirebaseStorage.instance.ref()
      .child('profpic')
      .child('${DateTime.now().toIso8601String()+ p.basename(imge!.path)}');
      
      final results = await storageRef.putFile(File(imge!.path));
      final fileurl = await results.ref.getDownloadURL();
      print('*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: ${fileurl}');
   
      await postCollection.add({
        'image_url': fileurl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

  }

  
  
  @override
  Widget build(BuildContext context) {
      return
        Drawer(
          // child: ListView(
            // Important: Remove any padding from the ListView.
            // padding: EdgeInsets.zero,
            child: Column(
            children: [
              Container(
                height: 200,
                child: UserAccountsDrawerHeader(
                  
                  decoration: BoxDecoration(color: Color.fromARGB(255, 31, 103, 170)),
                  
                  accountName: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                  
                    children: [
                    
                      // IconButton( 
                      //   icon: Icon(Icons.add_a_photo), 
                      //   onPressed: () { 
                      //       //getImage(ImageSource.camera);
                      //       uploadPost();
                      //     },
                      //     iconSize: 30,
                      // ),
            
                      // Row(
                      //   children: [
                      //     Text('Tech Gig'),
                      //     IconButton(
                      //       onPressed: () {}, 
                      //       icon: Icon(Icons.edit),
                      //       color: Colors.white,
                      //     )
                          
                      //   ],
                      // ), 
                    ],
                  ),
                  accountEmail: Text(
                    "siyemsindazwe@gmail.com",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  currentAccountPicture: InkWell(
                    
                    child: Stack(
                      children: [
                          imge != null ?
                            CircleAvatar(
                            radius: 39,
                            //backgroundImage: AssetImage('assets/images/facebook.png'),
                            backgroundImage: FileImage(imge!),
                                
                            )
                           :CircleAvatar(
                            radius: 39,
                            //backgroundImage: AssetImage('assets/images/facebook.png'),
                            backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrOcwcs1uTKDcPyJliPGsY2qgsEEAIhcR7nav2tZ9YBg&s'),
                                
                          ),
                          Positioned(child: 
                            IconButton( 
                              icon: Icon(Icons.add_a_photo), 
                              onPressed: () { 
                                  getImage(ImageSource.camera);
                                  uploadPost();
                               },
                            ),
                            bottom: -5,
                            left: 30,

                              
                          ),
                
                        ],
                        
                    ),
                  ),//FlutterLogo(),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  
                  setState(() {
                    color_index = 0;
                   
                  });
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const  PostScreen()));
                },
                selected: color_index == 0,
                selectedTileColor: const Color.fromARGB(255, 196, 222, 243),
                leading: Icon(
                  Icons.home,
                  color: color_index == 0? 
                                  const Color.fromARGB(255, 31, 103, 170) :
                                  const Color.fromARGB(255, 19, 31, 41) ,
                  size: color_index == 0 ? 26 : 22,
                ),
                title: Text('Home', style: TextStyle( color: color_index == 0? 
                                  const Color.fromARGB(255, 31, 103, 170) :
                                  const Color.fromARGB(255, 19, 31, 41) ,
                                  fontWeight: FontWeight.normal, 
                                  fontSize: color_index == 0 ? 19 : 16,
                                  ), ),
                
              ),
              
              
              // ListTile(
              //   onTap: () {
              //     setState(() {
              //       color_index = 3;
              //     });
              //     Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => const CreditCardPage()));
              //   },
              //   selected: color_index == 3,
              //   selectedTileColor: const Color.fromARGB(255, 196, 222, 243),
              //   leading: Icon(
              //     Icons.payment_outlined,
              //     color: color_index == 3? 
              //                     const Color.fromARGB(255, 31, 103, 170) :
              //                     const Color.fromARGB(255, 19, 31, 41)  ,
              //     size: color_index == 3 ? 26 : 22,
              //   ),
              //   title: Text('Pay', style: TextStyle( color: color_index == 3? 
              //                     const Color.fromARGB(255, 31, 103, 170) :
              //                     const Color.fromARGB(255, 19, 31, 41) ,
              //                     fontWeight: FontWeight.normal,
              //                     fontSize: color_index == 3 ? 19 : 16,
              //                       ),),
                
              // ),
              ListTile(
                onTap: () {
                  setState(() {
                    color_index = 4;
                  });
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Addpost()));
                },
                selected: color_index == 4,
                selectedTileColor: const Color.fromARGB(255, 196, 222, 243),
                leading: Icon(
                  Icons.upload,
                  color: color_index == 4? 
                                  const Color.fromARGB(255, 31, 103, 170) :
                                  const Color.fromARGB(255, 19, 31, 41)  ,
                  size: color_index == 4 ? 26 : 22,
                ),
                title: Text('Upload', style: TextStyle( color: color_index == 4? 
                                  const Color.fromARGB(255, 31, 103, 170) :
                                  const Color.fromARGB(255, 19, 31, 41) ,
                                  fontWeight: FontWeight.normal,
                                  fontSize: color_index == 4 ? 19 : 16,
                                    ),),
                
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    color_index = 5;
                  });
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                selected: color_index == 5,
                selectedTileColor: const Color.fromARGB(255, 196, 222, 243),
                leading: Icon(
                  Icons.feed,
                  color: color_index == 5? 
                                  const Color.fromARGB(255, 31, 103, 170) :
                                  const Color.fromARGB(255, 19, 31, 41)  ,
                  size: color_index == 5 ? 26 : 22,
                ),
                title: Text('Contact', style: TextStyle( color: color_index == 5? 
                                  const Color.fromARGB(255, 31, 103, 170) :
                                  const Color.fromARGB(255, 19, 31, 41) ,
                                  fontWeight: FontWeight.normal,
                                  fontSize: color_index == 5 ? 19 : 16,
                                    ),),
                
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    color_index = 1;
                  });
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ResetPassword()));
                },
                selected: color_index == 1,
                selectedTileColor: const Color.fromARGB(255, 196, 222, 243),
                leading: Icon(
                  Icons.train,
                  color: color_index == 1? 
                                  const Color.fromARGB(255, 31, 103, 170) :
                                  const Color.fromARGB(255, 19, 31, 41)  ,
                  size: color_index == 1 ? 26 : 22,
                ),
                title: Text('Reset Password', style: TextStyle( color: color_index == 1? 
                                  const Color.fromARGB(255, 31, 103, 170) :
                                  const Color.fromARGB(255, 19, 31, 41) ,
                                  fontWeight: FontWeight.normal,
                                  fontSize: color_index == 1 ? 19 : 16,
                                    ),),
                
              ),
              const AboutListTile( 
                
                icon: Icon(
                  Icons.info,
                ),
                child: Text('About app', style: TextStyle(
                                  fontWeight: FontWeight.normal
                                    ),),
                applicationIcon: Icon(
                  Icons.local_play,
                ),
                applicationName: 'My Cool App',
                applicationVersion: '1.0.25',
                applicationLegalese: '© 2019 Company',
                aboutBoxChildren: [
                  ///Content goes here...
                ],
              ),
            ],
          ),
        );
  }
}