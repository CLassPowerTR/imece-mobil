import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DrawerShimmer extends StatelessWidget {
  const DrawerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
                Container(
                  width: 120,
                  height: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
