import 'dart:ui';

import 'package:audio_notes_x/Controllers/NavController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class HomePage extends StatelessWidget{

   final controller = Get.put(NavController());

   final List<String> titles = [
     'Notes',
     'Tasks',
    ];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        extendBody: true,

        body: AnimatedSwitcher(
           duration: const Duration(milliseconds:320),
           transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
           child: Obx(()=> controller.pages[controller.index.value]),
         ),

        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
             topLeft: Radius.circular(28),
             topRight: Radius.circular(28),
           ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX:16, sigmaY:16),
            child: Container(
               decoration: BoxDecoration(
                   color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.32) // slightly stronger in dark mode
                      : Colors.white.withOpacity(0.22),
                   border: Border(top: BorderSide(color: Colors.white.withOpacity(0.18), width: 1.2)),
                   boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius:10,
                        offset: const Offset(0,-3),
                      ),
                   ],
                ),
             
               child: Obx(()=>
                 BottomNavigationBar(
                   type: BottomNavigationBarType.fixed,
                  
                   selectedItemColor: Theme.of(context).colorScheme.primary,
                   unselectedItemColor: Theme.of(context).unselectedWidgetColor.withOpacity(0.74),
                   currentIndex: controller.index.value,
                 
                   unselectedLabelStyle:  GoogleFonts.poppins(fontSize:11.5, fontWeight: FontWeight.w400),
                   selectedLabelStyle: GoogleFonts.poppins(fontSize:12.5, letterSpacing:0.2, fontWeight: FontWeight.w600),
                   
                   selectedIconTheme: const IconThemeData(size:28),
                   unselectedIconTheme: const IconThemeData(size:25),
                 
                   backgroundColor: Colors.transparent,
                   elevation: 0,
                   items: const [
                      BottomNavigationBarItem(label:'Notes', icon:Icon(Icons.record_voice_over_rounded, size:26)),
                      BottomNavigationBarItem(label:'Tasks', icon:Icon(Icons.task_alt_rounded, size:26)),
                    ],
                   onTap: (value){
                     controller.index.value = value;
                   },
                 ),
               ),
                       
             ),
          ),
        ),

    );
  }
}

