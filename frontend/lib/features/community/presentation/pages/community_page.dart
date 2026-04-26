import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmcom/core/presentation/widgets/section_header_with_status.dart';
import 'community_chat_page.dart';

class CommunityPage extends ConsumerWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Community Forums',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.groups, color: const Color(0xFF2E7D32), size: 28),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ),
            leading: null,
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _ForumTile(
                  title: 'Coffee Farmers Uganda',
                  members: '1.2k',
                  lastPost: 'Best fertilizers for Robusta?',
                  color: Colors.brown.shade400,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CommunityChatPage(
                          communityName: 'Coffee Farmers Uganda',
                          communityId: 'coffee_ug',
                          members: '1.2k',
                        ),
                      ),
                    );
                  },
                ),
                _ForumTile(
                  title: 'Maize Growers',
                  members: '850',
                  lastPost: 'Armyworm outbreak in Gulu',
                  color: Colors.yellow.shade800,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CommunityChatPage(
                          communityName: 'Maize Growers',
                          communityId: 'maize_ug',
                          members: '850',
                        ),
                      ),
                    );
                  },
                ),
                _ForumTile(
                  title: 'Poultry Network',
                  members: '2.1k',
                  lastPost: 'Vaccination schedule for layers',
                  color: Colors.orange.shade600,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CommunityChatPage(
                          communityName: 'Poultry Network',
                          communityId: 'poultry_ug',
                          members: '420',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ForumTile extends StatelessWidget {
  final String title;
  final String members;
  final String lastPost;
  final Color color;
  final VoidCallback onTap;

  const _ForumTile({
    required this.title,
    required this.members,
    required this.lastPost,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.forum, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    '$members members • Active now',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Latest: $lastPost',
                    style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
