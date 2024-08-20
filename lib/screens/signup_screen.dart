
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:beauty_hack/screens/home_screen.dart';
import 'package:beauty_hack/screens/signin_screen.dart';
import 'package:beauty_hack/reusable_widgets/reusable_widget.dart';
import 'package:beauty_hack/utils/color_utils.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  bool success = false;
  bool _obscured = false;
  bool _obscuredConfirm = false;


  late DatabaseReference dbRef;

  @override
  void initState() {
      super.initState();
      dbRef = FirebaseDatabase.instance.ref().child('Users');
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;    
    });
  }

  void _toggleObscuredConfirm() {
    setState(() {
      _obscuredConfirm = !_obscuredConfirm;    
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
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
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.3, 20, 0),
            child: Column(
              children: <Widget>[
                
                const SizedBox(
                  height: 1,
                ),
                const Text("Create Account",
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 30)),
                const SizedBox(
                  height: 10,
                ),
                const Text("Discover Nearby Dev Teams Collabs",
                      style: TextStyle(color: Colors.white60, fontSize: 15)),
                const SizedBox(
                  height: 40,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
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
                    labelText: "Password",
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
                  height: 20,
                ),
                
                TextField(
                  controller: _confirmPasswordTextController,
                  obscureText: !_obscuredConfirm,
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
                          onTap: _toggleObscuredConfirm,
                          child: Icon(
                            _obscuredConfirm
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            size: 24,
                          ),
                        ),
                    ),
                    labelText: "Confirm Password",
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
                FlutterPwValidator(
                    controller: _passwordTextController,
                    minLength: 8,
                    uppercaseCharCount: 1,
                    lowercaseCharCount: 3,
                    numericCharCount: 3,
                    specialCharCount: 1,
                    width: 400,
                    height: 200,
                    onSuccess: () {
                        setState(() {
                          success = true;
                        });
                        print("MATCHED");
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Password is matched")));
                      },
                    onFail: () {
                        setState(() {
                          success = false;
                        });
                        print("NOT MATCHED");
                    },
                ),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () {
                    final enteredPassword = _passwordTextController.text;
                    final confirmPassword = _confirmPasswordTextController.text;
                    final enteredEmail = _emailTextController.text;

                    if (_emailTextController.text.isEmpty || _passwordTextController.text.isEmpty || _userNameTextController.text.isEmpty || _confirmPasswordTextController.text.isEmpty) {
                    
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter all the above fields."),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        return;
                    }
                    else if(enteredPassword != confirmPassword){

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords must match , Enter matching passwords.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                    
                    }else if (!isEmailValid(enteredEmail)){
                        ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email prefix Must contain atleast 4 characters, with domain: gmail.com'),
                                duration: Duration(seconds: 3),
                              ),
                        );
                    }
                    else{

                        FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("User Registered"),
                                  duration: Duration(seconds: 3), // Adjust the duration as needed
                                ),
                              );
                        
                              Map<String, String> users = {
                                'name': _userNameTextController.text,
                                'email': _emailTextController.text,
                                'password': _passwordTextController.text
                              };
                              dbRef.push().set(users);
          
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const SignInScreen()));
                          
                          }).onError((error, stackTrace) {

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("An error occurred: ${error.toString()}"),
                                  duration: const Duration(seconds: 3), // Adjust the duration as needed
                                ),
                              );
                            });
                    }
                }),
                signInOption(),
              ],
            ),
          ))),
    );
  }

  bool isPasswordValid(String password) {
    // Define your password pattern
    const pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  bool isEmailValid(String email) {
    // Define your password pattern
    const pattern = r'^[a-z0-9]+@gmail+\.+com$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?",
            style: TextStyle(color: Color.fromARGB(255, 85, 111, 133))),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          },
          child: const Text(
            " Login",
            style: TextStyle(color: Color.fromARGB(255, 51, 81, 105), fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

}