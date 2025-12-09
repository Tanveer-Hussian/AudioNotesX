import 'package:audio_notes_x/Controllers/NotesControllers/NotesController.dart';
import 'package:audio_notes_x/Controllers/NotesControllers/TtsController.dart';
import 'package:audio_notes_x/Controllers/TasksControllers/ToDoController.dart';
import 'package:audio_notes_x/Data/NotesModels/NotesModel.dart';
import 'package:audio_notes_x/Data/TasksModels/ToDoModel.dart';
import 'package:audio_notes_x/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';


final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async{

   WidgetsFlutterBinding.ensureInitialized();

   var directory = await getApplicationDocumentsDirectory();
   Hive.init(directory.path);

   Hive.registerAdapter(NotesModelAdapter());
   await Hive.openBox<NotesModel>('notes');
   Hive.registerAdapter(ToDoModelAdapter());
   await Hive.openBox<ToDoModel>('toDos');

   tz.initializeTimeZones();

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);

  await notificationsPlugin.initialize(initSettings);

  // ---- REQUEST NOTIFICATION PERMISSION ----
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // ---- REQUEST EXACT ALARM PERMISSION ---
   if (Platform.isAndroid) {
     final androidPlugin = notificationsPlugin.resolvePlatformSpecificImplementation<
         AndroidFlutterLocalNotificationsPlugin>();

     if (Platform.isAndroid) {
       await Permission.scheduleExactAlarm.request();
     }
   }


   Get.put(ToDoController());
   Get.put(NotesController());
   Get.put(TtsController());

  runApp(MyApp());

}


class MyApp extends StatelessWidget {
   MyApp({super.key});
  
  @override
  Widget build(BuildContext context){
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      title: "Audio Notes X",
      home: SplashScreen(),
    );
  }
}
