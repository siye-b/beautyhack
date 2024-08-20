
import 'package:beauty_hack/screens/chat/chat_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:beauty_hack/screens/Appdrawer.dart';
import 'package:beauty_hack/screens/Bottom_navigation.dart';
import 'package:beauty_hack/screens/launch.dart';
import 'package:beauty_hack/screens/reset_password.dart';
import 'package:beauty_hack/screens/signin_screen.dart';
import 'package:beauty_hack/utils/color_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

var color_index = 0;

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final GlobalKey<ScaffoldState> _key = GlobalKey(); 
  
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');

 Future<List<Map<String, dynamic>>> getDocs() async {

    List<Map<String, dynamic>> documentsData = [];
    try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .get();

        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          String documentId = doc.id;
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
              .collection('posts')
              .doc(documentId)
              .get();

          if (documentSnapshot.exists) {
              Map<String, dynamic> data = {
                'id': documentId,
                'data': documentSnapshot.data(),
              };
              documentsData.add(data);
          }
        }
  } catch (e) {
      print("Error printing data for document IDs: $e");
  }

  return documentsData;
}

  Icon customIcon = const Icon(Icons.search);
  String searchValue = '';
  var _current_index = 0;
  List<Map<String, String>> items = [
    {'name': 'John', 'surname': 'Doe'},
    {'name': 'Alice', 'surname': 'Smith'},
    {'name': 'Bob', 'surname': 'Johnson'},
    // Add more persons as needed
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: Text('Product · Check', style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 31, 103, 170),
        iconTheme: const IconThemeData(color: Colors.white),
        // automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigation(),
      drawer: AppDrawer(), 
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getDocs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> data = snapshot.data ?? [];
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                
                // return ListTile(
                //   leading: CircleAvatar(
                //   backgroundImage: NetworkImage('${data[index]['data']['image_url'][0]}'),
                //   ),
                //   title: Text('Document ID: ${data[index]['id']}'),
                //   subtitle: Text('Data: ${data[index]['caption']}'),

                // );
                    // List<String> imageUrls = [];
                    // String imageURL = '${data[index]['data']['image_url'][0]}'; // Sample image URL
                    // for (int i=0; i<data[index]['data']['image_url'].length; i++){
                    //       imageUrls.add('${data[index]['data']['image_url'][i]}');
                    // }
                    List<String> imageUrls = [];
                    for (int i=0; i<data[index]['data']['image_url'].length; i++){
                          imageUrls.add('${data[index]['data']['image_url'][i]}');
                    }
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrOcwcs1uTKDcPyJliPGsY2qgsEEAIhcR7nav2tZ9YBg&s'),  
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Tech Gig", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, ),),
                          
                                      Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                        
                                            Text(
                                              DateFormat('EEE').format(data[index]['data']['timestamp'].toDate()).toString()+' '+
                                              DateFormat('h:mm a').format(data[index]['data']['timestamp'].toDate()).toString()+' '+
                                              DateFormat('d/mm/y').format(data[index]['data']['timestamp'].toDate()).toString(),
                                              style: TextStyle(fontSize: 12.0, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                    ),
                                  
                                  ],
                                ),
                                ],
                              ),
                              
                              //SizedBox(width: 135,),
                              PopupMenuButton<String>(
                                onSelected: (String result) {
                                  switch (result) {
                                    case 'Option 1':
                                      //_save();
                                      break;
                                    case 'Option 2':
                                      //_message();
                                       Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => ChatScreen())); 
                                      break;
                                    case 'Option 3':
                                      //_notInterested();
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'Option 1',
                                    child: Text('Save', style: TextStyle(color: Colors.black54),),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Option 2',
                                    child: Text('Message', style: TextStyle(color: Colors.black54),),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Option 3',
                                    child: Text('Not Interested', style: TextStyle(color: Colors.black54),),
                                  ),
                                ],
                                icon: Icon(Icons.more_vert), // The three-dotted menu icon
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              SizedBox(width: 10,),
                              Container(
                                width: 300,
                                child: Text(
                                  '${data[index]['data']['caption']}',
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            itemCount: imageUrls.length > 4 ? 4 : imageUrls.length,
                            itemBuilder: (BuildContext context, int index) {
                      
                              if (index == 3 && imageUrls.length > 4) {
                                return GestureDetector(
                                  onTap: () {
                                    _showAdditionalImages(context, imageUrls);
                                  },
                                  child: Card(
                                    color: Colors.transparent,
                                    child: Center(
                                      child: Text(
                                        '+${imageUrls.length - 4}',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                              return GestureDetector(
                                  onTap: () {
                                    // Show an enlarged version of the image when tapped
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: Image.network(
                                            imageUrls[index],
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Card(
                                    elevation: 4.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        imageUrls[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );}
                            },
                            // staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 3 : 2),
                            staggeredTileBuilder: (int index) => StaggeredTile.count(imageUrls.length == 1 ? 4 : ((index+1) == imageUrls.length) && (index+1) == 3 ? 4 : 2,   imageUrls.length == 1 ? 2 : 2),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                          ),
                          SizedBox(height: 10,),
                          Divider(color: Colors.black12, indent: 5,endIndent: 5, thickness: 0.5,),
                        ],
                        
                      ),
                    );
              }
            );
          
        }
        }
      ),
    
    );
  }

  void _showAdditionalImages(BuildContext context, List<String> imageUrls) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Additional Images'),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: imageUrls.length - 3,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      // Show an enlarged version of the image when tapped
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: Image.network(
                              imageUrls[index+3],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 4.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imageUrls[index+3],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
              },
            ),
          ),
        );
      },
    );
  }

}