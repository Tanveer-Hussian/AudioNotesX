import 'package:audio_notes_x/Views/NotePages/NotesHomePage.dart';
import 'package:audio_notes_x/Views/TaskPages/TasksHomePage.dart';
import 'package:get/get.dart';


class NavController extends GetxController{
   
    RxInt index = 0.obs;
  
    final pages = [
       NotesHomePage(),
       TasksHomePage(),
    ]; 

}
