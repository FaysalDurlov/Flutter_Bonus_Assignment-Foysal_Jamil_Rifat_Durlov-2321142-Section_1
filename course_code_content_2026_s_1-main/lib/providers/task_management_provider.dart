import 'package:flutter/material.dart';
import '../repository/task_management_repo.dart';
import 'package:flutter_ui_class/models/task_data_model.dart';

class TaskManagementProvider with ChangeNotifier{
  List<TaskDataModel> firebaseTasks = [];

  final TaskManagementRepo repo = TaskManagementRepo();

  Future<void> loadTasksFromFirebase() async {
    firebaseTasks = await repo.getTasks();
    notifyListeners();
  }
  
  Future<bool> addTaskToFirebase(TaskDataModel task) async {
    bool result = await repo.addTask(task);
    return result;
  }

  Future<bool> updateTask(TaskDataModel task) async {
  bool result = await repo.updateTask(task.id, task);
  await loadTasksFromFirebase();
  return result;
  }

  Future<bool> deleteTask(String id) async {
  bool result = await repo.deleteTask(id);
  await loadTasksFromFirebase();
  return result;
  }

}