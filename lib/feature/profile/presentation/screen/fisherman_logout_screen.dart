import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/feature/auth/interface/auth_interface.dart';
import 'package:xocobaby13/feature/auth/model/logout_request_model.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';

class FishermanLogoutScreen extends StatefulWidget {
  const FishermanLogoutScreen({super.key});

  @override
  State<FishermanLogoutScreen> createState() => _FishermanLogoutScreenState();
}

class _FishermanLogoutScreenState extends State<FishermanLogoutScreen> {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Are you sure you want to Log out',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111418),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tap log out to Log out from this app.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: AppElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5E5E5),
                        foregroundColor: const Color(0xFF111418),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: AppElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD70000),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.logout, size: 20),
                      label: Text(
                        _isLoading ? 'Logging out...' : 'Log out',
                        style: const TextStyle(
                          fontSize: 18,
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
