import 'package:hive/hive.dart';
part 'ToDoModel.g.dart';

@HiveType(typeId:1)
class ToDoModel extends HiveObject{

   @HiveField(0)
   String title;

   @HiveField(1)
   String description; 
 
   @HiveField(2)
   DateTime? dueDate;

   @HiveField(3)
   bool isCompleted;

   @HiveField(4)
   String userId;

   ToDoModel({
      required this.title, required this.description, 
      required this.dueDate, required this.isCompleted,
      required this.userId,
    });

 }
