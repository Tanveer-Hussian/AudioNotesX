import 'package:audio_notes_x/Authentication/SignUpPage.dart';
import 'package:audio_notes_x/Views/HomePage.dart';
import 'package:audio_notes_x/Views/NotePages/NotesHomePage.dart';
import 'package:audio_notes_x/Widgets/FieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatelessWidget{

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;
     final height = MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: AppBar(
         title: Text('Login', style:GoogleFonts.poppins(fontWeight:FontWeight.w600, fontSize:23),), 
         centerTitle: true, 
         backgroundColor:Theme.of(context).colorScheme.primary, 
         foregroundColor:Colors.white,
         automaticallyImplyLeading: false,
       ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height*0.06),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                     width: 80,
                     height: 80,
                     decoration: BoxDecoration(
                       color: Theme.of(context).colorScheme.surface,
                       shape: BoxShape.circle,
                       boxShadow: [
                         BoxShadow(
                           color: Colors.black.withOpacity(0.06),
                           blurRadius: 10,
                           offset: const Offset(0, 4),
                         ),
                       ],
                      ),
                     child: Icon(Icons.record_voice_over_rounded, size:65, color: Theme.of(context).colorScheme.primary), 
                   ),
                 
                   Icon(Icons.add_rounded, size:26,), 

                   Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        ),
                      child: Icon(Icons.task_alt_rounded, size:65, color: Theme.of(context).colorScheme.primary), 
                    ), 

                ],
              ), 


               SizedBox(height: height * 0.05),

              Text(
                'Welcome Back!',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),

              SizedBox(height: height * 0.01),

              Text(
                'Log in to continue voice notes and tasks',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),

              SizedBox(height: height * 0.06),

              FieldWidget(
                  controller: emailController,
                  keyBoardType: TextInputType.emailAddress,
                  hintText: 'Enter email', 
                  validator: (value){
                    if(value.toString().isEmpty){
                      return 'Email is required';
                    }else{
                      return null;
                    }
                   } 
                ),
              SizedBox(height:height*0.01),
          
               FieldWidget(
                  controller: passwordController,
                  keyBoardType: TextInputType.visiblePassword,
                  hintText: 'Enter password', 
                  validator: (value){
                    if(value.toString().isEmpty){
                      return 'Password is required';
                    }else{
                      return null;
                    }
                   } 
                ),
          
                SizedBox(height:height*0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Text("Don't have an account?", style:GoogleFonts.poppins(fontSize:14, color:Theme.of(context).hintColor),),
                     GestureDetector(
                        onTap:(){Get.to(()=> SignUpPage());}, 
                        child:Text('Create Account', style:GoogleFonts.poppins(fontSize:15,fontWeight:FontWeight.w600, color:Theme.of(context).colorScheme.primary),))
                   ],
                ),
                SizedBox(height:height*0.07),
          
                GestureDetector(
                   onTap: () async{
                     if(emailController.text.isEmpty || passwordController.text.isEmpty){                       
                       showDialog(
                         context: context,
                         builder:(context){ 
                            return AlertDialog(
                              title: Text('Could not login'),
                              content: Text('Please fill all required fields'), 
                              actions: [
                                Container(
                                  width: 68,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                   ),
                                  child: TextButton(
                                     onPressed:(){Get.back();}, 
                                     child:Text('Ok', style:TextStyle(fontSize:16, color:Colors.white),)
                                   ),
                                )
                              ],                             
                            );
                          }
                        );
                      }else{                   
                          final prefs = await SharedPreferences.getInstance();
                          final existingEmail = prefs.getString('userId');
                          final existingPassword = prefs.getString('password');
                        if(emailController.text==existingEmail && passwordController.text==existingPassword){
                            prefs.setBool('isLoggedIn', true);
                            Get.offAll(HomePage());
                        }else{                        
                          Get.snackbar('Could not login', 'Credentials did not match', duration: Duration(seconds:1));
                         }
                      }
                    },
                 
                   child: Container(
                      width: width*0.85,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                     child: Center(child: Text('Login', style:GoogleFonts.poppins(color: Colors.white, fontSize:17, fontWeight:FontWeight.w600),),),
                   ),
                 )
          
            ],
          ),
        ),
      ),
  
    );
  }
} 
