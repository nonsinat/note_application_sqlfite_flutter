// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print, avoid_unnecessary_containers
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:note2_applicatoin_flutter/controllers/task_controller.dart';
import 'package:note2_applicatoin_flutter/models/task_model.dart';
import 'package:note2_applicatoin_flutter/services/notification_services.dart';
import 'package:note2_applicatoin_flutter/services/theme_services.dart';
import 'package:note2_applicatoin_flutter/ui/add_task_screen.dart';
import 'package:note2_applicatoin_flutter/ui/theme.dart';
import 'package:note2_applicatoin_flutter/ui/widgets/t_button.dart';
import 'package:note2_applicatoin_flutter/ui/widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var notifyHelper;
  DateTime _seletedDate = DateTime.now();
  @override
  void initState() {
    //Important Point First We need to InitializationNotification and then Request Permission For IOS, Last one is Optional For Alert Again after 5 seconds

    // Display Notification after We change DarkMode in Leading Appbar
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    notifyHelper.scheduledNotification();
    _taskController.getTasks();
    super.initState();
  }

  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _taskController.taskList.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              TaskModel task = _taskController.taskList[index];
              print(task.toJson());
              if (task.repeat == 'Daily') {
                DateTime date =
                    DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.scheduledNotification(
                  int.parse(myTime.toString().split(":")[0]),
                  int.parse(myTime.toString().split(":")[1]),
                  task

                );

                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    curve: Curves.linear,
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(
                              task: _taskController.taskList[index],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (task.date == DateFormat.yMd().format(_seletedDate)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    curve: Curves.linear,
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(
                              task: _taskController.taskList[index],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    "Find Other Day to Complete your task",
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  // ignore: unused_element
  _bottomSheetButton(
      {String? label,
      Function()? onTap,
      Color? clr,
      bool isClose = false,
      BuildContext? context}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context!).size.width * .9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr!,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            "$label",
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, TaskModel task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * .34
            : MediaQuery.of(context).size.height * .42,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: "Task Completed",
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                    context: context,
                  ),
            _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);

                Get.back();
              },
              clr: Colors.red[300],
              context: context,
            ),
            SizedBox(height: 20),
            _bottomSheetButton(
              label: "Close",
              onTap: () {},
              clr: Colors.red[300],
              context: context,
              isClose: true,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _seletedDate = date;
            print(
              DateFormat.yMMMd().format(_seletedDate),
            );
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(
                  DateTime.now(),
                ),
                style: subHeadingStyle,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Today",
                style: headingStyle,
              ),
            ],
          ),
          TButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(
                () => AddTaskScreen(),
              );
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode
                ? "Activated Light Theme"
                : "Activated Dark Theme",
          );
        },
        icon: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.mode_night_outlined,
            size: 24,
            color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
      actions: [
        CircleAvatar(
          backgroundColor: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ],
    );
  }
}
