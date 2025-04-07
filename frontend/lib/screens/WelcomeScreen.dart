import 'package:chanakya/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/api/auth_api.dart';
import 'loginScreen.dart';
import 'regScreen.dart';


class WelcomeScreen extends StatefulWidget{
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final AuthService _authService = AuthService();

  void _signInWithGoogle() async {
    try{
      User? user = await _authService.signInWithGoogle();
      if(user == null) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (Route<dynamic> route) => false);
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors:[
              Color(0xff16A085), // Teal Green
              Color(0xff0B3D2E), // Deep Green
            ]
          )
        ),
      child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 130.0),
              child:Image(
                image: AssetImage('assets/logo.png'),
                width: 190,
                height: 190,

              )
    ),
            const SizedBox(
              height: 50,
            ),
            const Text('Welcome', style:TextStyle(
              fontSize: 30,
              color: Colors.white

            ),),
            SizedBox(height: 30),
            GestureDetector(
              onTap:(){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage(verify: false,)));
              },
            child:Container(
              height:53,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color:Colors.white),

              ),
              child: const Center(child: Text('SIGN IN', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),),
            ),
            ),
            SizedBox(height: 25,),
        GestureDetector(
          onTap:(){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterScreen()));
          },
            child:Container(
              height:53,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color:Colors.white),

              ),
              child: const Center(child: Text('SIGN UP', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),),),
            ),
        ),
            const SizedBox(height: 25),
            const Row(
              children: [
                SizedBox(width: 25),
                Expanded(
                  child: Divider(
                    color: Colors.white70,
                    thickness: 1,
                    endIndent: 10, // Space between line and text
                  ),
                ),
                Text(
                  'or',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.white70,
                    thickness: 1,
                    indent: 10, // Space between line and text
                  ),
                ),
                SizedBox(width: 25),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Continue with',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            IconButton(
              icon: SizedBox(
                width: 30,  // Set width
                height: 30, // Set height
                child: Image.asset('assets/google.png'),
              ),
              onPressed: _signInWithGoogle,
            ),


          ],
      )
      )
    );
  }
}