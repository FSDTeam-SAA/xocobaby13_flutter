import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/feature/profile/controller/profile_controller.dart';
import 'package:xocobaby13/feature/profile/model/activity_item_model.dart';
import 'package:xocobaby13/feature/profile/model/activity_status_model.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/activity_card.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_style.dart';

class ActivityScreen extends StatelessWidget {
  final String title;
  final bool showBack;
  final bool embedded;
  final bool useDetailsRoute;

  const ActivityScreen({
    super.key,
    this.title = 'My Activity',
    this.showBack = true,
    this.embedded = false,
    this.useDetailsRoute = false,
  });

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = ProfileController.instance();

    final Widget content = Obx(() {
      final List<ActivityItemModel> visibleItems =
          controller.filteredActivityItems;

      final Widget tabs = Row(
        children: ActivityStatusModel.values.map((ActivityStatusModel status) {
          final bool selected =
              controller.selectedActivityStatus.value == status;
          return Expanded(
            child: _BookingTab(
              label: status.label,
              isSelected: selected,
              onTap: () => controller.setActivityStatus(status),
            ),
          );
        }).toList(),
      );

      final List<Widget> cards = visibleItems
          .map(
            (ActivityItemModel item) => ActivityCard(
              item: item,
              useDetailsRoute: useDetailsRoute,
            ),
          )
          .toList();

      if (embedded) {
        final List<Widget> cardWidgets = <Widget>[];
        for (final Widget card in cards) {
          cardWidgets.add(card);
          cardWidgets.add(const SizedBox(height: 18));
        }
        if (cardWidgets.isNotEmpty) {
          cardWidgets.removeLast();
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              tabs,
              const SizedBox(height: 18),
              ...cardWidgets,
            ],
          ),
        );
      }

      return Column(
        children: <Widget>[
          const SizedBox(height: 6),
          tabs,
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: visibleItems.length,
              separatorBuilder: (_, int index) => const SizedBox(height: 16),
              itemBuilder: (BuildContext context, int index) {
                return ActivityCard(
                  item: visibleItems[index],
                  useDetailsRoute: useDetailsRoute,
                );
              },
            ),
          ),
        ],
      );
    });

    if (embedded) {
      return SafeArea(bottom: false, child: content);
    }

    return ProfileFlowScaffold(
      title: title,
      showBack: showBack,
      child: content,
    );
  }
}

class _BookingTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BookingTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF1D2A36),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: 6,
            decoration: BoxDecoration(
              color: isSelected ? ProfilePalette.blue : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x331787CF),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
