import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';
import 'package:xocobaby13/feature/profile/presentation/routes/spot_owner_profile_routes.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_style.dart';

class SpotOwnerStripeConnectScreen extends StatefulWidget {
  const SpotOwnerStripeConnectScreen({super.key});

  @override
  State<SpotOwnerStripeConnectScreen> createState() =>
      _SpotOwnerStripeConnectScreenState();
}

class _SpotOwnerStripeConnectScreenState
    extends State<SpotOwnerStripeConnectScreen> {
  bool _isConnecting = false;
  String _accountId = '';
  bool? _onboarded;
  int? _expiresAt;
  String _statusMessage = '';

  Future<void> _connectStripeAccount() async {
    if (_isConnecting) return;
    setState(() => _isConnecting = true);
    try {
      final response = await Get.find<AuthorizedPigeon>().post(
        ApiEndpoints.paymentOnboard,
      );
      final Map<String, dynamic> responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final bool success = responseBody['success'] == true;
      final String message =
          responseBody['message']?.toString() ??
          'Unable to start Stripe onboarding';
      if (!success) {
        if (!mounted) return;
        _showMessage(message);
        return;
      }
      final Map<String, dynamic> data = responseBody['data'] is Map
          ? Map<String, dynamic>.from(responseBody['data'] as Map)
          : <String, dynamic>{};
      final bool onboarded = data['onboarded'] == true;
      final String onboardingUrl = data['onboardingUrl']?.toString() ?? '';
      final String accountId = data['accountId']?.toString() ?? '';
      final int? expiresAt = data['expiresAt'] is int
          ? data['expiresAt'] as int
          : int.tryParse(data['expiresAt']?.toString() ?? '');

      if (!mounted) return;
      setState(() {
        _accountId = accountId;
        _onboarded = onboarded;
        _expiresAt = expiresAt;
        _statusMessage = message;
      });
      if (onboarded) {
        _openBankAccountScreen(accountId);
        return;
      }
      if (onboardingUrl.trim().isEmpty) {
        _showMessage('Onboarding URL is missing');
        return;
      }

      final bool? connected = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => SpotOwnerStripeOnboardingWebViewScreen(
            onboardingUrl: onboardingUrl,
          ),
        ),
      );
      if (!mounted) return;
      if (connected == true) {
        _openBankAccountScreen(accountId);
      }
    } on DioException catch (e) {
      final dynamic errorData = e.response?.data;
      final String message = errorData is Map && errorData['message'] != null
          ? errorData['message'].toString()
          : 'Failed to connect Stripe account';
      if (!mounted) return;
      _showMessage(message);
    } catch (_) {
      if (!mounted) return;
      _showMessage('Failed to connect Stripe account');
    } finally {
      if (mounted) {
        setState(() => _isConnecting = false);
      }
    }
  }

  void _openBankAccountScreen(String accountId) {
    final String cleanAccountId = accountId.trim();
    final String targetPath = cleanAccountId.isEmpty
        ? SpotOwnerProfileRouteNames.linkBankAccountForm
        : '${SpotOwnerProfileRouteNames.linkBankAccountForm}?accountNumber=${Uri.encodeComponent(cleanAccountId)}';
    context.pushReplacement(targetPath);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpotOwnerFlowScaffold(
      title: 'Link Bank Account',
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8),
          const Text(
            'Connect your Stripe account first to continue linking your bank details.',
            style: TextStyle(
              color: SpotOwnerProfilePalette.mutedText,
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: SpotOwnerProfilePalette.fieldBorder),
            ),
            child: const Row(
              children: <Widget>[
                Icon(
                  Icons.account_balance_outlined,
                  color: SpotOwnerProfilePalette.blue,
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Stripe Account Onboarding',
                    style: TextStyle(
                      color: SpotOwnerProfilePalette.darkText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_accountId.isNotEmpty || _statusMessage.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: SpotOwnerProfilePalette.fieldBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (_statusMessage.isNotEmpty)
                    Text(
                      'Message: $_statusMessage',
                      style: const TextStyle(
                        color: SpotOwnerProfilePalette.mutedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (_accountId.isNotEmpty) const SizedBox(height: 4),
                  if (_accountId.isNotEmpty)
                    Text(
                      'Account: $_accountId',
                      style: const TextStyle(
                        color: SpotOwnerProfilePalette.darkText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (_onboarded != null) const SizedBox(height: 4),
                  if (_onboarded != null)
                    Text(
                      'Onboarded: ${_onboarded == true ? "Yes" : "No"}',
                      style: const TextStyle(
                        color: SpotOwnerProfilePalette.darkText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (_expiresAt != null) const SizedBox(height: 4),
                  if (_expiresAt != null)
                    Text(
                      'Expires At: $_expiresAt',
                      style: const TextStyle(
                        color: SpotOwnerProfilePalette.darkText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _isConnecting ? null : _connectStripeAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: SpotOwnerProfilePalette.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isConnecting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Connect Stripe Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class SpotOwnerStripeOnboardingWebViewScreen extends StatefulWidget {
  final String onboardingUrl;

  const SpotOwnerStripeOnboardingWebViewScreen({
    super.key,
    required this.onboardingUrl,
  });

  @override
  State<SpotOwnerStripeOnboardingWebViewScreen> createState() =>
      _SpotOwnerStripeOnboardingWebViewScreenState();
}

class _SpotOwnerStripeOnboardingWebViewScreenState
    extends State<SpotOwnerStripeOnboardingWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            _completeIfSuccessUrl(url);
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (_isSuccessRedirectUrl(request.url)) {
              _completeOnboarding();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.onboardingUrl));
  }

  bool _isSuccessRedirectUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) return false;
    final String scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') return true;

    final String path = uri.path.toLowerCase();
    if (path.contains('/spot-owner/profile/link-bank-account')) return true;

    final String statusValue =
        uri.queryParameters['status']?.toLowerCase() ?? '';
    final bool querySaysSuccess =
        _isTruthy(uri.queryParameters['success']) ||
        _isTruthy(uri.queryParameters['onboarded']) ||
        _isTruthy(uri.queryParameters['connected']) ||
        statusValue == 'success';
    return querySaysSuccess;
  }

  bool _isTruthy(String? value) {
    final String normalized = value?.trim().toLowerCase() ?? '';
    return normalized == '1' || normalized == 'true' || normalized == 'yes';
  }

  void _completeIfSuccessUrl(String url) {
    if (_isSuccessRedirectUrl(url)) {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    if (_hasCompleted || !mounted) return;
    _hasCompleted = true;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stripe Onboarding',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E2530),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: SpotOwnerProfilePalette.blue,
                strokeWidth: 2.2,
              ),
            ),
        ],
      ),
    );
  }
}
