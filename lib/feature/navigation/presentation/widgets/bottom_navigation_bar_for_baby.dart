import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarForBaby extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavigationBarForBaby({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  static const List<_BottomNavItem> _items = <_BottomNavItem>[
    _BottomNavItem(label: 'Home', icon: CupertinoIcons.home),
    _BottomNavItem(label: 'Bookings', icon: CupertinoIcons.calendar),
    _BottomNavItem(label: 'Chat', icon: CupertinoIcons.chat_bubble),
    _BottomNavItem(label: 'Profile', icon: CupertinoIcons.person_crop_circle),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
        child: Container(
          height: 70,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x1A0F172A),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
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
                      vertical: 10,
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF1787CF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          item.icon,
                          size: 22,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF131619),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : const Color(0xFF131619),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
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
