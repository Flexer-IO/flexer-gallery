import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/spending_category_model.dart';
import 'custom_icon_button.dart';
import 'price_text.dart';

class SpendingCategory extends StatelessWidget {
  final SpendingCategoryModel data;

  const SpendingCategory(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Stack(
        children: [
          Container(
            height: 100,
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.white
                    : AppColors.darkModeCardColor,
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 32, color: Colors.black45, spreadRadius: -8)
                ],
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(data.image, width: 64),
                PriceText(price: data.price),
                Row(children: [
                  CustomIconButton(icon: Icons.file_upload),
                  const SizedBox(width: 8),
                  CustomIconButton(icon: Icons.folder)
                ])
              ],
            ),
          ),
          Container(
            width: 132,
            height: 24,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(36),
            ),
            child: Text(
              data.label,
              style: TextStyle(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.white
                      : AppColors.darkModeCategoryColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}