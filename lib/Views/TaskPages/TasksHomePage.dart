import 'package:audio_notes_x/Controllers/TasksControllers/ToDoController.dart';
import 'package:audio_notes_x/Data/TasksModels/ToDoBox.dart';
import 'package:audio_notes_x/Data/TasksModels/ToDoModel.dart';
import 'package:audio_notes_x/Service/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';


class TasksHomePage extends StatelessWidget {

   final toDoController = Get.find<ToDoController>();
   final dueDateController = TextEditingController();
   final titleController = TextEditingController();
   final descriptionController = TextEditingController();

  TasksHomePage({super.key});

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    dueDateController.clear();
    toDoController.selectedDate.value = null;
  }

  void setEditValues(ToDoModel toDosModel) {
    titleController.text = toDosModel.title.toString();
    descriptionController.text = toDosModel.description;

    final d = toDosModel.dueDate;
    if (d != null) {
      dueDateController.text = DateFormat('dd-MM-yyyy HH:mm').format(d);
      toDoController.selectedDate.value = d;
    }
  }

  String formatDateTimeForField(DateTime dt) {
    return DateFormat('dd-MM-yyyy HH:mm').format(dt);
  }


  @override
  Widget build(BuildContext context) {

     final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
   //  final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      appBar: AppBar(
        title: Row(
          children: [
            Container(
               width: 32,
               height: 32,
               decoration: BoxDecoration(
                 color:Colors.white.withOpacity(0.2),
                 borderRadius: BorderRadius.circular(8)
               ),
               child: Icon(Icons.task_alt_rounded, size:21, color:Colors.white)
             ),
            SizedBox(width:20),
            Text(
              'Task Flow',
              style: GoogleFonts.poppins(color: Colors.white, fontSize:22, fontWeight: FontWeight.w700),
            ),
          ],
         ),
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Icon(Icons.filter_list_rounded, color:Colors.white,),
          SizedBox(width:12),
          Icon(Icons.insights_rounded, color:Colors.white,),
          SizedBox(width:13),
        ],
      ),

      body: Obx((){

          var data = toDoController.toDos.reversed.toList();
          data = data.reversed.toList();

          final pendingTasks = data.where((task)=> !task.isCompleted).toList();
          final completedTasks = data.where((task)=> task.isCompleted).toList();

          final pendingCount = pendingTasks.length;
          final completedCount = completedTasks.length;

          final totalTasks = pendingCount+completedCount;
          final completionRate = totalTasks > 0 ? (completedCount/totalTasks*100).round() : 0; 

          pendingTasks.sort((a,b){
             if(a.dueDate==null && b.dueDate==null) return 0;
             if(a.dueDate==null) return 1;
             if(b.dueDate==null) return -1;
             return a.dueDate!.compareTo(b.dueDate!);
          });

          if(data.isEmpty){
            return _emptyState(context);
          }


          return Column(
            children: [

              _statsHeader(context, totalTasks, pendingCount, completionRate),

              Expanded(
                child: ListView(
                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                 // shrinkWrap: true,
                   children: [

                      if(pendingTasks.isNotEmpty) ...[
                        _sectionHeader('Pending Tasks ($pendingCount)', context),
                        ...pendingTasks.map((task)=> taskCard(task, context, width)),
                      ],

                   ]  

                 ),
               ),  

             ],
           );
     
        },
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom:52),
        child: FloatingActionButton(
          onPressed: () {
            clearFields();
            _showAddDialog(context);
          },
          shape: CircleBorder(),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          child: Icon(Icons.add_rounded, size:28),
        ),
      ),
  
    );
  }

  Container _statsHeader(BuildContext context, int totalTasks, int pendingCount, int completionRate) {
    return Container(
               margin: const EdgeInsets.all(15),
               padding: const EdgeInsets.all(10),
               decoration: BoxDecoration(
                 color: Theme.of(context).colorScheme.surface,
                 borderRadius: BorderRadius.circular(16),
                 border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3)),
                 boxShadow: [
                   BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0,4),
                    ),
                 ]
                ),
               child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                    _statsItem(
                        context, 
                        value: totalTasks.toString(),
                        label: 'Total Tasks',
                        icon: Icons.task_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    _statsItem(
                        context,
                        value: pendingCount.toString(),
                        label: 'Pending',
                        icon: Icons.pending_actions_rounded,
                        color: Colors.orange,
                      ),
                    _statsItem(
                        context,
                        value: '$completionRate%',
                        label: 'Completed',
                        icon: Icons.check_circle_rounded,
                        color: Colors.green,
                      ),
                 ],
               ), 
             );
  }

  
  Widget _emptyState(BuildContext context){
    return Center(
      child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [

           Container(
              width:100, height:100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle
              ),
              child: Icon(Icons.task_alt_rounded, size:60, color:Theme.of(context).hintColor.withOpacity(0.5),),
            ),
           SizedBox(height:24),
           Text(
              'No tasks yet',
              style: GoogleFonts.poppins(fontSize:22, fontWeight:FontWeight.w600, color: Theme.of(context).colorScheme.onBackground,),
            ),
           SizedBox(height:8),
           Text(
              'Tap the + button to add your first task', 
              textAlign:TextAlign.center,
              style: GoogleFonts.poppins(fontSize:14, color: Theme.of(context).hintColor,),
            ),
           SizedBox(height:32),
           ElevatedButton.icon(
              onPressed: (){_showAddDialog(context);},
              icon: Icon(Icons.add_rounded, size:22,), 
              label: Text('Create First Task'),
              style: ElevatedButton.styleFrom(
                 backgroundColor: Theme.of(context).colorScheme.primary,
                 foregroundColor: Colors.white,
                 padding: const EdgeInsets.symmetric(horizontal:24, vertical:14),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
               ),
             ),
            SizedBox(height:60), 

        ],
      ),
    );
  }


  Widget _statsItem(BuildContext context, {required String value, required String label, required IconData icon, required Color color}){
     return Column(
       children: [
          
          Container(
             width: 48,
             height: 48,
             decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
             child: Icon(icon, size:24, color:color,),
           ),
          SizedBox(height:8),
          Text(value, style:GoogleFonts.poppins(fontSize:16, color:Theme.of(context).colorScheme.onBackground),),
          Text(label, style:GoogleFonts.poppins(fontSize:12, color:Theme.of(context).hintColor),),

       ],
     );
  }


  Widget _sectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget taskCard(ToDoModel task, BuildContext context, double width) {
       final priorityColor = _getPriorityColor(task, context);
      final isOverdue = task.dueDate != null && 
                     !task.isCompleted && 
                     task.dueDate!.isBefore(DateTime.now());

      return Container(
          margin: const EdgeInsets.only(bottom:7),
          child: Slidable(
            key: ValueKey(task.key),
            endActionPane: ActionPane(
              motion: DrawerMotion(), 
              children: [

                SlidableAction(
                   icon: Icons.edit,
                   onPressed: (context) {
                      setEditValues(task);
                      _editDialog(task, toDoController, context);
                    },
                   backgroundColor: Theme.of(context).colorScheme.primary,
                   foregroundColor: Colors.white,
                   label: 'Edit',
                 ),

                SlidableAction(
                  icon: Icons.delete_rounded,
                  onPressed: (context) async {
                    final key = task.key;
                    toDoController.delete(task);
                    // cancel scheduled notification for deleted task
                    if (key is int) {
                      await NotificationService.cancelNotification(key);
                    }
                   },
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                  label: 'Delete',
                )
               
                ]
              ),


            child: Container(
              decoration: BoxDecoration(
                 color: Theme.of(context).colorScheme.surface,
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3)),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.black.withOpacity(0.05),
                     blurRadius: 4,
                     offset: Offset(0, 2),
                   ),
                ],
               ),
       
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                       width: 4,
                       height: 60,
                       decoration: BoxDecoration(
                         color: priorityColor,
                         borderRadius: BorderRadius.circular(2),
                       ),
                     ),
                    SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: GoogleFonts.poppins(fontSize:17, fontWeight:FontWeight.w600, color:Theme.of(context).colorScheme.onSurface),
                                  maxLines:2, overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width:12),

                              Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (bool? value) async{
                                    task.isCompleted = value!;
                                    await task.save();

                                    if (value && task.dueDate != null) {
                                      // Cancel notification when task is completed
                                      await NotificationService.cancelNotification(task.key);
                                    } else if (!value && task.dueDate != null) {
                                      // Reschedule notification if task is uncompleted
                                      await NotificationService.scheduleNotification(
                                        task.key,
                                        task.title,
                                        task.description,
                                        task.dueDate!,
                                      );
                                    }
                                  },
                                  shape: CircleBorder(),
                                  side: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                    width: 1.5
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height:8),
                          if (task.description.isNotEmpty)
                            Text(
                              task.description,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                                decoration: task.isCompleted 
                                    ? TextDecoration.lineThrough 
                                    : TextDecoration.none,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                          SizedBox(height: 12),
                          
                        Row(
                         children: [
                          if (task.dueDate != null) ...[
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: isOverdue ? Colors.red : priorityColor,
                            ),
                            SizedBox(width: 6),
                            Text(
                              formatDateTimeForDisplay(task.dueDate!),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isOverdue ? Colors.red : priorityColor,
                              ),
                            ),
                            SizedBox(width: 12),
                          ],

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _statusText(task),
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: priorityColor,
                              ),
                            ),
                          ),

                        ],
                       ),


                        ]
                      ),                 
                    ),

                  ]    
                ),
              ),
       
            ),
  
          ),
        );  
   }

  String _statusText(ToDoModel task) {
    if (task.isCompleted) return 'COMPLETED';
    
    if (task.dueDate == null) return 'NO DUE DATE';
    
    final now = DateTime.now();
    if (task.dueDate!.isBefore(now)) return 'OVERDUE';
    
    final hoursUntilDue = task.dueDate!.difference(now).inHours;
    if (hoursUntilDue < 24) return 'DUE TODAY';
    if (hoursUntilDue < 72) return 'DUE SOON';
    
    return 'UPCOMING';
  } 

   Color _getPriorityColor(ToDoModel task, BuildContext context) {
      final now = DateTime.now();
      if (task.dueDate == null) return Theme.of(context).colorScheme.primary;
      
      final hoursUntilDue = task.dueDate!.difference(now).inHours;
      
      if (task.isCompleted) {
        return Colors.green;
      } else if (hoursUntilDue < 0) {
        return Colors.red; // Overdue
      } else if (hoursUntilDue < 24) {
        return Colors.orange; // Due today
      } else if (hoursUntilDue < 72) {
        return Colors.blue; // Due in 3 days
      } else {
        return Theme.of(context).colorScheme.primary;
      }  
   }  
   
   String formatDateTimeForDisplay(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDay = DateTime(dt.year, dt.month, dt.day);
    
    if (taskDay.isAtSameMomentAs(today)) {
      return 'Today at ${DateFormat('hh:mm a').format(dt)}';
    } else if (taskDay.isAtSameMomentAs(today.add(Duration(days: 1)))) {
      return 'Tomorrow at ${DateFormat('hh:mm a').format(dt)}';
    } else {
      return DateFormat('MMM dd, yyyy • hh:mm a').format(dt);
    }
  }


  Future<void> _showAddDialog(BuildContext context) async {
    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Task',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 11),

              // Due date + time field
              TextFormField(
                controller: dueDateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Pick due date & time',
                  border: const OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Date Picker
                      IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed: () async {
                          final today = DateTime.now();
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: today,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050),
                          );

                          if (pickedDate != null) {
                            final existing = toDoController.selectedDate.value;
                            final hour = existing?.hour ?? today.hour;
                            final minute = existing?.minute ?? today.minute;

                            final combined = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              hour,
                              minute,
                            );

                            toDoController.selectedDate.value = combined;
                            dueDateController.text =
                                formatDateTimeForField(combined);
                          }
                        },
                      ),

                      // Time Picker
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () async {
                          final now = TimeOfDay.now();
                          final pickedTime = await showTimePicker(
                              context: context, initialTime: now);

                          if (pickedTime != null) {
                            final existing =
                                toDoController.selectedDate.value ??
                                    DateTime.now();

                            final combined = DateTime(
                              existing.year,
                              existing.month,
                              existing.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );

                            toDoController.selectedDate.value = combined;
                            dueDateController.text =
                                formatDateTimeForField(combined);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Title
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Add Title',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),

              // Description
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Add Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),

              const SizedBox(height: 17),

              // Add Task Button
              Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[500],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async {
                    // Validate inputs
                    if (titleController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        toDoController.selectedDate.value == null) {
                      Get.back();
                      Get.snackbar('Could not add task',
                          'Kindly enter required fields (including date & time)');
                      return;
                    }

                    final scheduled = toDoController.selectedDate.value!;
                    if (!scheduled.isAfter(DateTime.now())) {
                      Get.back();
                      Get.snackbar('Invalid time',
                          'Please choose a future date & time for reminder');
                      return;
                    }

                    // Build Task model
                    final task = ToDoModel(
                      title: titleController.text,
                      description: descriptionController.text,
                      dueDate: scheduled,
                      isCompleted: false,
                      userId: toDoController.userId!,
                    );

                    // Save using controller
                    toDoController.addTask(task);

                    // If added through controller, get latest task’s key
                    final box = Hive.box<ToDoModel>('toDos');
                    final key = box.keys.last as int;

                    // Schedule notification
                    await NotificationService.scheduleNotification(
                      key,
                      task.title,
                      task.description,
                      task.dueDate!,
                    );

                    clearFields();
                    Get.back();
                  },
                  child: Text(
                    'Add',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future _editDialog(ToDoModel todosModel, ToDoController toDoController, BuildContext context) async {
   
    // Pre-fill fields before opening dialog
    titleController.text = todosModel.title;
    descriptionController.text = todosModel.description;

    // Pre-fill selected date
    toDoController.selectedDate.value = todosModel.dueDate;
    dueDateController.text = todosModel.dueDate != null
        ? DateFormat('dd-MM-yyyy HH:mm').format(todosModel.dueDate!)
        : '';

    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text( 'Edit Task', style: GoogleFonts.poppins(fontSize:18, fontWeight:FontWeight.bold)),
              const SizedBox(height: 12),

              // PICK DATE/TIME
              TextFormField(
                controller: dueDateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Pick due date & time',
                  border: const OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // DATE PICKER
                      IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed: () async {
                          final now = DateTime.now();
                          final initial = toDoController.selectedDate.value ?? now;

                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: initial,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050),
                          );

                          if (pickedDate != null) {
                            final hour = initial.hour;
                            final minute = initial.minute;

                            final combined = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              hour,
                              minute,
                            );

                            toDoController.selectedDate.value = combined;
                            dueDateController.text =
                                DateFormat('dd-MM-yyyy HH:mm').format(combined);
                          }
                        },
                      ),

                      // TIME PICKER
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () async {
                          final initial =
                              toDoController.selectedDate.value ?? DateTime.now();

                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                                hour: initial.hour, minute: initial.minute),
                          );

                          if (pickedTime != null) {
                            final combined = DateTime(
                              initial.year,
                              initial.month,
                              initial.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );

                            toDoController.selectedDate.value = combined;
                            dueDateController.text =
                                DateFormat('dd-MM-yyyy HH:mm').format(combined);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // TITLE FIELD
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  hintText: 'Enter Title',
                ),
              ),

              const SizedBox(height: 8),

              // DESCRIPTION FIELD
              TextFormField(
                controller: descriptionController,
                maxLines: 6,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  hintText: 'Enter Text',
                ),
              ),

              const SizedBox(height: 20),

              // SAVE BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text("Save"),
                onPressed: () async {
                  // Validation
                  if (titleController.text.trim().isEmpty ||
                      descriptionController.text.trim().isEmpty) {
                    Get.snackbar(
                      "Invalid Input",
                      "Both Title & Text are required",
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  // Update fields
                  todosModel.title = titleController.text.trim();
                  todosModel.description = descriptionController.text.trim();
                  todosModel.dueDate = toDoController.selectedDate.value;

                  // Validate future date
                  if (todosModel.dueDate != null &&
                      !todosModel.dueDate!.isAfter(DateTime.now())) {
                    Get.back();
                    Get.snackbar('Invalid time',
                        'Please choose a future date & time for reminder');
                    return;
                  }

                  // Save to Hive
                  await todosModel.save();

                  // Notification handling
                  if (todosModel.dueDate != null) {
                    await NotificationService.scheduleNotification(
                      todosModel.key,
                      todosModel.title,
                      todosModel.description,
                      todosModel.dueDate!,
                    );
                  } else {
                    await NotificationService.cancelNotification(
                        todosModel.key);
                  }

                  clearFields();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }        


 }
