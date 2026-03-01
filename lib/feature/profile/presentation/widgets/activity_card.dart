import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/home/presentation/routes/home_routes.dart';
import 'package:xocobaby13/feature/profile/model/activity_item_model.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_style.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';

class ActivityCard extends StatelessWidget {
  final ActivityItemModel item;
  final bool useDetailsRoute;

  const ActivityCard({
    super.key,
    required this.item,
    this.useDetailsRoute = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double imageWidth = (constraints.maxWidth * 0.34).clamp(
                96.0,
                132.0,
              );
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _CardImage(
                      path: item.imagePath,
                      width: imageWidth,
                      height: 158,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF1D2A36),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _MetaText(
                          icon: CupertinoIcons.time,
                          text: item.timeRange,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: _MetaText(
                                icon: CupertinoIcons.location,
                                text: item.location,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _MetaText(
                                icon: CupertinoIcons.calendar,
                                text: item.dateLabel,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: Color(0xFFFFD77A),
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.ownerName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF1D2A36),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: <Widget>[
                                      const Icon(
                                        CupertinoIcons.star_fill,
                                        size: 14,
                                        color: Color(0xFFF4B400),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          '${item.rating} (${item.reviewsCount} Reviews)',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color(0xFF1D2A36),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 94,
                                      maxWidth: 112,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE9F4FF),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            text: '\$${item.pricePerDay}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF1787CF),
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '/day',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF1D2A36),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: AppOutlinedButton(
              onPressed: () {
                if (useDetailsRoute) {
                  final query = <String, String>{};
                  if (item.spotId != null && item.spotId!.isNotEmpty) {
                    query['id'] = item.spotId!;
                  }
                  final detailsUri = Uri(
                    path: HomeRouteNames.details,
                    queryParameters: query.isEmpty ? null : query,
                  );
                  context.push(detailsUri.toString());
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Viewing details for ${item.title}')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: ProfilePalette.blue,
                side: const BorderSide(color: ProfilePalette.blue, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 16, color: const Color(0xFF1D2A36)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF1D2A36), fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _CardImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;

  const _CardImage({
    required this.path,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _imageFallback(width, height),
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _imageFallback(width, height),
    );
  }

  Widget _imageFallback(double w, double h) {
    return Container(
      width: w,
      height: h,
      color: const Color(0xFFDDEAF7),
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.photo, color: Color(0xFF6B7280)),
    );
  }
}
