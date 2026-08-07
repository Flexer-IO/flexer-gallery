// Copyright 2018 The Chromium Authors. All rights reserved.
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.

 import 'dart:collection';
 import 'dart:convert';
 import 'dart:html';

 import 'package:flutter/widgets.dart';
 import 'constants.dart';
 import 'data/contribution_data.dart';
 import 'data/stat_for_week.dart';
 import 'data/user_contribution.dart';
 import 'data/week_label.dart' as data_week;
 // Import LayeredChart without hiding WeekLabel; use an alias to avoid name clash.
 import 'layered_chart.dart' as lc;
 import 'mathutils.dart';
 import 'timeline.dart';

 class MainLayout extends StatefulWidget {
   @override
   _MainLayoutState createState() => _MainLayoutState();
 }

 class _MainLayoutState extends State<MainLayout>
     with TickerProviderStateMixin {
   late AnimationController _animation;
   List<UserContribution>? contributions;
   List<StatForWeek>? starsByWeek;
   List<StatForWeek>? forksByWeek;
   List<StatForWeek>? pushesByWeek;
   List<StatForWeek>? issueCommentsByWeek;
   List<StatForWeek>? pullRequestActivityByWeek;
   late List<data_week.WeekLabel> weekLabels;

   static const double earlyInterpolatorFraction = 0.8;
   static final EarlyInterpolator interpolator =
       EarlyInterpolator(earlyInterpolatorFraction);
   double animationValue = 1.0;
   double interpolatedAnimationValue = 1.0;
   bool timelineOverride = false;

   @override
   void initState() {
     super.initState();

     createAnimation(0);

     // Build a temporary list using the data model WeekLabel.
     final List<data_week.WeekLabel> tempWeekLabels = [];
     tempWeekLabels.add(data_week.WeekLabel.forDate(DateTime(2019, 2, 26), "v1.2"));
     tempWeekLabels.add(data_week.WeekLabel.forDate(DateTime(2018, 12, 4), "v1.0"));
     // tempWeekLabels.add(data_week.WeekLabel.forDate(DateTime(2018, 9, 19), "Preview 2"));
     tempWeekLabels.add(data_week.WeekLabel.forDate(DateTime(2018, 6, 21), "Preview 1"));
     // tempWeekLabels.add(data_week.WeekLabel.forDate(DateTime(2018, 5, 7), "Beta 3"));
     tempWeekLabels.add(data_week.WeekLabel.forDate(DateTime(2018, 2, 27), "Beta 1"));
     tempWeekLabels.add(data_week.WeekLabel.forDate(DateTime(2017, 5, 1), "Alpha"));
     tempWeekLabels.add(data_week.WeekLabel(48, "Repo Made Public"));

     // Store the WeekLabel list for Timeline (uses data_week.WeekLabel).
     weekLabels = tempWeekLabels;

     loadGitHubData();
   }

   void createAnimation(double startValue) {
     _animation = AnimationController(
       value: startValue,
       duration: const Duration(milliseconds: 14400),
       vsync: this,
     )..repeat();
     _animation.addListener(() {
       setState(() {
         if (!timelineOverride) {
           animationValue = _animation.value;
           interpolatedAnimationValue = interpolator.get(animationValue);
         }
       });
     });
   }

   @override
   Widget build(BuildContext context) {
     // Combined contributions data
     List<lc.DataSeries> dataToPlot = [];
     if (contributions != null) {
       List<int> series = [];
       for (UserContribution userContrib in contributions!) {
         for (int i = 0; i < userContrib.contributions.length; i++) {
           ContributionData data = userContrib.contributions[i];
           if (series.length > i) {
             series[i] = series[i] + data.add;
           } else {
             series.add(data.add);
           }
         }
       }
       dataToPlot.add(lc.DataSeries(label: "Added Lines", series: series));
     }

     if (starsByWeek != null) {
       dataToPlot.add(lc.DataSeries(
           label: "Stars",
           series: starsByWeek!.map((e) => e.stat).toList()));
     }

     if (forksByWeek != null) {
       dataToPlot.add(lc.DataSeries(
           label: "Forks",
           series: forksByWeek!.map((e) => e.stat).toList()));
     }

     if (pushesByWeek != null) {
       dataToPlot.add(lc.DataSeries(
           label: "Pushes",
           series: pushesByWeek!.map((e) => e.stat).toList()));
     }

     if (issueCommentsByWeek != null) {
       dataToPlot.add(lc.DataSeries(
           label: "Issue Comments",
           series: issueCommentsByWeek!.map((e) => e.stat).toList()));
     }

     if (pullRequestActivityByWeek != null) {
       dataToPlot.add(lc.DataSeries(
           label: "Pull Request Activity",
           series: pullRequestActivityByWeek!.map((e) => e.stat).toList()));
     }

     // Convert weekLabels to the type expected by LayeredChart.
     final List<lc.WeekLabel> chartWeekLabels = weekLabels
         .map((dw) => lc.WeekLabel(weekNum: dw.weekNum, label: dw.label))
         .toList();

     lc.LayeredChart layeredChart =
         lc.LayeredChart(dataToPlot, chartWeekLabels, interpolatedAnimationValue);

     const double timelinePadding = 60.0;

     var timeline = Timeline(
       numWeeks: dataToPlot.isNotEmpty ? dataToPlot.last.series.length : 0,
       animationValue: interpolatedAnimationValue,
       weekLabels: weekLabels,
       mouseDownCallback: (double xFraction) {
         setState(() {
           timelineOverride = true;
           _animation.stop();
           interpolatedAnimationValue = xFraction;
         });
       },
       mouseMoveCallback: (double xFraction) {
         setState(() {
           interpolatedAnimationValue = xFraction;
         });
       },
       mouseUpCallback: () {
         setState(() {
           timelineOverride = false;
           createAnimation(interpolatedAnimationValue * earlyInterpolatorFraction);
         });
       },
     );

     Column mainColumn = Column(
       mainAxisAlignment: MainAxisAlignment.center,
       mainAxisSize: MainAxisSize.max,
       children: <Widget>[
         Expanded(child: layeredChart),
         Padding(
           padding: const EdgeInsets.only(
               left: timelinePadding,
               right: timelinePadding,
               bottom: timelinePadding),
           child: timeline,
         ),
       ],
     );

     return Container(
       color: Constants.backgroundColor,
       child: Directionality(
           textDirection: TextDirection.ltr, child: mainColumn),
     );
   }

   @override
   void dispose() {
     _animation.dispose();
     super.dispose();
   }

   Future<void> loadGitHubData() async {
     String contributorsJsonStr =
         await HttpRequest.getString("/github_data/contributors.json");
     List<dynamic> jsonObjs = jsonDecode(contributorsJsonStr) as List<dynamic>;
     List<UserContribution> contributionList = jsonObjs
         .map((e) => UserContribution.fromJson(e))
         .toList()
         .cast<UserContribution>();
     print(
         "Loaded ${contributionList.length} code contributions to /flutter/flutter repo.");

     int numWeeksTotal = contributionList[0].contributions.length;

     String starsByWeekStr = await HttpRequest.getString("/github_data/stars.tsv");
     List<StatForWeek> starsByWeekLoaded =
         summarizeWeeksFromTSV(starsByWeekStr, numWeeksTotal);

     String forksByWeekStr = await HttpRequest.getString("/github_data/forks.tsv");
     List<StatForWeek> forksByWeekLoaded =
         summarizeWeeksFromTSV(forksByWeekStr, numWeeksTotal);

     String commitsByWeekStr =
         await HttpRequest.getString("/github_data/commits.tsv");
     List<StatForWeek> commitsByWeekLoaded =
         summarizeWeeksFromTSV(commitsByWeekStr, numWeeksTotal);

     String commentsByWeekStr =
         await HttpRequest.getString("/github_data/comments.tsv");
     List<StatForWeek> commentsByWeekLoaded =
         summarizeWeeksFromTSV(commentsByWeekStr, numWeeksTotal);

     String pullRequestActivityByWeekStr =
         await HttpRequest.getString("/github_data/pull_requests.tsv");
     List<StatForWeek> pullRequestActivityByWeekLoaded =
         summarizeWeeksFromTSV(pullRequestActivityByWeekStr, numWeeksTotal);

     setState(() {
       contributions = contributionList;
       starsByWeek = starsByWeekLoaded;
       forksByWeek = forksByWeekLoaded;
       pushesByWeek = commitsByWeekLoaded;
       issueCommentsByWeek = commentsByWeekLoaded;
       pullRequestActivityByWeek = pullRequestActivityByWeekLoaded;
     });
   }

   List<StatForWeek> summarizeWeeksFromTSV(
       String statByWeekStr, int numWeeksTotal) {
     List<StatForWeek> loadedStats = [];
     HashMap<int, StatForWeek> statMap = HashMap();
     statByWeekStr.split("\n").forEach((s) {
       List<String> split = s.split("\t");
       if (split.length == 2) {
         int weekNum = int.parse(split[0]);
         statMap[weekNum] = StatForWeek(weekNum, int.parse(split[1]));
       }
     });
     print("Laoded ${statMap.length} weeks.");
     // Convert into a list by week, but fill in empty weeks with 0
     for (int i = 0; i < numWeeksTotal; i++) {
       StatForWeek? starsForWeek = statMap[i];
       if (starsForWeek == null) {
         loadedStats.add(StatForWeek(i, 0));
       } else {
         loadedStats.add(starsForWeek);
       }
     }
     return loadedStats;
   }
 }

 void main() {
   runApp(Center(child: MainLayout()));
 }