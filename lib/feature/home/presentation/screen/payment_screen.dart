import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';

class PaymentScreen extends StatefulWidget {
  final String bookingId;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.bookingId,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isPaying = false;

  String get _amountLabel {
    final double amount = widget.totalAmount.isNaN ? 0 : widget.totalAmount;
    return '\$${amount.toStringAsFixed(2)}';
  }

  String _extractCheckoutUrl(Map<String, dynamic> responseBody) {
    String valueToText(dynamic value) => value?.toString().trim() ?? '';

    bool isValidHttpUrl(String value) {
      final Uri? uri = Uri.tryParse(value);
      if (uri == null) return false;
      final String scheme = uri.scheme.toLowerCase();
      return scheme == 'http' || scheme == 'https';
    }

    final List<dynamic> candidates = <dynamic>[
      responseBody['checkoutUrl'],
      responseBody['checkout_url'],
      responseBody['url'],
    ];

    final dynamic data = responseBody['data'];
    if (data is Map) {
      candidates.addAll(<dynamic>[
        data['checkoutUrl'],
        data['checkout_url'],
        data['url'],
      ]);

      final dynamic payment = data['payment'];
      if (payment is Map) {
        final dynamic gatewayResponse = payment['gatewayResponse'];
        if (gatewayResponse is Map) {
          candidates.addAll(<dynamic>[
            gatewayResponse['checkoutUrl'],
            gatewayResponse['checkout_url'],
            gatewayResponse['url'],
          ]);
        }
      }
    }

    for (final dynamic candidate in candidates) {
      final String value = valueToText(candidate);
      if (value.isNotEmpty && isValidHttpUrl(value)) return value;
    }
    return '';
  }

