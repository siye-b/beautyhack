import 'package:flutter/material.dart';
import 'package:beauty_hack/screens/home_screen.dart';
import 'package:beauty_hack/screens/signin_screen.dart';
import 'package:beauty_hack/screens/welcome_screen.dart';
import 'package:beauty_hack/utils/color_utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Launch extends StatefulWidget {
Launch({super.key});

  @override
  State<Launch> createState() => LaunchState();
}

class LaunchState extends State<Launch> {


  //  final GetStorage _getStorage = GetStorage();
   static const String KEYLOGIN = "login";

  @override
  void initState(){
    super.initState();
    _navigateTohome();
  }

 

  _navigateTohome()async{

      var sharedPref = await SharedPreferences.getInstance();
      var isLoggedIn = sharedPref.getBool(KEYLOGIN);

      await Future.delayed(const Duration(milliseconds: 5000),(){
        if(isLoggedIn!=null){

            if(isLoggedIn){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
            } else {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInScreen()));
            }

        } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WelcomeScreen()));
        }
      });
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/PnAPlcAVVu.json', width: 200, height: 200),
            // Container(height: 100, width: 100,
            //  decoration: BoxDecoration(
            //   gradient: LinearGradient(colors: [
            //     hexStringToColor("0B5394"),
            //     hexStringToColor("53677A"),
            //     hexStringToColor("F3F6F4")
            //   ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),),
            Container(
              child: Text('Developers World', style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 51, 81, 105),
                
              ),),
            ),
          ],
        ),
      ),
    );
  }
}