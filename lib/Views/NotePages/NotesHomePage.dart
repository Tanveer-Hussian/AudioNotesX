import 'package:audio_notes_x/Authentication/LoginPage.dart';
import 'package:audio_notes_x/Controllers/NotesControllers/NotesController.dart';
import 'package:audio_notes_x/Data/NotesModels/Boxes.dart';
import 'package:audio_notes_x/Data/NotesModels/NotesModel.dart';
import 'package:audio_notes_x/Views/NotePages/AddNotePage.dart';
import 'package:audio_notes_x/Views/NotePages/NoteDetailPage.dart';
import 'package:audio_notes_x/Views/NotePages/SearchingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotesHomePage extends StatelessWidget{
 
   final notesController = Get.find<NotesController>();
   final edittedTitle = TextEditingController();
   final edittedText = TextEditingController();

  @override
  Widget build(BuildContext context) {
   
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: AppBar(
         title: Row(
           children: [
             SizedBox(width:5),
             Container(
                width: 34,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Icon(Icons.record_voice_over_rounded, size:20, color:Colors.white)
              ),
             SizedBox(width:19), 
             Text('Voice Notes', style:GoogleFonts.poppins(color:Colors.white, fontSize:21, fontWeight:FontWeight.w600),),
                
           ],
         ), 
         centerTitle: false, 
         backgroundColor: Theme.of(context).colorScheme.primary,
         elevation: 0,
         automaticallyImplyLeading: false,
         actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded, color: Colors.white),
              onSelected: (value) async{
                 if (value == 'logout') {
                   final prefs = await SharedPreferences.getInstance();
                   prefs.setBool('isLoggedIn', false);
                   Get.to(LoginPage());
                 }
               },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.red[600]),
                      SizedBox(width: 12),
                      Text('Logout', style: TextStyle(color: Colors.red[600])),
                    ]
                  ),
                ),
            ],
          )]

        ),

       body: notesController.notes.isEmpty
      
          ? 

         SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left:7),
              child: Container(
                 height: height*0.75,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [

                     Container(
                        height: height*0.25,
                        child: Icon(Icons.record_voice_over, size:100, color:Colors.blueGrey.withOpacity(0.3),),
                      ),
                     SizedBox(height: height*0.03), 
                     Text(
                        'No notes yet', 
                        style:GoogleFonts.poppins(fontSize:22,fontWeight:FontWeight.w600,color:Colors.blueGrey[700]),
                      ),
                     SizedBox(height:height*0.01),
                     Text( 
                        'Tap the + button to create your first voice note', 
                        textAlign:TextAlign.center, 
                        style:GoogleFonts.poppins(fontSize:14, color:Colors.blueGrey[500]),
                      ),

                      SizedBox(height: height * 0.04),
             
                      ElevatedButton.icon(
                        onPressed: () => Get.to(AddNotePage()),
                        icon: Icon(Icons.mic, size: 20),
                        label: Text('Create First Note'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal:24, vertical:14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                   ],
                 )
              ),
            ),
          )

          : 

       Column(
         children: [
     
           SizedBox(height:height*0.01),
          
           // -- Search Bar --
           GestureDetector(
             onTap: (){Get.to(SearchPage(notesController:notesController));},
             child: Container(
                width: width*0.90,
                height: height*0.06,
                margin: EdgeInsets.symmetric(horizontal:width*0.04, vertical:8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color:Theme.of(context).cardColor,
                  border: Border.all(color:Theme.of(context).dividerColor.withOpacity(0.5)),
                   boxShadow: [                                  
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0,3),
                        spreadRadius: 1
                      ),
                    ],
                 ),
                child: Row(
                  children: [
                    SizedBox(width:16),
                    Icon(Icons.search_rounded, size:22, color: Theme.of(context).hintColor.withOpacity(0.7)), 
                    SizedBox(width:12),
                    Expanded(
                      child: Text(
                        "Search your voice notes...",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Theme.of(context).hintColor, 
                          fontWeight: FontWeight.w400       
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
           SizedBox(height:height*0.01),
          
           Expanded(
             child: ValueListenableBuilder<Box<NotesModel>>(
                valueListenable: Hive.box<NotesModel>('notes').listenable(),
                builder: (context,box,_){

                   var data = box.values.where((note)=> note.userId==notesController.userId).toList();
                   data = data.reversed.toList();
                  
                  return ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      final note = data[index];
                      String formattedTime = DateFormat('dd-MM-yyyy').format(DateTime.parse(note.timeStamp.toString()));
                      return Padding(
                        padding: const EdgeInsets.only(top:5, bottom:3, left:12, right:9),
                        child: GestureDetector(
                          onTap: (){
                            Get.to(NoteDetailPage(note:note, notesController:notesController, index:index,));
                          },
                          child: SlideableWidget(note, index, width, height, formattedTime, context),
                        ),
                      ); 
                    }
                 );
               }         
             ),
           ),
       
         ], 
       ),


      floatingActionButton: notesController.notes.isEmpty 
          ? SizedBox.shrink()
          : Padding(
            padding: const EdgeInsets.only(bottom:50),
            child: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 6,
                onPressed: (){
                    Get.to(AddNotePage()); 
                  },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                   width: 56,
                   height: 56,
                   child: Icon(Icons.add_rounded, size:29, color:Colors.white,)),
              ),
          ),

     );
  }



  Widget SlideableWidget(NotesModel note, int index, double width, double height, String formattedTime, BuildContext context) {
     return Slidable(
            key: ValueKey(note.key),
            endActionPane: ActionPane(
                motion:const DrawerMotion(), 
                children:[

                  SlidableAction(
                      icon: Icons.edit,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      label: 'Edit',
                      onPressed: (context){
                           edittedTitle.text = note.title;
                           edittedText.text = note.text;
                          Get.bottomSheet(
                             Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                 color: Theme.of(context).colorScheme.surface,
                 borderRadius: BorderRadius.vertical(top:Radius.circular(20))
               ),
            child: SingleChildScrollView(
              child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                
                      Text('Edit Note', style:GoogleFonts.poppins(fontSize:18, fontWeight:FontWeight.bold),),
                      const SizedBox(height:12),
                
                      TextFormField(
                        controller: edittedTitle,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius:BorderRadius.circular(5)),
                          hintText:'Enter Title'
                         ),
                        ),
                      SizedBox(height:8),
                
                      TextFormField(
                        controller: edittedText,
                        maxLines: 6,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius:BorderRadius.circular(5)),
                          hintText:'Enter Text'
                        ),  
                       ),
                      SizedBox(height:20),
                
                      ElevatedButton(
                         style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(double.infinity,40)
                          ),
                          child: Text("Save"),
                          onPressed:(){
                            if(edittedTitle.text.trim().isEmpty|| edittedText.text.trim().isEmpty){
                              Get.snackbar(
                                "Invalid Input",
                                "Both Title & Text are required",
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                              );
                              return; 
                            }                        
                            notesController.editNote(
                                note.key, edittedTitle.text.trim(),
                                edittedText.text.trim(), DateTime.now()
                              );
                            Get.back();
                          }, 
                        ),
                    ],
                  ),
            ),
          ),
        ),                     
                            
                             isDismissible: true,
                             enableDrag: true,
                           );
                        },                              
                      ),

                  SlidableAction(
                      icon: Icons.delete,
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Colors.white,
                      label: 'Delete',
                      onPressed: (context){
                        Get.dialog(
                          AlertDialog(
                            title: Text('Are you sure?'),
                            actions: [
                                ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey[500],
                                  foregroundColor:Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text('Cancel'),
                                onPressed:(){Get.back();}
                                ),
                                ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor:Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text('Delete'),
                                onPressed:(){
                                    notesController.deleteNote(index);
                                    Get.back();
                                  }
                                ),
                            ],
                          )
                        );
                         
                        }
                    ),
               
                  ],
                ),

              child: Container(
                margin: EdgeInsets.symmetric(horizontal:10, vertical:2),
                padding: EdgeInsets.all(12),
                width: width*0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(                                      
                      color: Colors.black.withOpacity(0.05),
                      blurRadius:8,
                      offset: Offset(0,2),
                      spreadRadius:1
                    ),
                  ],
                ),
               child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: _getNoteColor(note).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.record_voice_over_rounded, size:22, color:_getNoteColor(note)),
                    ),
                 
                   SizedBox(width:16),
                  
                   Expanded(
                     child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(note.title, style:GoogleFonts.poppins(fontSize:16,fontWeight:FontWeight.w600,color:Theme.of(context).textTheme.bodyLarge!.color, height:1.3)),
                          SizedBox(height:height*0.01,),
                          Text(formattedTime, style:GoogleFonts.poppins(fontSize:12, color: Theme.of(context).hintColor, fontWeight:FontWeight.w400),),                           
                        ],
                      ),
                   ),

                 ],
               ),
              ),
   
      );
   }


   Color _getNoteColor(NotesModel note) {
     final colors = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.pinkAccent,
    ];
     return colors[note.title.hashCode % colors.length];
   }


}