  String _responseMessage(dynamic responseData, {required String fallback}) {
    if (responseData is Map && responseData['message'] != null) {
      final String message = responseData['message'].toString().trim();
      if (message.isNotEmpty) return message;
    }
    if (responseData is String && responseData.trim().isNotEmpty) {
      return responseData.trim();
    }
    return fallback;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
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

  Future<dynamic> _createPaymentRequest() async {
    final AuthorizedPigeon pigeon = Get.find<AuthorizedPigeon>();
    try {
      return await pigeon.post(
        ApiEndpoints.paymentCreate,
        data: <String, dynamic>{'bookingId': widget.bookingId},
      );
    } on DioException catch (e) {
      final int statusCode = e.response?.statusCode ?? 0;
      if (statusCode == 404 || statusCode == 405) {
        return pigeon.post(
          ApiEndpoints.paymentCreateLegacy,
          data: <String, dynamic>{'bookingId': widget.bookingId},
        );
      }
      rethrow;
    }
  }

  Future<void> _payNow() async {
    if (_isPaying) return;
    if (widget.bookingId.trim().isEmpty) {
      _showMessage('Booking id is missing');
      return;
    }

    setState(() => _isPaying = true);
    try {
      final createResponse = await _createPaymentRequest();
      final Map<String, dynamic> createBody = createResponse.data is Map
          ? Map<String, dynamic>.from(createResponse.data as Map)
          : <String, dynamic>{};
      final bool createSuccess = createBody['success'] == null
          ? true
          : createBody['success'] == true;
      if (!createSuccess) {
        if (!mounted) return;
        _showMessage(
          _responseMessage(createBody, fallback: 'Unable to create payment'),
        );
        return;
      }

      final String checkoutUrl = _extractCheckoutUrl(createBody);
      if (checkoutUrl.isEmpty) {
        if (!mounted) return;
        _showMessage('Payment URL is missing');
        return;
      }

      if (!mounted) return;
      final bool? paid = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => _CheckoutWebViewScreen(checkoutUrl: checkoutUrl),
        ),
      );

      if (!mounted) return;
      if (paid == true) {
        context.pop(true);
      }
    } on DioException catch (e) {
      if (!mounted) return;
      _showMessage(
        _responseMessage(e.response?.data, fallback: 'Payment failed'),
      );
    } catch (_) {
      if (!mounted) return;
      _showMessage('Payment failed');
    } finally {
      if (mounted) {
        setState(() => _isPaying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FF),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -90,
              right: -90,
              child: Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x18006AE6),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -60,
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x1200A0FF),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => context.pop(false),
                        child: const Icon(
                          CupertinoIcons.back,
                          color: Color(0xFF1D2A36),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Secure Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D2A36),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: <Color>[
                                Color(0xFF1066BA),
                                Color(0xFF1787CF),
                                Color(0xFF20A4F3),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Color(0x331787CF),
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
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.creditcard_fill,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      'Pay via Stripe',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  _stripeLogo(height: 16),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Amount to Pay',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xD9FFFFFF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _amountLabel,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
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
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFD9E6F2)),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Color(0x140A2A45),
                                blurRadius: 14,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Booking Details',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D2A36),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Booking ID',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF6A7B8C),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                widget.bookingId,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF1D2A36),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: const <Widget>[
                                  _MetaChip(
                                    icon: CupertinoIcons.lock_fill,
                                    text: 'SSL Encrypted',
                                  ),
                                  _MetaChip(
                                    icon: CupertinoIcons.checkmark_shield_fill,
                                    text: 'Trusted Gateway',
                                  ),
                                  _MetaChip(
                                    icon: CupertinoIcons.clock_fill,
                                    text: 'Instant Confirmation',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _PaymentMethodTile(
                          title: 'Stripe Card Payment',
                          subtitle: 'Visa, Mastercard, American Express',
                          logo: _stripeLogo(height: 15),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap Pay to open Stripe checkout and complete your payment securely.',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF6A7B8C),
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F8FF),
                      border: Border(top: BorderSide(color: Color(0xFFD8E8F6))),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D2A36),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _amountLabel,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1787CF),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: AppElevatedButton(
                            onPressed: _isPaying ? null : _payNow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F74CC),
                              disabledBackgroundColor: const Color(0xFF8FBDE2),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isPaying
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Text(
                                        'Pay with Stripe',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _amountLabel,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              CupertinoIcons.lock_fill,
                              size: 10,
                              color: Color(0xFF6A7B8C),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Bank-level security by Stripe',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: Color(0xFF6A7B8C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
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

class _CheckoutWebViewScreen extends StatefulWidget {
  final String checkoutUrl;

  const _CheckoutWebViewScreen({required this.checkoutUrl});

  @override
  State<_CheckoutWebViewScreen> createState() => _CheckoutWebViewScreenState();
}

class _CheckoutWebViewScreenState extends State<_CheckoutWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isHandled = false;

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
            _completeFromUrl(url);
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (_isSuccessUrl(request.url)) {
              _finish(true);
              return NavigationDecision.prevent;
            }
            if (_isCancelOrFailUrl(request.url)) {
              _finish(false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  void _completeFromUrl(String url) {
    if (_isSuccessUrl(url)) {
      _finish(true);
      return;
    }
    if (_isCancelOrFailUrl(url)) {
      _finish(false);
    }
  }

  bool _isSuccessUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) return false;
    final String full = url.toLowerCase();
    final String path = uri.path.toLowerCase();
    final String status = (uri.queryParameters['status'] ?? '')
        .toLowerCase()
        .trim();
    final String redirectStatus = (uri.queryParameters['redirect_status'] ?? '')
        .toLowerCase()
        .trim();
    final String paymentStatus = (uri.queryParameters['payment_status'] ?? '')
        .toLowerCase()
        .trim();
    final String sessionStatus = (uri.queryParameters['session_status'] ?? '')
        .toLowerCase()
        .trim();

    if (redirectStatus == 'succeeded') return true;
    if (paymentStatus == 'paid') return true;
    if (sessionStatus == 'complete') return true;
    if (status == 'success' ||
        status == 'succeeded' ||
        status == 'paid' ||
        status == 'complete') {
      return true;
    }
    if (path.contains('/payment/success') ||
        path.endsWith('/success') ||
        path.contains('/payment-success') ||
        full.contains('payment_success')) {
      return true;
    }
    return false;
  }

  bool _isCancelOrFailUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) return false;
    final String full = url.toLowerCase();
    final String path = uri.path.toLowerCase();
    final String status = (uri.queryParameters['status'] ?? '')
        .toLowerCase()
        .trim();
    final String redirectStatus = (uri.queryParameters['redirect_status'] ?? '')
        .toLowerCase()
        .trim();
    final String paymentStatus = (uri.queryParameters['payment_status'] ?? '')
        .toLowerCase()
        .trim();

    if (redirectStatus == 'failed') return true;
    if (paymentStatus == 'failed' || paymentStatus == 'canceled') return true;
    if (status == 'failed' || status == 'cancel' || status == 'canceled') {
      return true;
    }
    if (path.contains('/cancel') ||
        path.contains('/canceled') ||
        full.contains('payment_cancel') ||
        path.contains('/failed')) {
      return true;
    }
    return false;
  }

  void _finish(bool paid) {
    if (_isHandled || !mounted) return;
    _isHandled = true;
    Navigator.of(context).pop(paid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stripe Checkout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1D2A36),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget logo;

  const _PaymentMethodTile({
    required this.title,
    required this.subtitle,
    required this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E7CC8), width: 1.2),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4FF),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Text(
              'S',
              style: TextStyle(
                color: Color(0xFF635BFF),
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2A36),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7A8B9C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          logo,
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 11, color: const Color(0xFF196FAF)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 9.5,
              color: Color(0xFF196FAF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
