import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ui_class/models/task_data_model.dart';
import 'package:flutter_ui_class/utils/contant.dart';

class TaskManagementRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<bool> addTask(TaskDataModel taskModel) async {
    try {
      await firestore.collection(AppConstant.taskCollection).add(taskModel.toJson());
      return true;
    } catch (e) {
      print('Error adding task: $e');
      return false;
    }
  }
  Future<List<TaskDataModel>> getTasks() async {
    try {
      final snapshot =
          await firestore.collection(AppConstant.taskCollection).get();

      return snapshot.docs
          .map((doc) => TaskDataModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("Error fetching tasks: $e");
      return [];
    }
  }

  Future<bool> updateTask(String id, TaskDataModel task) async {
    try {
      await firestore
          .collection(AppConstant.taskCollection)
          .doc(id)
          .update(task.toJson());

      return true;
    } catch (e) {
      print("Error updating task: $e");
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      await firestore
          .collection(AppConstant.taskCollection)
          .doc(id)
          .delete();

      return true;
    } catch (e) {
      print("Error deleting task: $e");
      return false;
    }
  }
}