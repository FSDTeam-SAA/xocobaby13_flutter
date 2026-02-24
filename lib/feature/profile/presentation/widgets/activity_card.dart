import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/profile/model/activity_item_model.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_style.dart';

class ActivityCard extends StatelessWidget {
  final ActivityItemModel item;

  const ActivityCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/activity.png',
                  width: 125,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Color(0xFF1F252F),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.dateLabel,
                          style: const TextStyle(
                            color: Color(0xFF1F252F),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage(
                            'assets/onboarding/avatar_mr_raja.jpg',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          item.reviewer,
                          style: const TextStyle(
                            color: Color(0xFF141414),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        ...List<Widget>.generate(
                          5,
                          (int index) => const Icon(
                            Icons.star,
                            size: 18,
                            color: Color(0xFFFFBE0B),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'You Rated ${item.rating}',
                          style: const TextStyle(
                            color: Color(0xFF1F252F),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Viewing details for ${item.title}')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: ProfilePalette.blue,
                side: const BorderSide(color: ProfilePalette.blue, width: 1.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
