import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/feature/auth/interface/auth_interface.dart';
import 'package:xocobaby13/feature/auth/model/logout_request_model.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_style.dart';

class SpotOwnerLogoutScreen extends StatefulWidget {
  const SpotOwnerLogoutScreen({super.key});

  @override
  State<SpotOwnerLogoutScreen> createState() => _SpotOwnerLogoutScreenState();
}

class _SpotOwnerLogoutScreenState extends State<SpotOwnerLogoutScreen> {
  bool _isLoading = false;

  Future<void> _handleLogout() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final snackbarNotifier = SnackbarNotifier(context: context);
    final authRecord = await Get.find<AuthorizedPigeon>()
        .getCurrentAuthRecord();
    final refreshToken =
        authRecord?.toJson()['refresh_token']?.toString() ?? '';

    final result = await Get.find<AuthInterface>().logout(
      param: LogoutRequestModel(refreshToken: refreshToken),
    );

    result.fold((failure) {
      snackbarNotifier.notifyError(message: failure.uiMessage);
      context.go(AuthRouteNames.login);
    }, (_) => context.go(AuthRouteNames.login));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Are you sure you want to Log out',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: SpotOwnerProfilePalette.darkText,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tap log out to Log out from this app.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: SpotOwnerProfilePalette.mutedText,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8EAEE),
                        foregroundColor: SpotOwnerProfilePalette.darkText,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SpotOwnerProfilePalette.dangerRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.6,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.logout, size: 14),
                      label: Text(
                        _isLoading ? 'Logging out...' : 'Log out',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
