import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';

class ShimmerLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoader({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                _controller.value - 0.5,
                _controller.value,
                _controller.value + 0.5,
              ],
              colors: [
                AppColors.grey200,
                AppColors.grey100,
                AppColors.grey200,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// Pre-built skeleton loaders
class CardSkeleton extends StatelessWidget {
  final bool isLoading;
  final double height;

  const CardSkeleton({
    super.key,
    this.isLoading = true,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ShimmerLoader(
      isLoading: isLoading,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceVariant : AppColors.grey200,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class ListSkeleton extends StatelessWidget {
  final bool isLoading;
  final int itemCount;

  const ListSkeleton({
    super.key,
    this.isLoading = true,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CardSkeleton(isLoading: isLoading),
      ),
    );
  }
}

class TextSkeleton extends StatelessWidget {
  final bool isLoading;
  final double width;
  final double height;

  const TextSkeleton({
    super.key,
    this.isLoading = true,
    this.width = double.infinity,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ShimmerLoader(
      isLoading: isLoading,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceVariant : AppColors.grey200,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class GridSkeleton extends StatelessWidget {
  final bool isLoading;
  final int itemCount;
  final int crossAxisCount;

  const GridSkeleton({
    super.key,
    this.isLoading = true,
    this.itemCount = 6,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => CardSkeleton(isLoading: isLoading),
    );
  }
}

class ProfileHeaderSkeleton extends StatelessWidget {
  final bool isLoading;

  const ProfileHeaderSkeleton({super.key, this.isLoading = true});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ShimmerLoader(
      isLoading: isLoading,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceVariant : AppColors.grey200,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 12),
            // Name
            Container(
              width: 150,
              height: 20,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceVariant : AppColors.grey200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            // Bio
            Container(
              width: 200,
              height: 16,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceVariant : AppColors.grey200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
