// ignore_for_file: prefer_const_constructors, avoid_print, prefer_final_fields, avoid_web_libraries_in_flutter, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note2_applicatoin_flutter/controllers/task_controller.dart';
import 'package:note2_applicatoin_flutter/models/task_model.dart';
import 'package:note2_applicatoin_flutter/ui/theme.dart';
import 'package:note2_applicatoin_flutter/ui/widgets/input_field.dart';
import 'package:note2_applicatoin_flutter/ui/widgets/t_button.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.put(TaskController());

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  DateTime _selectedData = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm:a").format(
    DateTime.now(),
  );

  int _selectedRemind = 5;
  List<int> remindlist = [
    5,
    10,
    15,
    20,
  ];

  String _selectedRepeat = "None";
  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',
  ];

  int _seletedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              InputField(
                title: "Title",
                hint: "Enter your title",
                controller: titleController,
              ),
              InputField(
                title: "Note",
                hint: "Enter your note",
                controller: noteController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedData),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Date",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: Icon(Icons.access_time_outlined),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      title: "End Date",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(Icons.access_time_outlined),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Remind",
                hint: _selectedRemind.toString() + " minutes early",
                widget: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 23,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRemind = int.parse(value!);
                    });
                  },
                  style: subTitleStyle,
                  items: remindlist.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem(
                      value: value.toString(),
                      child: Text(
                        value.toString(),
                      ),
                    );
                  }).toList(),
                ),
              ),
              InputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 23,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRepeat = value!;
                    });
                  },
                  style: subTitleStyle,
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                      value: value.toString(),
                      child: Text(
                        value.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  TButton(
                    label: "Create Task",
                    onTap: () {
                      _validateData();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        Wrap(
          children: List.generate(
            3,
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _seletedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    top: 10,
                  ),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : yellowClr,
                    child: _seletedColor == index
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : SizedBox(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _validateData() {
    if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (titleController.text.isEmpty || noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        icon: Icon(Icons.warning_amber_rounded),
        colorText: Colors.red,
      );
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: TaskModel(
        title: titleController.text.toString(),
        note: noteController.text.toString(),
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedData),
        startTime: _startTime,
        endTime: _endTime,
        color: _seletedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
    print("My id is $value");
  }

  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.chevron_left,
          size: 32,
          color: Get.isDarkMode ? Colors.white : primaryClr,
        ),
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2130),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedData = _pickerDate;
        print(_selectedData);
      });
    } else {
      print("it's null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(pickedTime);
    if (pickedTime == null) {
      print("Time Canceld");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() async {
    var _pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(
          _startTime.split(":")[0],
        ),
        minute: int.parse(
          _startTime.split(":")[1].split(" ")[0],
        ),
      ),
    );
  }
}
