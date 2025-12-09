import 'package:audio_notes_x/Controllers/NotesControllers/NotesController.dart';
import 'package:audio_notes_x/Controllers/NotesControllers/TtsController.dart';
import 'package:audio_notes_x/Data/NotesModels/NotesModel.dart';
import 'package:audio_notes_x/Views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class NoteDetailPage extends StatelessWidget{

    NotesModel note; 
    NotesController notesController;
    int index;
    NoteDetailPage({required this.note, required this.notesController, required this.index});

    final ttsController = Get.find<TtsController>();

    final edittedTitle = TextEditingController();
    final edittedText = TextEditingController();
   
  @override
  Widget build(BuildContext context) {

      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;
      String formattedDate = DateFormat('dd-MMM-yyyy hh:mm a').format(DateTime.parse(note.timeStamp.toString()));
      int wordsCount = note.text.split(' ').length;

     return Scaffold(

       appBar: AppBar(
          automaticallyImplyLeading:true, 
          titleSpacing: 0,
          leadingWidth: 60,

          leading: SizedBox(
            child: IconButton(
              onPressed:(){Get.to(()=>HomePage());}, 
              icon: Container(
                 width:40, height:40,
                 decoration: BoxDecoration(
                   color: Theme.of(context).colorScheme.surface,
                   borderRadius: BorderRadius.circular(12)
                 ),
                 child: Icon(Icons.arrow_back_ios_rounded, size:20, color:Theme.of(context).colorScheme.onSurface),
               )
            ),
          ),
         
          title:Text(' \tNote Details', style:GoogleFonts.poppins(fontSize:20, fontWeight:FontWeight.w600)), 
          
          centerTitle:false,
          elevation:0,
          backgroundColor: Colors.transparent,

          actions: [
            IconButton(
              onPressed:(){}, 
              icon: Icon(Icons.share_rounded),
            ),

            PopupMenuButton(
              icon: Container(
                 width: 40,
                 height: 40,
                 decoration: BoxDecoration(
                   color: Theme.of(context).colorScheme.surface,
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Icon(
                   Icons.more_vert_rounded,
                   size: 22,
                   color: Theme.of(context).colorScheme.onSurface,
                 ),
               ),
              onSelected: (value){
                 if(value=='Edit'){
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
                      isScrollControlled: true
                    );  
                 }else if(value=='Delete'){
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
               },
              itemBuilder: (context) =>[
                PopupMenuItem(
                  value: 'Edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size:20,),
                      SizedBox(width:12),
                      Text('Edit Note')
                    ],)
                ),
                PopupMenuItem(
                  value: 'Delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size:20, color:Colors.red,),
                      SizedBox(width:12),
                      Text('Delete Note')
                    ],)
                ),
              ]
            ),
           
            SizedBox(width:6),
          ],    
        ),

     
       body: SingleChildScrollView(
         physics: BouncingScrollPhysics(),

         child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            //  mainAxisAlignment: MainAxisAlignment.start,
             children: [

          // ----- Header Section -----           
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:24, vertical:16),
                  child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                  // --- Title Section ---   
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                               note.title, 
                               style:GoogleFonts.poppins(fontSize:20, fontWeight:FontWeight.w500, color: Theme.of(context).colorScheme.onBackground, height: 1.2,),
                               maxLines:2,
                               overflow: TextOverflow.ellipsis,  
                             ),
                           ),
                        ],
                      ),

                      SizedBox(height:16),

                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [ 

                          Container(
                            width: width*0.57,
                            padding: EdgeInsets.symmetric(horizontal:10, vertical:6),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[600]!.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time_rounded, size:17, color: Colors.lightBlue[600]),
                                SizedBox(width:10),
                                Text(formattedDate, style:GoogleFonts.poppins(fontSize:13, fontWeight:FontWeight.w600, color:Colors.lightBlue[600]),),
                               ],
                             ),
                          ),
                      
                          Container(
                            width: width*0.3,
                            padding: EdgeInsets.symmetric(horizontal:10, vertical:6),
                            decoration: BoxDecoration(
                              color: Colors.green[600]!.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.text_fields_rounded, size:17, color: Colors.green[600]),
                                SizedBox(width:10),
                                Text("$wordsCount words", style:GoogleFonts.poppins(fontSize:13, fontWeight:FontWeight.w600, color:Colors.green[600]),),
                               ],
                             ),
                           ),
                      

                         ]
                       ),

                     SizedBox(height:height*0.024),
                              
                  ],
                ),
              ),

           
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                      
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed:(){
                            ttsController.flutterTts.speak(note.text);
                          },
                          icon:  Icon(Icons.record_voice_over_rounded, color:Colors.red,),
                        ),
                        IconButton(
                          onPressed:(){
                            Clipboard.setData(ClipboardData(text:note.text));
                            //  Get.snackbar('Note copied', 'Note has been copied', duration:Duration(seconds:1), backgroundColor:Colors.blue[200]);
                          }, 
                          icon: Icon(Icons.copy, size:20, color:Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ), 
              
                    SizedBox(height:height*0.01), 

                    Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3))
                      ),
                      child: Obx((){
                            final start = ttsController.currentWordStart.value;
                            final end = ttsController.currentWordEnd.value;
                        return RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.poppins(color:Colors.blueGrey[700], fontSize:16),
                              children: [
                                TextSpan(
                                  text: note.text.substring(0,start),
                                ),
                                if(end>start)
                                  TextSpan(
                                    text: note.text.substring(start, end),
                                    style: TextStyle(backgroundColor: Colors.blue.withOpacity(0.3), color: Theme.of(context).colorScheme.onSurface)
                                  ),
                                if(end<note.text.length)
                                  TextSpan(
                                    text: note.text.substring(end),
                                  ),
                              ]
                            ),
                        );
                        }
                    )),
                  
                  ],
              )),
                
             ],
           ),
       ),
     

      );
   }
 }

