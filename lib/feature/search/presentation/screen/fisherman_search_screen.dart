import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FishermanSearchScreen extends StatefulWidget {
  const FishermanSearchScreen({super.key});

  @override
  State<FishermanSearchScreen> createState() => _FishermanSearchScreenState();
}

class _FishermanSearchScreenState extends State<FishermanSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _areas = <String>[
    'Kansas City',
    'St. Louis',
    'Dallas',
    'New Orleans',
  ];

  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _removeArea(String area) {
    setState(() {
      _areas.remove(area);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> visibleAreas = _areas
        .where(
          (String area) =>
              _query.isEmpty ||
              area.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFD7E7F7), Color(0xFFE2E8F1)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              children: <Widget>[
                _SearchBar(
                  controller: _controller,
                  hintText: 'Search for areas',
                  onChanged: (String value) {
                    setState(() => _query = value.trim());
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: visibleAreas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (BuildContext context, int index) {
                      final String area = visibleAreas[index];
                      return _SearchResultRow(
                        title: area,
                        onRemove: () => _removeArea(area),
                      );
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

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1A0F172A),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            CupertinoIcons.search,
            color: Color(0xFF1E7CC8),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF1E7CC8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        style: const TextStyle(color: Color(0xFF1D2A36), fontSize: 14),
      ),
    );
  }
}

class _SearchResultRow extends StatelessWidget {
  final String title;
  final VoidCallback onRemove;

  const _SearchResultRow({required this.title, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2A36),
            ),
          ),
        ),
        GestureDetector(
          onTap: onRemove,
          child: const Icon(
            CupertinoIcons.xmark,
            size: 16,
            color: Color(0xFF1D2A36),
          ),
        ),
      ],
    );
  }
}
