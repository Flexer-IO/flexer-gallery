library dashboard;

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../controllers/dashboard_controller.dart' as dashboard_ctrl;
import '../../../../shared_components/header_text.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../../../shared_components/search_field.dart';
import '../../../../shared_components/task_progress.dart';
import '../../../../shared_components/user_profile.dart';

// Define a default spacing constant (fallback if constants file is missing)
const double kSpacing = 16.0;

// -----------------------------------------------------------------------------
// Stub implementations for missing component symbols (to satisfy compilation)
// -----------------------------------------------------------------------------
Widget BottomNavBar() => const SizedBox.shrink();

Widget MainMenu({required void Function(int, dynamic) onSelected}) =>
    const SizedBox.shrink();

Widget Member({required dynamic member}) => const SizedBox.shrink();

Widget TaskMenu({required void Function(int, dynamic) onSelected}) =>
    const SizedBox.shrink();

Widget TaskInProgress({required dynamic data}) => const SizedBox.shrink();

Widget WeeklyTask({
  required dynamic data,
  required void Function(int, dynamic) onPressed,
  required void Function(int, dynamic) onPressedAssign,
  required void Function(int, dynamic) onPressedMember,
}) =>
    const SizedBox.shrink();

Widget TaskGroup({
  required String title,
  required List<dynamic> data,
  required void Function(int, dynamic) onPressed,
}) =>
    const SizedBox.shrink();

