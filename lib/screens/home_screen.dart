
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
import 'package:google_sign_in/google_sign_in.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final orpc = OdooClient('http://10.0.0.74:8069/');

var color_index = 0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _key = GlobalKey(); 
  Query dbRef = FirebaseDatabase.instance.ref().child('Users');
  
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Users');
  Icon customIcon = const Icon(Icons.search);
  String searchValue = '';
  var _current_index = 0;
  final List<String> _suggestions = ['Afeganistan', 'Albania', 'Algeria', 'Australia', 'Brazil', 'German', 'Madagascar', 'Mozambique', 'Portugal', 'Zambia'];

  @override
  void initState() {
    print('On the Home screen ****************************');
    print('*******************************$dbRef');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: EasySearchBar(
      
        title: const Text('Home', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
        backgroundColor: const Color.fromARGB(255, 31, 103, 170),
        iconTheme: const IconThemeData(color: Colors.white),
        
        suggestions: _suggestions,
        onSearch: (value) {
          setState(() {
            searchValue = value;
          });
        },
        // automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigation(),
      drawer: AppDrawer(), 
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: FirebaseAnimatedList(
                query: dbRef,
                itemBuilder: (context,snapshot,animation, index) {
                  print('****************snapshot *****************$snapshot');
                  return Card(
                    
                    child: ListTile(
                      selected: true,
                      selectedTileColor: const Color.fromARGB(255, 255, 255, 255),
                      title: Text(snapshot.child('name').value.toString() , style: const TextStyle( color:
                                  Color.fromARGB(255, 19, 31, 41),
                                  fontWeight: FontWeight.w500
                                   ),),
                      subtitle: Text(snapshot.child('email').value.toString(), style: const TextStyle( color:
                                  Color.fromARGB(255, 19, 31, 41)
                                   ),),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final orpc = OdooClient('http://10.0.0.74:8069/');
          await FirebaseAuth.instance.signOut().then((value) async {
              final user = FirebaseAuth.instance.currentUser;
              // print('******************************** ${user?.email}');
              final session = await orpc.authenticate( 'workDb', 'mdletsheb@moyatech.co.za', 'Kasune02@2023');

              await orpc.destroySession();
            
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("User Signed out"),
                    duration: Duration(seconds: 3), // Adjust the duration as needed
                  ),
              );

              var sharedPref = await SharedPreferences.getInstance();
              sharedPref.setBool(LaunchState.KEYLOGIN, false);
              
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()));
          }).onError((error, stackTrace){
            print("error log :$error");
          });
        },
        backgroundColor: const Color.fromARGB(255, 196, 222, 243),
        child: const Icon(Icons.logout, color: Color.fromARGB(255, 19, 31, 41),)
      ),
    );
  }

}