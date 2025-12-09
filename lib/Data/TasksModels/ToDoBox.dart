import 'package:audio_notes_x/Data/TasksModels/ToDoModel.dart';
import 'package:hive/hive.dart';

class ToDoBoxe {
   static Box<ToDoModel> getData() => Hive.box<ToDoModel>('toDos');
 }
 