import 'package:audio_notes_x/Authentication/LoginPage.dart';
import 'package:audio_notes_x/Widgets/FieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignUpPage extends StatelessWidget{

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;
     final height = MediaQuery.of(context).size.height;

    return Scaffold(
     
      appBar: AppBar(
         title: Text('SignUp', style:GoogleFonts.poppins(fontWeight:FontWeight.w600, fontSize:23),), 
         centerTitle: true, 
         backgroundColor:Theme.of(context).colorScheme.primary, 
         foregroundColor:Colors.white,
       ),
       
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: SingleChildScrollView(
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
            children: [
 
              SizedBox(height: height * 0.05),   
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

              SizedBox(height:height*0.12),
              FieldWidget(
                controller: nameController,
                keyBoardType: TextInputType.name,
                hintText: 'Enter name', 
                validator: (value){
                  if(value.toString().isEmpty){
                    return 'Name is required';
                  }else{
                    return null;
                  }
                  } 
              ),
              SizedBox(height:height*0.01), 
        
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Text('Already have an account?',style:GoogleFonts.poppins(fontSize:14, color:Theme.of(context).hintColor),),
                    TextButton(
                      onPressed:(){Get.to(()=> LoginPage());}, 
                      child:Text('Login', style:GoogleFonts.poppins(fontSize:16.5,fontWeight:FontWeight.w600, color:Theme.of(context).colorScheme.primary),))
                 ],
               ),

              SizedBox(height:height*0.06),        
              GestureDetector(
                  onTap: () async{
                     if(nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty){
                       showDialog(
                         context: context,
                         builder:(context){ 
                            return AlertDialog(
                              title: Text('Could not signup'),
                              content: Text('Kindly fill all required fields', style:GoogleFonts.poppins(fontSize:14),),
                              actions: [
                                GestureDetector(
                                  onTap:(){Get.back();},
                                  child: Container(
                                     width: 68,
                                     height: 45,
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(12),
                                       color: Colors.green,
                                     ),
                                     child:Center(child: Text('Ok', style:GoogleFonts.poppins(fontSize:16, fontWeight:FontWeight.w600, color:Colors.white),))
                                   ),
                                ),
                              ],
                            );
                          }
                       );
                     }else{
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('name', nameController.text.toLowerCase());
                        prefs.setString('userId', emailController.text);
                        prefs.setString('password', passwordController.text);
                       // ignore: use_build_context_synchronously
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
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
                    child: Center(child: Text('Create Account', style:GoogleFonts.poppins(color: Colors.white, fontSize:16, fontWeight:FontWeight.w600),),),
                  ),
              )
              
            ],
          ),
        ),
      ),
    );
  }
} 
