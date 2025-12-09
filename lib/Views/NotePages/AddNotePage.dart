import 'package:audio_notes_x/Controllers/NotesControllers/NotesController.dart';
import 'package:audio_notes_x/Controllers/NotesControllers/SpeechController.dart';
import 'package:audio_notes_x/Views/HomePage.dart';
import 'package:audio_notes_x/Views/NotePages/NotesHomePage.dart';
import 'package:audio_notes_x/Widgets/BarWaveFormVisualizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class AddNotePage extends StatelessWidget{

    final controller = Get.put(SpeechController());
    final noteController = Get.find<NotesController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Add Note', style:GoogleFonts.poppins(fontSize:21,fontWeight:FontWeight.bold,color:Colors.blueGrey[700]),), 
        centerTitle: true,
        actions: [
          Obx((){
            if(controller.isListening.value || controller.wordsSpoken.value.isEmpty){
               return Icon(Icons.save,size:26,color:Colors.grey);
             }else{  
                return IconButton(
              onPressed:(){
                 String title = generateTitle(controller.wordsSpoken.value);
                 String text = controller.wordsSpoken.value;
                 title = CapitalizeFirst(title);
                 text = CapitalizeFirst(text);
                 noteController.addNote(text,title,DateTime.now());
                 controller.wordsSpoken.value='';
                Get.off(NotesHomePage());
               }, 
              icon:Icon(Icons.save, size:26, color:Colors.red[500]),
             );
            }
           }
          ),

          SizedBox(width:10),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           SizedBox(height:20),

    

          Obx(()=>
             Text(
                 controller.isListening.value 
                     ? 'Listening...Speak now' 
                     : (controller.speechEnabled.value ? 'Tap on mic to start recording':'Speech not available'), 
                  style:GoogleFonts.poppins(
                     fontSize:15,
                     color:controller.isListening.value?Colors.green[700]:Colors.blueGrey[700], 
                     fontWeight:FontWeight.w500,
                  )
              ),
            ),
           
           SizedBox(height:20),
                  
           Obx((){
             if(controller.wordsSpoken.value.isNotEmpty){
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal:10),
                  padding: const EdgeInsets.all(16),
                  decoration:BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius:BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[300]!)
                  ),
                  child: Text(
                      controller.wordsSpoken.value, 
                      style:GoogleFonts.poppins(fontSize:15, fontWeight:FontWeight.w600, color:Colors.grey[800], height:1.8),
                   ),
                );
             }else{
                return Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.format_quote, size:40, color:Colors.grey[400],),
                    SizedBox(height:12),
                    Text('Your spoken words will\n appear here..', style: GoogleFonts.poppins(fontSize:16, color:Colors.grey[600], fontStyle:FontStyle.italic),),
                    SizedBox(height:8),
                    Text('Start Speaking to see the magic', style:GoogleFonts.poppins(fontSize:13, color:Colors.grey[500]),),
                  ],
                );
              }  
           }),  
        
           SizedBox(height:10),

           Padding(
             padding: const EdgeInsets.symmetric(horizontal:10),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                
                Obx(()=>
                   TextButton.icon(
                     onPressed:(){
                        controller.wordsSpoken.value = '';
                        controller.waveformData.clear();
                      }, 
                     label: Text('Reset all'),
                     icon: Icon(Icons.refresh),
                     style: TextButton.styleFrom(
                       foregroundColor: controller.wordsSpoken.value.isNotEmpty ? Colors.red[600] : Colors.grey[500],
                       padding: EdgeInsets.symmetric(horizontal:16, vertical:10)
                     ),
                    ),
                 ),
                
                Obx((){
                  if(controller.isListening.value){ 
                   return Container(
                        padding:EdgeInsets.symmetric(horizontal:12, vertical:6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(width:10, height:7, decoration:BoxDecoration(color:Colors.red, shape:BoxShape.circle)), 
                            SizedBox(width:3),
                            Text('Recording', style:GoogleFonts.poppins(fontSize:12, fontWeight:FontWeight.w600, color:Colors.green[800])),
                          ],
                        ),
                        );
                  }else{    
                    return SizedBox(width:5);
                  } 
                }), 
          
               ],
             ),
           ),                 
           
           SizedBox(height: 250),

           Obx(() => controller.isListening.value
                ? BarWaveformVisualizer(
                      waveformData: controller.waveformData,
                      height: 100, 
                      barColor: Colors.blueAccent,
                      backgroundColor: Colors.grey[50]!,
                      maxBars: 40,                    
                  )
                : 
               SizedBox.shrink(),
            ),

          ],
        ),        
       ),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom:20),
        child: Obx((){
            return Stack(
              alignment: Alignment.center,
              children: [
            
                  if (controller.isListening.value)
                       Container(
                          width: 82,
                          height: 82,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.red.withOpacity(0.5)
                             ),
                            strokeWidth: 3,
                            value: null, // Indeterminate
                          ),
                        ),

                 FloatingActionButton(         
                    shape: CircleBorder(),
                    elevation:6,
                    backgroundColor: controller.isListening.value? Colors.red: Colors.blueAccent,
                    onPressed: (){controller.isListening.value?controller.stopListening():controller.startListening();},
                    child: Container(
                        width:70, height:70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: controller.isListening.value ? [Colors.red, Colors.redAccent] : [Colors.blueAccent, Colors.lightBlue]
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: controller.isListening.value ? Colors.red.withOpacity(0.4) : Colors.blue.withOpacity(0.4),
                              blurRadius: 10,
                              offset: Offset(0,4)  
                            )
                          ] 
                        ),
                        child: Icon(controller.isListening.value? Icons.stop : Icons.mic, color:Colors.white, size:32,)
                    ),
                  )


              ],
            );

        }),
       ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }


  String generateTitle(String spokenText){
    if(spokenText.isEmpty){
      return 'UnTitled';
    }else{
      List<String> sentences = spokenText.split(RegExp(r'[.!?\n]'));
      String firstSentence = sentences.first.trim();
      if(firstSentence.length>30){
        return firstSentence.substring(0,20)+'...';
      }else{
        return firstSentence;
      } 
     }
   }


  String CapitalizeFirst(String value){
     if(value.trim().isEmpty) return value;
     return value[0].toUpperCase()+value.substring(1);
   }



 }

