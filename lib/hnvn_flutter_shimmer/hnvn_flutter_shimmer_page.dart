import 'package:flutter/material.dart';
import 'package:hnvn_flutter_shimmer/shimmer.dart' as shimmer;

class HnvnFlutterShimmerPage extends StatefulWidget {
  const HnvnFlutterShimmerPage({super.key});

  @override
  State<HnvnFlutterShimmerPage> createState() => _HnvnFlutterShimmerPageState();
}

class _HnvnFlutterShimmerPageState extends State<HnvnFlutterShimmerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shimmer.Shimmer(
        child: Container(
          width: double.infinity,
          height: 100,
          color: Colors.grey,
        ),
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade100,
            Colors.grey.shade300,
          ],
          stops: [
            0.0,
            0.5,
            1.0,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.mirror,
        ),
      ),
    );
  }
}