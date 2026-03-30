import 'package:flutter/material.dart';
import 'package:google_adds/UI/Theme/apptheme.dart';
import 'package:shimmer/shimmer.dart';


class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.divider,
      highlightColor: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerBox(height: 40, width: 200),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.55,
              children: List.generate(4, (_) => _shimmerCard()),
            ),
            const SizedBox(height: 16),
            _shimmerCard(height: 200),
            const SizedBox(height: 16),
            _shimmerCard(height: 120),
            const SizedBox(height: 16),
            _shimmerBox(height: 20, width: 120),
            const SizedBox(height: 8),
            _shimmerCard(height: 220),
          ],
        ),
      ),
    );
  }

  Widget _shimmerCard({double height = 110}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.kBorderRadius),
      ),
    );
  }

  Widget _shimmerBox({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}