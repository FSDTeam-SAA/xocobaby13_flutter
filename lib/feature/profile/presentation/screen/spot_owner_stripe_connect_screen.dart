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

  Widget _stripeLogo({double height = 18}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Stripe_logo%2C_revised_2016.svg/512px-Stripe_logo%2C_revised_2016.svg.png',
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Text(
            'stripe',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF635BFF),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusLine({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = SpotOwnerProfilePalette.darkText,
  }) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 14, color: SpotOwnerProfilePalette.mutedText),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
            color: SpotOwnerProfilePalette.mutedText,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpotOwnerFlowScaffold(
      title: 'Link Stripe Account',
      showBack: true,
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFF4C48E3), Color(0xFF1893E2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x2D1A8BD6),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Stripe Connect',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            _stripeLogo(height: 15),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Connect your Stripe account to receive payouts and manage your event earnings.',
                          style: TextStyle(
                            color: Color(0xEDFFFFFF),
                            fontSize: 12.5,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const <Widget>[
                            _FeaturePill(text: 'Secure Payouts'),
                            _FeaturePill(text: 'Fast Onboarding'),
                            _FeaturePill(text: 'Bank Linking'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: SpotOwnerProfilePalette.fieldBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'How it works',
                          style: TextStyle(
                            color: SpotOwnerProfilePalette.darkText,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const _StepRow(
                          index: '1',
                          text: 'Tap "Connect Stripe Account"',
                        ),
                        const SizedBox(height: 7),
                        const _StepRow(
                          index: '2',
                          text: 'Complete Stripe onboarding in web view',
                        ),
                        const SizedBox(height: 7),
                        const _StepRow(
                          index: '3',
                          text: 'Return and continue linking bank account',
                        ),
                      ],
                    ),
                  ),
                  if (_accountId.isNotEmpty ||
                      _statusMessage.isNotEmpty ||
                      _onboarded != null ||
                      _expiresAt != null) ...<Widget>[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFD3E7F9),
                          width: 1.1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Connection Status',
                            style: TextStyle(
                              color: SpotOwnerProfilePalette.darkText,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (_statusMessage.isNotEmpty)
                            const SizedBox(height: 10),
                          if (_statusMessage.isNotEmpty)
                            _statusLine(
                              icon: Icons.info_outline,
                              label: 'Message',
                              value: _statusMessage,
                            ),
                          if (_accountId.isNotEmpty) const SizedBox(height: 8),
                          if (_accountId.isNotEmpty)
                            _statusLine(
                              icon: Icons.credit_card,
                              label: 'Account',
                              value: _accountId,
                            ),
                          if (_onboarded != null) const SizedBox(height: 8),
                          if (_onboarded != null)
                            _statusLine(
                              icon: Icons.verified_user_outlined,
                              label: 'Onboarded',
                              value: _onboarded == true ? 'Yes' : 'No',
                              valueColor: _onboarded == true
                                  ? SpotOwnerProfilePalette.successGreen
                                  : SpotOwnerProfilePalette.dangerRed,
                            ),
                          if (_expiresAt != null) const SizedBox(height: 8),
                          if (_expiresAt != null)
                            _statusLine(
                              icon: Icons.schedule_outlined,
                              label: 'Expires At',
                              value: _expiresAt.toString(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isConnecting ? null : _connectStripeAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF147FD0),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF8CBFE5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: _isConnecting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _stripeLogo(height: 14),
                        const SizedBox(width: 10),
                        const Text(
                          'Connect Stripe Account',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final String text;

  const _FeaturePill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String index;
  final String text;

  const _StepRow({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4FF),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            index,
            style: const TextStyle(
              color: SpotOwnerProfilePalette.blue,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: SpotOwnerProfilePalette.mutedText,
              fontSize: 12,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
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
  bool _completionScheduled = false;

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
    if (_hasCompleted || _completionScheduled || !mounted) return;
    _completionScheduled = true;
    _hasCompleted = true;
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      Navigator.of(context).pop(true);
    });
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
