import 'package:audio_notes_x/Data/NotesModels/NotesModel.dart';
import 'package:hive/hive.dart';

class Boxes {
   static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
 }
