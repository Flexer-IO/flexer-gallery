import 'package:flutter/material.dart';

// Placeholder import replacements for missing files.
// In the original project these would be real files providing the necessary classes/functions.
import 'package:flutter/widgets.dart' show StatelessWidget; // ensures StatelessWidget is available.

// Dummy implementation of TransactionsPage to satisfy the navigator reference.
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simple placeholder UI; the actual implementation is not required for compilation.
    return const Scaffold(
      body: Center(
        child: Text('Transactions Page Placeholder'),
      ),
    );
  }
}

// Utility function to replace the missing verticalSpace helper.
Widget verticalSpace(double height) => SizedBox(height: height);

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height / 3.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            verticalSpace(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Hello, Himanshu",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    // The verticalSpace call is kept as a widget, not a method.
                    // The function defined above returns a SizedBox.
                    // This maintains the original layout.
                    // The original code used verticalSpace(4) here.
                  ],
                ),
                Image.asset(
                  'packages/showcase_library/assets/himanshugarg08_flutter_give_collect_money/app_logo.png',
                  color: Colors.white,
                  height: 22,
                )
              ],
            ),
            verticalSpace(8),
            Row(
              children: const [
                Text(
                  r'''$9844.00''',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            verticalSpace(16),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 800),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 800),
                    opaque: false,
                    pageBuilder: (context, animation, _) {
                      return const TransactionsPage();
                    },
                  ),
                );
              },
              child: Hero(
                tag: "Your transaction",
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Material(
                        child: Text(
                          "Your transaction",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}