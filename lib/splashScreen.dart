import 'dart:math';
import 'package:audio_notes_x/Authentication/LoginPage.dart';
import 'package:audio_notes_x/Views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late final prefs;
  bool? isLoggedIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    checkLogin();

    Future.delayed(Duration(seconds: 3), () {
       Get.off(() => isLoggedIn! ? HomePage() : LoginPage());
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


   void checkLogin() async{
      prefs = await SharedPreferences.getInstance();
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
   }


  Widget buildBar(int index) {
   return AnimatedBuilder(
     animation: _controller,
     builder: (context, child) {
       double height = 10 + Random(index).nextDouble() * 60 * _controller.value;

       return Container(
         margin: EdgeInsets.symmetric(horizontal: 4),
         width: 8,
         height: height,
         decoration: BoxDecoration(
           gradient: LinearGradient(
             colors: [
               Color(0xFF6A5AE0),  // Purple
               Color(0xFF00D1FF),  // Cyan
              ],
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
            ),
           borderRadius: BorderRadius.circular(20),
         ),
       );
     },
   );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // === Animated Waveform (Bars) ===
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(12, (i) => buildBar(i)),
            ),

            SizedBox(height: 20),

            // === App Name ===
            Text(
              "AudioNotes X",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
              ),
            ),

            SizedBox(height: 6),

            Text(
              "Organize Your Thoughts",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
