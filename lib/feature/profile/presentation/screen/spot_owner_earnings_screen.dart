import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_style.dart';

class SpotOwnerEarningsScreen extends StatelessWidget {
  const SpotOwnerEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_EarningItem> items = List<_EarningItem>.generate(
      6,
      (_) => const _EarningItem(name: 'Fisherman', amount: 24),
    );

    return SpotOwnerFlowScaffold(
      title: 'Earnings',
      showBack: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: SpotOwnerProfilePalette.cardBorder),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Total Earnings',
                        style: TextStyle(
                          color: SpotOwnerProfilePalette.mutedText,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$128.7k',
                        style: TextStyle(
                          color: SpotOwnerProfilePalette.darkText,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: const <Widget>[
                      Icon(
                        Icons.trending_up,
                        size: 12,
                        color: SpotOwnerProfilePalette.successGreen,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '+36 %',
                        style: TextStyle(
                          color: SpotOwnerProfilePalette.successGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Earnings history',
              style: TextStyle(
                color: SpotOwnerProfilePalette.darkText,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ...items.map((item) => _EarningsRow(item: item)),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _EarningItem {
  final String name;
  final int amount;

  const _EarningItem({required this.name, required this.amount});
}

class _EarningsRow extends StatelessWidget {
  final _EarningItem item;

  const _EarningsRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            radius: 11,
            backgroundImage: AssetImage('assets/onboarding/avatar_mr_raja.jpg'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(
                color: SpotOwnerProfilePalette.darkText,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '\$${item.amount}',
            style: const TextStyle(
              color: SpotOwnerProfilePalette.successGreen,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
