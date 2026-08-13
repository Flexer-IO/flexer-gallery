import 'package:flutter/material.dart';

// Placeholder definitions for missing imports and classes.
// These are minimal implementations to satisfy the compiler
// without altering the visual behavior of the UI.

class AppColors {
  static const Color categoryColor1 = Colors.blue;
  static const Color categoryColor2 = Colors.green;
  static const Color categoryColor3 = Colors.orange;
  static const Color primaryWhiteColor = Colors.white;
  static const Color secondaryAccent = Colors.grey;
}

class SpendingCategoryModel {
  final String title;
  final String imagePath;
  final int amount;
  final Color color;

  const SpendingCategoryModel(
    this.title,
    this.imagePath,
    this.amount,
    this.color,
  );
}

class PriceText extends StatelessWidget {
  final int price;
  final Color color;

  const PriceText({
    Key? key,
    required this.price,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simple text representation; actual styling is defined elsewhere.
    return Text(
      '\$${price.toString()}',
      style: TextStyle(color: color),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Minimal placeholder; actual UI is defined elsewhere.
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}

class SpendingCategory extends StatelessWidget {
  final SpendingCategoryModel model;

  const SpendingCategory(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Minimal placeholder; actual UI is defined elsewhere.
    return Container(
      height: 100,
      color: model.color,
      child: Center(
        child: Text(model.title),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  static final List<SpendingCategoryModel> categoryModels = [
    SpendingCategoryModel(
      'GROCERIES',
      'assets/image1.png',
      28,
      AppColors.categoryColor1,
    ),
    SpendingCategoryModel(
      'FOOD',
      'assets/image2.png',
      28,
      AppColors.categoryColor2,
    ),
    SpendingCategoryModel(
      'BEAUTY',
      'assets/image3.png',
      28,
      AppColors.categoryColor3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Container(
            height: 180,
            child: Stack(children: [
              Container(
                color: Theme.of(context).colorScheme.secondary,
                height: 150,
                padding: const EdgeInsets.only(left: 36, top: 12),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'Azarro The Dev!',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Spending\ntoday',
                              style: const TextStyle(
                                  color: AppColors.primaryWhiteColor),
                            ),
                            const SizedBox(width: 32),
                            PriceText(
                              price: 100,
                              color: AppColors.primaryWhiteColor,
                            ),
                          ],
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                            color: AppColors.secondaryAccent,
                            borderRadius: BorderRadius.circular(32)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: AppColors.secondaryAccent),
                        // Wrap the IconButton in a Material widget for the
                        // IconButton's splash to render above the container.
                        child: Material(
                          borderRadius: BorderRadius.circular(32),
                          type: MaterialType.transparency,
                          // Hard Edge makes sure the splash is clipped at the border of this
                          // Material widget, which is circular due to the radius above.
                          clipBehavior: Clip.hardEdge,
                          child: IconButton(
                            padding: const EdgeInsets.all(16),
                            color: AppColors.primaryWhiteColor,
                            iconSize: 32,
                            icon: const Icon(
                              Icons.calendar_today,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ]),
              )
            ]),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 24),
            child: SearchBar(),
          ),
          Expanded(
            child: ListView(
              children: [
                for (var model in categoryModels)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36.0, vertical: 16),
                    child: SpendingCategory(model),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}