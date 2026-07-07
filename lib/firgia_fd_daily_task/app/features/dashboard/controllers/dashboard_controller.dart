import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

// Placeholder model definitions to satisfy compilation.
// In the original project these would be imported from their respective files.

class ImageRasterPath {
  static const String man = 'assets/images/man.png';
}

class UserProfileData {
  const UserProfileData({
    required this.image,
    required this.name,
    required this.jobDesk,
  });

  final ImageProvider image;
  final String name;
  final String jobDesk;
}

class TaskProgressData {
  const TaskProgressData({
    required this.totalTask,
    required this.totalCompleted,
  });

  final int totalTask;
  final int totalCompleted;
}

class CardTaskData {
  const CardTaskData({
    required this.label,
    required this.jobDesk,
    required this.dueDate,
  });

  final String label;
  final String jobDesk;
  final DateTime dueDate;
}

class ListTaskAssignedData {
  const ListTaskAssignedData({
    required this.icon,
    required this.label,
    required this.jobDesk,
    this.assignTo,
    this.editDate,
  });

  final Icon icon;
  final String label;
  final String jobDesk;
  final String? assignTo;
  final DateTime? editDate;
}

class ListTaskDateData {
  const ListTaskDateData({
    required this.date,
    required this.label,
    required this.jobdesk,
  });

  final DateTime date;
  final String label;
  final String jobdesk;
}

class SelectionButtonData {
  const SelectionButtonData();
}

class DashboardController extends GetxController {
  final GlobalKey<ScaffoldState> scafoldKey = GlobalKey<ScaffoldState>();

  final UserProfileData dataProfil = const UserProfileData(
    image: AssetImage(ImageRasterPath.man),
    name: "Firgia",
    jobDesk: "Project Manager",
  );

  final List<String> member = ["Avril Kimberly", "Michael Greg"];

  final TaskProgressData dataTask = const TaskProgressData(totalTask: 5, totalCompleted: 1);

  final List<CardTaskData> taskInProgress = [
    CardTaskData(
      label: "Determine meeting schedule",
      jobDesk: "System Analyst",
      dueDate: DateTime.now().add(const Duration(minutes: 50)),
    ),
    CardTaskData(
      label: "Personal branding",
      jobDesk: "Marketing",
      dueDate: DateTime.now().add(const Duration(hours: 4)),
    ),
    CardTaskData(
      label: "UI UX",
      jobDesk: "Design",
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
    CardTaskData(
      label: "Determine meeting schedule",
      jobDesk: "System Analyst",
      dueDate: DateTime.now().add(const Duration(minutes: 50)),
    )
  ];

  final List<ListTaskAssignedData> weeklyTask = [
    ListTaskAssignedData(
      icon: const Icon(EvaIcons.monitor, color: Colors.blueGrey),
      label: "Slicing UI",
      jobDesk: "Programmer",
      assignTo: "Alex Ferguso",
      editDate: DateTime.now().add(-const Duration(hours: 2)),
    ),
    ListTaskAssignedData(
      icon: const Icon(EvaIcons.star, color: Colors.amber),
      label: "Personal branding",
      jobDesk: "Marketing",
      assignTo: "Justin Beck",
      editDate: DateTime.now().add(-const Duration(days: 50)),
    ),
    const ListTaskAssignedData(
      icon: Icon(EvaIcons.colorPalette, color: Colors.blue),
      label: "UI UX ",
      jobDesk: "Design",
    ),
    const ListTaskAssignedData(
      icon: Icon(EvaIcons.pieChart, color: Colors.redAccent),
      label: "Determine meeting schedule ",
      jobDesk: "System Analyst",
    ),
  ];

  final List<List<ListTaskDateData>> taskGroup = [
    [
      ListTaskDateData(
        date: DateTime.now().add(const Duration(days: 2, hours: 10)),
        label: "5 posts on instagram",
        jobdesk: "Marketing",
      ),
      ListTaskDateData(
        date: DateTime.now().add(const Duration(days: 2, hours: 11)),
        label: "Platform Concept",
        jobdesk: "Animation",
      ),
    ],
    [
      ListTaskDateData(
        date: DateTime.now().add(const Duration(days: 4, hours: 5)),
        label: "UI UX Marketplace",
        jobdesk: "Design",
      ),
      ListTaskDateData(
        date: DateTime.now().add(const Duration(days: 4, hours: 6)),
        label: "Create Post For App",
        jobdesk: "Marketing",
      ),
    ],
    [
      ListTaskDateData(
        date: DateTime.now().add(const Duration(days: 6, hours: 5)),
        label: "2 Posts on Facebook",
        jobdesk: "Marketing",
      ),
      ListTaskDateData(
        date: DateTime.now().add(const Duration(days: 6, hours: 6)),
        label: "Create Icon App",
        jobdesk: "Design",
      ),
      ListTaskDateData(
        date: DateTime.now().add(const Duration(days: 6, hours: 8)),
        label: "Fixing Error Payment",
        jobdesk: "Programmer",
      ),
      ListTaskDateData(
        date: DateTime.now().add(const Duration(days: 6, hours: 10)),
        label: "Create Form Interview",
        jobdesk: "System Analyst",
      ),
    ]
  ];

  void onPressedProfil() {}

  void onSelectedMainMenu(int index, SelectionButtonData value) {}
  void onSelectedTaskMenu(int index, String label) {}

  void searchTask(String value) {}

  void onPressedTask(int index, ListTaskAssignedData data) {}
  void onPressedAssignTask(int index, ListTaskAssignedData data) {}
  void onPressedMemberTask(int index, ListTaskAssignedData data) {}
  void onPressedCalendar() {}
  void onPressedTaskGroup(int index, ListTaskDateData data) {}

  void openDrawer() {
    if (scafoldKey.currentState != null) {
      scafoldKey.currentState!.openDrawer();
    }
  }
}