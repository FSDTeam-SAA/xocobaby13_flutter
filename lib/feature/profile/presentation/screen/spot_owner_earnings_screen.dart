import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_style.dart';

class SpotOwnerEarningsScreen extends StatelessWidget {
  const SpotOwnerEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_EarningItem> items = List<_EarningItem>.generate(
      7,
      (_) => const _EarningItem(name: 'Fisherman', amount: 24),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SpotOwnerGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: SpotOwnerProfilePalette.darkText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Earnings',
                      style: TextStyle(
                        color: SpotOwnerProfilePalette.darkText,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF7FE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: SpotOwnerProfilePalette.blue,
                      width: 1.4,
                    ),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x1A0F172A),
                        blurRadius: 16,
                        offset: Offset(0, 10),
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
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '\$128.7k',
                            style: TextStyle(
                              color: SpotOwnerProfilePalette.darkText,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: const <Widget>[
                          Text(
                            '+ 36%',
                            style: TextStyle(
                              color: SpotOwnerProfilePalette.successGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_upward,
                            size: 18,
                            color: SpotOwnerProfilePalette.successGreen,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Earnings history',
                  style: TextStyle(
                    color: SpotOwnerProfilePalette.darkText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (BuildContext context, int index) {
                      return _EarningsRow(item: items[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
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
    return Row(
      children: <Widget>[
        const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/onboarding/avatar_mr_raja.jpg'),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            item.name,
            style: const TextStyle(
              color: SpotOwnerProfilePalette.darkText,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '\$${item.amount}',
          style: const TextStyle(
            color: SpotOwnerProfilePalette.successGreen,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
