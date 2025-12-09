import 'package:audio_notes_x/Data/NotesModels/NotesModel.dart';
import 'package:get/get.dart';

class SearchingController extends GetxController{
   
   RxList<NotesModel> filteredNotesList = <NotesModel>[].obs;

   List<NotesModel> get filteredNotes => filteredNotesList;

 }
