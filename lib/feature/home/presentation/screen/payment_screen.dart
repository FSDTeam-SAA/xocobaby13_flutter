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
      backgroundColor: const Color(0xFFF6FBFF),
      body: SafeArea(
        child: Column(
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
                    'Payment',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D2A36),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 6),
                    const Text(
                      'Choose Payment Method',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6A7B8C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _PaymentMethodTile(
                      title: 'Stripe',
                      subtitle: 'Pay securely with Stripe',
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFD2DEE9)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Booking',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF6A7B8C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.bookingId,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF1D2A36),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tap pay to open Stripe checkout.',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF6A7B8C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                color: const Color(0xFFF6FBFF),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D2A36),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _amountLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D2A36),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: AppElevatedButton(
                        onPressed: _isPaying ? null : _payNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1787CF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isPaying
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
                            : Text(
                                'Pay $_amountLabel  >',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.lock_fill,
                          size: 9,
                          color: Color(0xFF6A7B8C),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Your payment is secured',
                          style: TextStyle(
                            fontSize: 8.5,
                            color: Color(0xFF6A7B8C),
                            fontWeight: FontWeight.w500,
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

  const _PaymentMethodTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E7CC8), width: 1),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D2A36),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF7A8B9C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1E7CC8)),
            ),
            child: const Center(
              child: CircleAvatar(
                radius: 4,
                backgroundColor: Color(0xFF1E7CC8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
