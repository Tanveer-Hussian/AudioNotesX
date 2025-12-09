import 'package:audio_notes_x/Data/TasksModels/ToDoModel.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoController extends GetxController {
  late Box<ToDoModel> box;
  late SharedPreferences prefs;
  String? userId;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxList<ToDoModel> toDos = <ToDoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    box = Hive.box<ToDoModel>('toDos');

    // Initialize toDos with current user's tasks
    _loadTasks();

    // Listen to Hive box changes
    box.listenable().addListener(_loadTasks);
  }

  void _loadTasks() {
    if (userId == null) {
      toDos.clear();
    } else {
      toDos.value = box.values.where((task) => task.userId == userId).toList();
    }
  }

  Future<void> addTask(ToDoModel task) async {
    if (userId == null) return;

    await box.add(
      ToDoModel(
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: task.isCompleted,
        userId: userId!,
      ),
    );
  }

  Future<void> delete(ToDoModel task) async {
    await task.delete();
  }

  Future<void> editTask(ToDoModel task, ToDoModel updated) async {
    if (userId == null) return;

    task.title = updated.title;
    task.description = updated.description;
    task.dueDate = updated.dueDate;
    task.isCompleted = updated.isCompleted;
    task.userId = userId!;

    await task.save();
  }
}

