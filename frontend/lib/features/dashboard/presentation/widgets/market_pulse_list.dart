part of '../pages/dashboard_page.dart';

class MarketPulseList extends ConsumerWidget {
  const MarketPulseList({super.key}) : super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For MVP: Static data
    final prices = [
      {'crop': 'Coffee (Robusta)', 'price': '8,500', 'unit': 'kg', 'trend': 'up'},
      {'crop': 'Maize', 'price': '1,200', 'unit': 'kg', 'trend': 'stable'},
      {'crop': 'Vanilla', 'price': '50,000', 'unit': 'kg', 'trend': 'down'},
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = prices[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['crop']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Text(
                        'Last Updated: Today 08:00 AM',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'UGX ${item['price']}',
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'per ${item['unit']}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                _TrendIcon(trend: item['trend']!),
              ],
            ),
          );
        },
        childCount: prices.length,
      ),
    );
  }
}

class _TrendIcon extends StatelessWidget {
  final String trend;
  const _TrendIcon({required this.trend});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    
    switch (trend) {
      case 'up':
        icon = Icons.trending_up;
        color = Colors.green;
        break;
      case 'down':
        icon = Icons.trending_down;
        color = Colors.red;
        break;
      default:
        icon = Icons.trending_flat;
        color = Colors.orange;
    }
    
    return Icon(icon, color: color, size: 24);
  }
}
