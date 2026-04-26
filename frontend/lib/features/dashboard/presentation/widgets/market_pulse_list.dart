part of '../pages/dashboard_page.dart';

class MarketPulseList extends ConsumerWidget {
  const MarketPulseList({super.key}) : super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For MVP: Static data with buy and sell prices
    final prices = [
      {
        'crop': 'Coffee (Robusta)',
        'buyPrice': '8,200',
        'sellPrice': '8,500',
        'unit': 'kg',
        'trend': 'up'
      },
      {
        'crop': 'Maize',
        'buyPrice': '1,100',
        'sellPrice': '1,200',
        'unit': 'kg',
        'trend': 'stable'
      },
      {
        'crop': 'Vanilla',
        'buyPrice': '48,000',
        'sellPrice': '50,000',
        'unit': 'kg',
        'trend': 'down'
      },
      {
        'crop': 'Beans',
        'buyPrice': '2,800',
        'sellPrice': '3,100',
        'unit': 'kg',
        'trend': 'up'
      },
      {
        'crop': 'Banana',
        'buyPrice': '600',
        'sellPrice': '800',
        'unit': 'bunch',
        'trend': 'stable'
      },
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = prices[index];
          return _MarketPriceLine(item: item);
        },
        childCount: prices.length,
      ),
    );
  }
}

class _MarketPriceLine extends StatelessWidget {
  final Map<String, String> item;

  const _MarketPriceLine({required this.item});

  @override
  Widget build(BuildContext context) {
    final trend = item['trend']!;
    final isUp = trend == 'up';
    final isDown = trend == 'down';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['crop']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Updated: 08:00 AM',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'BUY',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade700,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  item['buyPrice']!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _TrendIcon(trend: trend),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'SELL',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.green.shade700,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  item['sellPrice']!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
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
        icon = Icons.arrow_upward;
        color = Colors.green;
        break;
      case 'down':
        icon = Icons.arrow_downward;
        color = Colors.red;
        break;
      default:
        icon = Icons.remove;
        color = Colors.orange;
    }

    return Icon(icon, color: color, size: 20);
  }
}
