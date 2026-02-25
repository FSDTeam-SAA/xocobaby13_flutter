import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_style.dart';

class SpotOwnerBankAccountSuccessScreen extends StatelessWidget {
  const SpotOwnerBankAccountSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpotOwnerGradientBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 82,
                  height: 82,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCECFB),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: SpotOwnerProfilePalette.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Added Successfully',
                  style: TextStyle(
                    color: SpotOwnerProfilePalette.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your account has been added\nsuccessfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SpotOwnerProfilePalette.mutedText,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
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
