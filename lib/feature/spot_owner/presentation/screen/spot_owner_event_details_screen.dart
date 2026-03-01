import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/home/presentation/screen/home_details_screen.dart';

class SpotOwnerEventDetailsScreen extends StatelessWidget {
  final String? spotId;

  const SpotOwnerEventDetailsScreen({super.key, this.spotId});

  @override
  Widget build(BuildContext context) {
    return HomeDetailsScreen(showBookingButton: false, spotId: spotId);
  }
}