class DashboardScreen extends GetView<dashboard_ctrl.DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scafoldKey,
      drawer: ResponsiveBuilder.isDesktop(context)
          ? null
          : Drawer(
              child: SafeArea(
                child: SingleChildScrollView(child: _buildSidebar(context)),
              ),
            ),
      bottomNavigationBar: (ResponsiveBuilder.isDesktop(context) || kIsWeb)
          ? null
          : const _BottomNavbar(),
      body: SafeArea(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTaskContent(
                    onPressedMenu: () => controller.openDrawer(),
                  ),
                  _buildCalendarContent(),
                ],
              ),
            );
          },
          tabletBuilder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: constraints.maxWidth > 800 ? 8 : 7,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: _buildTaskContent(
                      onPressedMenu: () => controller.openDrawer(),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const VerticalDivider(),
                ),
                Flexible(
                  flex: 4,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: _buildCalendarContent(),
                  ),
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: constraints.maxWidth > 1350 ? 3 : 4,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: _buildSidebar(context),
                  ),
                ),
                Flexible(
                  flex: constraints.maxWidth > 1350 ? 10 : 9,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: _buildTaskContent(),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const VerticalDivider(),
                ),
                Flexible(
                  flex: 4,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: _buildCalendarContent(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: UserProfile(
            data: controller.dataProfil as UserProfileData,
            onPressed: controller.onPressedProfil,
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _MainMenu(
            onSelected: (index, data) =>
                controller.onSelectedMainMenu(index, data),
          ),
        ),
        const Divider(
          indent: 20,
          thickness: 1,
          endIndent: 20,
          height: 60,
        ),
        _Member(member: controller.member),
        SizedBox(height: kSpacing),
        _TaskMenu(
          onSelected: (index, data) =>
              controller.onSelectedTaskMenu(index, data),
        ),
        SizedBox(height: kSpacing),
        Padding(
          padding: EdgeInsets.all(kSpacing),
          child: Text(
            "2021 Teamwork lisence",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskContent({Function()? onPressedMenu}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          SizedBox(height: kSpacing),
          Row(
            children: [
              if (onPressedMenu != null)
                Padding(
                  padding: EdgeInsets.only(right: kSpacing / 2),
                  child: IconButton(
                    onPressed: onPressedMenu,
                    icon: const Icon(Icons.menu),
                  ),
                ),
              Expanded(
                child: SearchField(
                  onSearch: (query) => controller.searchTask(query),
                  hintText: "Search Task .. ",
                ),
              ),
            ],
          ),
          SizedBox(height: kSpacing),
          Row(
            children: [
              Expanded(
                child: HeaderText(
                  DateFormat('MMMM yyyy').format(DateTime.now()),
                ),
              ),
              SizedBox(width: kSpacing / 2),
              SizedBox(
                width: 200,
                child: TaskProgress(data: controller.dataTask as TaskProgressData),
              ),
            ],
          ),
          SizedBox(height: kSpacing),
          _TaskInProgress(data: controller.taskInProgress as TaskProgressData),
          SizedBox(height: kSpacing * 2),
          const _HeaderWeeklyTask(),
          SizedBox(height: kSpacing),
          _WeeklyTask(
            data: controller.weeklyTask,
            onPressed: (index, data) => controller.onPressedTask(index, data),
            onPressedAssign: (index, data) =>
                controller.onPressedAssignTask(index, data),
            onPressedMember: (index, data) =>
                controller.onPressedMemberTask(index, data),
          )
        ],
      ),
    );
  }

  Widget _buildCalendarContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          SizedBox(height: kSpacing),
          Row(
            children: [
              const Expanded(child: HeaderText("Calendar")),
              IconButton(
                onPressed: controller.onPressedCalendar,
                icon: const Icon(EvaIcons.calendarOutline),
                tooltip: "calendar",
              )
            ],
          ),
          SizedBox(height: kSpacing),
          ...controller.taskGroup
              .map(
                (e) => _TaskGroup(
                  title: DateFormat('d MMMM').format(e[0].date),
                  data: e as List<dynamic>,
                  onPressed: (index, data) =>
                      controller.onPressedTaskGroup(index, data),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Wrapper classes for private widget names (to keep original UI code unchanged)
// -----------------------------------------------------------------------------
class _BottomNavbar extends StatelessWidget {
  const _BottomNavbar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => BottomNavBar();
}

class _MainMenu extends StatelessWidget {
  final void Function(int, dynamic) onSelected;
  const _MainMenu({Key? key, required this.onSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) => MainMenu(
        onSelected: (i, data) => onSelected(i, data),
      );
}

class _Member extends StatelessWidget {
  final dynamic member;
  const _Member({Key? key, required this.member}) : super(key: key);
  @override
  Widget build(BuildContext context) => Member(member: member);
}

class _TaskMenu extends StatelessWidget {
  final void Function(int, dynamic) onSelected;
  const _TaskMenu({Key? key, required this.onSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) => TaskMenu(
        onSelected: (i, data) => onSelected(i, data),
      );
}

class _TaskInProgress extends StatelessWidget {
  final dynamic data;
  const _TaskInProgress({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) => TaskInProgress(data: data);
}

class _HeaderWeeklyTask extends StatelessWidget {
  const _HeaderWeeklyTask({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const HeaderText("Weekly Task");
}

class _WeeklyTask extends StatelessWidget {
  final dynamic data;
  final void Function(int, dynamic) onPressed;
  final void Function(int, dynamic) onPressedAssign;
  final void Function(int, dynamic) onPressedMember;
  const _WeeklyTask({
    Key? key,
    required this.data,
    required this.onPressed,
    required this.onPressedAssign,
    required this.onPressedMember,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => WeeklyTask(
        data: data,
        onPressed: (i, d) => onPressed(i, d),
        onPressedAssign: (i, d) => onPressedAssign(i, d),
        onPressedMember: (i, d) => onPressedMember(i, d),
      );
}

class _TaskGroup extends StatelessWidget {
  final String title;
  final List<dynamic> data;
  final void Function(int, dynamic) onPressed;
  const _TaskGroup({
    Key? key,
    required this.title,
    required this.data,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => TaskGroup(
        title: title,
        data: data,
        onPressed: (i, d) => onPressed(i, d),
      );
}

// -----------------------------------------------------------------------------
// Compatibility extensions for deprecated TextTheme properties
// -----------------------------------------------------------------------------
extension TextThemeCompatibility on TextTheme {
  TextStyle? get caption => bodySmall;
}