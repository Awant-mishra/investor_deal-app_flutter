import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DealSkeleton extends StatelessWidget {
  const DealSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.all(12),
        child: Container(
          height: 100,
        ),
      ),
    );
  }
}