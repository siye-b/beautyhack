
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:beauty_hack/screens/home_screen.dart';
import 'package:beauty_hack/screens/launch.dart';
import 'package:beauty_hack/screens/reset_password.dart';
import 'package:beauty_hack/screens/signup_screen.dart';
import 'package:beauty_hack/reusable_widgets/reusable_widget.dart';
import 'package:beauty_hack/services/auth_service.dart';
import 'package:beauty_hack/services/internet_provider.dart';
import 'package:beauty_hack/services/sign_in_provider.dart';
import 'package:beauty_hack/utils/color_utils.dart';
import 'package:beauty_hack/utils/snack_bar.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:aad_oauth/model/failure.dart';
import 'package:aad_oauth/model/token.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final orpc = OdooClient('http://10.0.0.74:8069/');

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  late DatabaseReference dbRef;
  bool _obscured = false;

  final String odooBaseUrl = 'http://10.0.0.74:8069/';
  final String odooDatabase = 'workDb';
  final String odooUsername = 'mdletsheb@moyatech.co.za';
  final String odooPassword = 'Kasune02@2023';

  int uid = 0; // Initialize with a default value
  List<dynamic> items = [];

  // final GetStorage _getStorage = GetStorage();

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;    
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Users');
    
  }

  static final Config config = Config(
    // If you dont have a special tenant id, use "common"
      tenant: "common",
   
      responseType: "code",
      scope: "User.Read openid profile offline_access email",
      redirectUri: "https://auth.custom-domain.com/__/auth/handler",
      //redirectUri: "msal1e58fac1-f558-4fbb-b1f3-8d0d4d150b41://auth",

      loader: const Center(child: CircularProgressIndicator()),
      webUseRedirect: true,
      navigatorKey: navigatorKey,
      isB2C: false, 
      clientId: '',
  );

  // ignore: unused_field
  Map<String, dynamic>? _userData;
  // ignore: unused_field
  AccessToken? _accessToken;
  // ignore: unused_field
  final bool _checking = true;

  
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("0B5394"),
          hexStringToColor("53677A"),
          hexStringToColor("F3F6F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.3, 20, 0),
            child: Column(
              children: <Widget>[
                // Image.asset(
                //   'assets/images/siggnin.png', // Replace with your image asset path
                //   width: 70, // Set the width of the image as needed
                //   height: 70, // Set the height of the image as needed
                // ),
                const SizedBox(
                  height: 30,
                ),
                const Text("Login Here",
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 25)),
                const SizedBox(
                  height: 10,
                ),
                const Text("Welcome Back ,You've been missed",
                      style: TextStyle(color: Colors.white60, fontSize: 15)),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _passwordTextController,
                  obscureText: !_obscured,
                  enableSuggestions: false,
                  autocorrect: false,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outlined,
                      color: Colors.white70,
                    ),
                    suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: _toggleObscured,
                          child: Icon(
                            _obscured
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            size: 24,
                          ),
                        ),
                    ),
                    labelText: "Enter Password",
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                  ),
                  
                  keyboardType: TextInputType.visiblePassword,
                      
                ),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseUIButton(context, "Sign In", () async {

                  if (_emailTextController.text.isEmpty || _passwordTextController.text.isEmpty) {
                   
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter both email and password."),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    return;
                  }
                  
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                            content: Text("User Signed In"),
                            duration: Duration(seconds: 3), // Adjust the duration as needed
                          ),);
                          print("user signed in");
                          // _getStorage.write("userId", value.user?.uid);
                          // _getStorage.write("sessionId", value.user?.id);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomeScreen()));
                      }).onError((error, stackTrace) {

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("An error occurred: ${error.toString()}"),
                              duration: Duration(seconds: 3), // Adjust the duration as needed
                            ),
                          );
                          print("Error************* ${error.toString()}");
                  });
                  var sharedPref = await SharedPreferences.getInstance();
                 
                  sharedPref.setBool(LaunchState.KEYLOGIN, true);

                }),
                
                signUpOption(),
                threeImageButtons(context),
                
              ],
            ),
          ),
        ),
      ),
    );
  }



  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Color.fromARGB(255, 85, 111, 133))),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Color.fromARGB(255, 51, 81, 105), fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }

  Widget threeImageButtons(BuildContext context) {
  // Define the firebaseAuthButton function within threeImageButtons
    Widget firebaseAuthButton(Image img, Function onTap) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), 
            ),
          ),
          
          child: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 8,
              child: img,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // Adjust alignment as needed
      children: [
        firebaseAuthButton(
          Image.asset("assets/images/google.png"),
           // Image for the first button
          () async {
            await signInWithGoogle();
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("User Signed In"),
                    duration: Duration(seconds: 3), 
                  ),
              );
            // ignore: use_build_context_synchronously
             var sharedPref = await SharedPreferences.getInstance();   
             sharedPref.setBool(LaunchState.KEYLOGIN, true);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
          
        ),
        firebaseAuthButton(
          Image.asset("assets/images/facebook.png"), 
          () async {
    
            SignInWithFacebook();
             ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("User Signed In"),
                    duration: Duration(seconds: 3), 
                  ),
             );
             var sharedPref = await SharedPreferences.getInstance();   
             sharedPref.setBool(LaunchState.KEYLOGIN, true);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
        firebaseAuthButton(
          Image.asset("assets/images/microsoft.png"), // Image for the third button
          () async {
           
            _loginWithMicrosoft();
             ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("User Signed In"),
                    duration: Duration(seconds: 3), // Adjust the duration as needed
                  ),
              );
             var sharedPref = await SharedPreferences.getInstance();   
             sharedPref.setBool(LaunchState.KEYLOGIN, true);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),

      ],
    );
  }

  signInWithGoogle() async {
    try {

        final GoogleSignInAccount? googleUser = await GoogleSignIn(
            scopes: <String>["email"]).signIn();
        final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      
        UserCredential cred = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = await firebaseAuth.currentUser;
        String userId = user!.uid;

        Map<String, String> users = {
            'name': cred.user!.displayName ?? "No email available",
            'email': cred.user!.email ?? "No email available",
            'password': 'Facebook_user',
        };
        dbRef.child('$userId').set(users);
  
    } on FirebaseAuthException catch (e){
        throw e;
    }
  
  }

  SignInWithFacebook() async {
    final LoginResult result = await facebookAuth.login();
    final accessToken = await FacebookAuth.instance.accessToken;
    final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await firebaseAuth.signInWithCredential(credential);
  
    if (accessToken != null) {
        
        final userData = await FacebookAuth.instance.getUserData();
        final User? user = await firebaseAuth.currentUser;
        
        String userId = user!.uid;
        Map<String, String> users = {
          'name': userData['name'],
          'email': userData['email'],
          'password': 'Facebook_user',
        };

        dbRef.child('$userId').set(users);
        _accessToken = accessToken;

    } else {
      _login();
    }
  }

  _login() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      
      _accessToken = result.accessToken;
      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;

    }
   
  }

  _loginWithMicrosoft() async {
      final AadOAuth oauth = new AadOAuth(config);
      final result = await oauth.login();

      result.fold(
        (failure) => Errordisplay('Failed to login ******************${failure.toString()}'),
        (token){ Message('Logged in successfully, your access token: $token');},

      );
      var accessToken = await oauth.getAccessToken();
      var idToken = oauth.getIdToken();
      OAuthProvider provider = OAuthProvider('microsoft.com');

      if (accessToken != null) {
        // Use the access token to make an API request to fetch user data.
        final response = await http.get(
            Uri.parse('https://graph.microsoft.com/v1.0/me'),
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
        );


        if (response.statusCode == 200) {

          // Parse the JSON response to extract the user's email.
          final Map<String, dynamic> userData = json.decode(response.body);
          final String userEmail = userData['userPrincipalName']; 
          await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: userEmail,
                    password: 'microsoft_user')
                .then((value) {
                    final User? user = firebaseAuth.currentUser;
                    String userId = user!.uid;
                    Map<String, String> users = {
                      'name': userEmail,
                      'email': userEmail,
                      'password': 'microsoft_user',
                    };

                    dbRef.child('$userId').set(users);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                        content: Text("User Signed In"),
                        duration: Duration(seconds: 3), // Adjust the duration as needed
                    ),);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                }).onError((error, stackTrace) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("An error occurred: ${error.toString()}"),
                        duration: Duration(seconds: 3), // Adjust the duration as needed
                      ),
                    );
              
            });
        } else {
          print('Error fetching user data: ${response.statusCode}');
        }
      }

      // OAuthCredential credential = provider.credential(accessToken: accessToken);
      // print('Logged credential ****************************************: ${credential}');
      // await firebaseAuth.signInWithCredential(credential);
  }

  void Errordisplay(String errorMessage) {
 
    print('Error: $errorMessage');
  }
  void Message(String message) {
    
    print('Message: $message');
  }

}