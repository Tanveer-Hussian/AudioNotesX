import 'package:audio_notes_x/Data/NotesModels/NotesModel.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesController extends GetxController{

    late Box<NotesModel> box;
    late SharedPreferences prefs;
    String? userId;

    @override  
    void onInit(){
       super.onInit();
       initialze();
     }
    
    Future<void> initialze() async{
       prefs = await SharedPreferences.getInstance();
       userId = prefs.getString('userId');

       box = Hive.box<NotesModel>('notes');
       update();
     }

    List<NotesModel> get notes {
       if (userId == null) return [];
       return box.values.where((note) => note.userId == userId).toList();
     }

    void addNote(String text, String title, DateTime timeStamp) async{
       if (userId == null) return;
       await box.add(NotesModel(text: text, title: title, timeStamp: timeStamp, userId: userId!));
       update();
     }

    void deleteNote(int index) async{
       final myNotes = notes;
       final noteToDelete = myNotes[index];
       await noteToDelete.delete();
     }

    void editNote(dynamic key, String title, String text, DateTime timeStamp) async{
       if (userId == null) return;
       await box.put(key, NotesModel(text: text, title: title, timeStamp: timeStamp, userId: userId!));
       update();
     }
    
 }

