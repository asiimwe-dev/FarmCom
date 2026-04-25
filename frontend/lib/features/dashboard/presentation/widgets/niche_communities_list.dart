part of '../pages/dashboard_page.dart';

class NicheCommunitiesList extends ConsumerWidget {
  const NicheCommunitiesList({super.key}) : super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For MVP: Static list or fetch from Isar
    // In a real implementation, we'd watch an Isar provider here
    final communities = [
      {'name': 'Coffee', 'posts': 5, 'color': Colors.brown.shade400},
      {'name': 'Maize', 'posts': 0, 'color': Colors.yellow.shade700},
      {'name': 'Poultry', 'posts': 12, 'color': Colors.orange.shade400},
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: communities.length,
      itemBuilder: (context, index) {
        final crop = communities[index];
        return _CommunityCard(
          name: crop['name'] as String,
          newPosts: crop['posts'] as int,
          color: crop['color'] as Color,
        );
      },
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final String name;
  final int newPosts;
  final Color color;

  const _CommunityCard({
    required this.name,
    required this.newPosts,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (newPosts > 0)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  newPosts.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
