import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarForSpotOwner extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavigationBarForSpotOwner({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  static const List<_BottomNavItem> _items = <_BottomNavItem>[
    _BottomNavItem(label: 'Home', icon: CupertinoIcons.home),
    _BottomNavItem(label: 'Events', icon: CupertinoIcons.calendar),
    _BottomNavItem(label: 'Chat', icon: CupertinoIcons.chat_bubble),
    _BottomNavItem(label: 'Profile', icon: CupertinoIcons.person_crop_circle),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: Container(
          height: 84,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(42),
          ),
          child: Row(
            children: List<Widget>.generate(_items.length, (int index) {
              final bool selected = index == selectedIndex;
              final _BottomNavItem item = _items[index];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onItemTapped(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF1787CF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(34),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          item.icon,
                          size: 24,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF131619),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : const Color(0xFF131619),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem {
  final String label;
  final IconData icon;

  const _BottomNavItem({required this.label, required this.icon});
}
