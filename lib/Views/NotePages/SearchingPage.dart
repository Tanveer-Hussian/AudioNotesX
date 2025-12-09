import 'package:audio_notes_x/Controllers/NotesControllers/NotesController.dart';
import 'package:audio_notes_x/Controllers/NotesControllers/SearchController.dart';
import 'package:audio_notes_x/Data/NotesModels/Boxes.dart';
import 'package:audio_notes_x/Data/NotesModels/NotesModel.dart';
import 'package:audio_notes_x/Views/NotePages/NoteDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class SearchPage extends StatelessWidget{

    final titleController = TextEditingController();
    final searchController = Get.put(SearchingController(), tag: UniqueKey().toString());
    NotesController notesController;

    SearchPage({required this.notesController});

   
  @override
  Widget build(BuildContext context) {

      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;
      
    return WillPopScope(
      onWillPop: ()async{
         titleController.clear();
         searchController.filteredNotesList.clear();
         return true; 
       },    
      child: Scaffold(    
        
        appBar: AppBar(
          title: Text(
            'Search Notes',
            style: GoogleFonts.poppins(fontSize:20, fontWeight:FontWeight.w700, letterSpacing:0.3),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
         ),
      
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                  height: 56,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color:Theme.of(context).colorScheme.surface,
                      border: Border.all(color:Theme.of(context).dividerColor.withOpacity(0.3), width:1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 10),
                        ),
                      ],
                   ),
                  child: TextFormField(
                     controller: titleController,
                     style: GoogleFonts.poppins(fontSize: 15.5),
                     decoration: InputDecoration(
                        hintText: 'Search your voice notes...',
                        hintStyle: GoogleFonts.poppins(color: Theme.of(context).hintColor, fontSize:15.5),
                        prefixIcon: Icon(Icons.search_rounded, color:Theme.of(context).hintColor.withOpacity(0.7), size:24,),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical:16),
                      ),
                     onChanged: (value){
                        final notes = Boxes.getData().values.toList();
                        searchController.filteredNotesList.assignAll(
                           notes.where((note)=> 
                             note.title.toLowerCase().contains(value.toLowerCase())).toList(),
                         );
                       },
                    ),
                 ),
      
               SizedBox(height:height*0.015),
      
               Expanded(
                 child: Obx((){

                    final filteredNotes = searchController.filteredNotesList.where((note)=>note.userId==notesController.userId).toList();

                 //   print(filteredNotes.length);

                    if(filteredNotes.isEmpty){
                       return Center(
                        child: Text('No matching notes found!', style:GoogleFonts.poppins(fontSize:16, color:Colors.blueGrey[300]),),
                      );
                     }

                    return ListView.builder(
                      itemCount: filteredNotes.length,
                      itemBuilder: (context,index){
                         final note = filteredNotes[index];
                         return GestureDetector(
                           onTap: (){Get.to(NoteDetailPage(note:note, notesController:notesController, index:index,));},
                           child: Container(
                             margin: EdgeInsets.symmetric(vertical:6),
                             padding: const EdgeInsets.all(12),
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
                                          Text(note.title, style: GoogleFonts.poppins(fontSize:16, fontWeight:FontWeight.w600)),
                                          SizedBox(height:height*0.01,),
                                          Text(
                                              '${note.timeStamp.day}-${note.timeStamp.month}-${note.timeStamp.year}',
                                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueGrey[400]),
                                           ),
                                        ],
                                      ),
                                    ),
                                    
                                 ]  
                              ),
                           ),
                         );
                      }
                   );}),
                ),
      
            ],
          )),

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
