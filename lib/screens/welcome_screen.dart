import 'package:flutter/material.dart';
import 'package:beauty_hack/reusable_widgets/reusable_widget.dart';
import 'package:beauty_hack/screens/signin_screen.dart';
import 'package:beauty_hack/screens/signup_screen.dart';
import 'package:beauty_hack/utils/color_utils.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {


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
            child: Column(
             
              children: [
          
                const SizedBox(
                    height: 50,
                ),
                const Text('Welcome to the developers world',
                 style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                 ),),
                const SizedBox(
                    height: 2,
                ),
                const Text('Dive into the world of devs',
                 style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                  fontFamily: "Helvetica"
                 ),),
                const SizedBox(
                    height: 100,
                ),
                Image.asset('assets/images/devs.png', height: 400, width: 400,),
                const SizedBox(
                    height: 75,
                ),
                firebaseWelcomeButton(context, "GET STARTED", () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()));
                }),
                
              ],
            ),
          ),
    );
  }

}