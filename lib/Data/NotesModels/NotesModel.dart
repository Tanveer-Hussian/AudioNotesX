import 'package:hive/hive.dart';
part 'NotesModel.g.dart';

@HiveType(typeId:0)
class NotesModel extends HiveObject{

   @HiveField(0)
   String text; 

   @HiveField(1)
   String title;

   @HiveField(2)
   DateTime timeStamp;

   @HiveField(3)
   String userId;

   NotesModel({
      required this.text, required this.title, 
      required this.timeStamp, required this.userId
    });


}

