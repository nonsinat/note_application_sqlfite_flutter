// ignore_for_file: unnecessary_overrides, avoid_print

import 'package:get/get.dart';
import 'package:note2_applicatoin_flutter/databases/db_helper.dart';
import 'package:note2_applicatoin_flutter/models/task_model.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <TaskModel>[].obs;

  Future<int> addTask({TaskModel? task}) async {
    return await DBHelper.insert(task);
  }

  // Get All the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(
      tasks.map((data) => TaskModel.fromJson(data)).toList(),
    );
  }

  // Deleting data from table
  void deleteTask(TaskModel task) async {
    var val = await DBHelper.delete(task);
    getTasks();
    print("Count deleted : $val");
  }

  // Updating data from table
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
