import 'package:flutter/material.dart';
import 'xball_view.dart';

class Al4fun3dballPage extends StatelessWidget {
  const Al4fun3dballPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: XBallView(
        mediaQueryData: MediaQuery.of(context),
        keywords: const [
          "北京",
          "天津",
          "上海",
          "重庆",
          "河北",
          "山西",
          "辽宁",
          "吉林",
          "黑龙江",
          "江苏",
          "浙江",
          "安徽",
          "福建",
          "江西",
          "山东",
          "河南",
          "湖北",
          "湖南",
          "广东",
          "海南",
          "四川",
          "贵州",
          "云南",
          "陕西",
          "甘肃",
          "青海",
          "台湾",
          "内蒙古",
          "广西",
          "西藏",
          "宁夏",
          "新疆",
          "香港",
          "澳门",
        ],
        highlight: const [
          "四川",
        ],
      ),
    );
  }
}