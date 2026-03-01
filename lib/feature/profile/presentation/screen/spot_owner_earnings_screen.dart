import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_style.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';

class SpotOwnerEarningsScreen extends StatefulWidget {
  const SpotOwnerEarningsScreen({super.key});

  @override
  State<SpotOwnerEarningsScreen> createState() =>
      _SpotOwnerEarningsScreenState();
}

class _SpotOwnerEarningsScreenState extends State<SpotOwnerEarningsScreen> {
  late final Future<_EarningsData> _earningsFuture;

  @override
  void initState() {
    super.initState();
    _earningsFuture = _fetchEarnings();
  }

  Future<_EarningsData> _fetchEarnings() async {
    try {
      final response = await Get.find<AuthorizedPigeon>().get(
        ApiEndpoints.ownerEarnings,
      );
      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        return _EarningsData.fallback();
      }

      final responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final payload = responseBody['data'];
      final data = payload is Map
          ? Map<String, dynamic>.from(payload)
          : responseBody;

      String readString(dynamic value) => value?.toString().trim() ?? '';
      final String totalEarnings = readString(data['totalEarnings']);
      final String percentageChange = readString(data['percentageChange']);
      final List<_EarningItem> items = <_EarningItem>[];

      final history = data['earningsHistory'];
      if (history is List) {
        for (final entry in history) {
          if (entry is Map) {
            final map = Map<String, dynamic>.from(entry);
            final String title = readString(map['title']);
            final String amount = readString(map['amount']);
            items.add(
              _EarningItem(
                name: title.isNotEmpty ? title : 'Fisherman',
                amountLabel: amount.isNotEmpty ? amount : r'$0',
              ),
            );
          }
        }
      }

      return _EarningsData(
        totalEarnings: totalEarnings.isNotEmpty ? totalEarnings : r'$0.0k',
        percentageLabel: percentageChange.isNotEmpty
            ? percentageChange
            : '+ 36%',
        items: items.isNotEmpty ? items : _EarningsData.fallbackItems(),
      );
    } catch (_) {
      return _EarningsData.fallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_EarningsData>(
      future: _earningsFuture,
      builder: (BuildContext context, AsyncSnapshot<_EarningsData> snapshot) {
        final _EarningsData data = snapshot.data ?? _EarningsData.fallback();
        const Color deltaColor = SpotOwnerProfilePalette.successGreen;
        const IconData deltaIcon = Icons.arrow_upward;

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
                        AppIconButton(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
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
                            children: <Widget>[
                              const Text(
                                'Total Earnings',
                                style: TextStyle(
                                  color: SpotOwnerProfilePalette.mutedText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                data.totalEarnings,
                                style: const TextStyle(
                                  color: SpotOwnerProfilePalette.darkText,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: <Widget>[
                              Text(
                                data.percentageLabel,
                                style: TextStyle(
                                  color: deltaColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(deltaIcon, size: 18, color: deltaColor),
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
                        itemCount: data.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder: (BuildContext context, int index) {
                          return _EarningsRow(item: data.items[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EarningItem {
  final String name;
  final String amountLabel;

  const _EarningItem({required this.name, required this.amountLabel});
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
          item.amountLabel,
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

class _EarningsData {
  final String totalEarnings;
  final String percentageLabel;
  final List<_EarningItem> items;

  const _EarningsData({
    required this.totalEarnings,
    required this.percentageLabel,
    required this.items,
  });

  static List<_EarningItem> fallbackItems() {
    return List<_EarningItem>.generate(
      7,
      (_) => const _EarningItem(name: 'Fisherman', amountLabel: r'$24'),
    );
  }

  static _EarningsData fallback() {
    return _EarningsData(
      totalEarnings: r'$128.7k',
      percentageLabel: '+ 36%',
      items: fallbackItems(),
    );
  }
}
