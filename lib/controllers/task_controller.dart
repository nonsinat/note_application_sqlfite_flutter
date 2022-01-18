// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:note2_applicatoin_flutter/databases/db_helper.dart';
import 'package:note2_applicatoin_flutter/models/task_model.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  Future<int> addTask({TaskModel? task}) async {
    return await DBHelper.insert(task);
  }
}
