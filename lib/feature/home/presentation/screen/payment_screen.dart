import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';
import 'package:xocobaby13/feature/home/presentation/routes/home_routes.dart';
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

  String _extractSessionId(Map<String, dynamic> responseBody) {
    String valueToText(dynamic value) => value?.toString().trim() ?? '';

    final List<dynamic> candidates = <dynamic>[
      responseBody['sessionId'],
      responseBody['id'],
      responseBody['checkoutSessionId'],
    ];
    final dynamic data = responseBody['data'];
    if (data is Map) {
      candidates.addAll(<dynamic>[
        data['sessionId'],
        data['id'],
        data['checkoutSessionId'],
      ]);
      final dynamic session = data['session'];
      if (session is Map) {
        candidates.add(session['id']);
        candidates.add(session['sessionId']);
      }
    }

    for (final dynamic candidate in candidates) {
      final String value = valueToText(candidate);
      if (value.isNotEmpty) return value;
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

  Future<dynamic> _confirmPaymentRequest(String sessionId) async {
    final AuthorizedPigeon pigeon = Get.find<AuthorizedPigeon>();
    final Map<String, dynamic> payload = <String, dynamic>{
      'bookingId': widget.bookingId,
      'sessionId': sessionId,
    };
    try {
      return await pigeon.post(ApiEndpoints.paymentConfirm, data: payload);
    } on DioException catch (e) {
      final int statusCode = e.response?.statusCode ?? 0;
      if (statusCode == 404 || statusCode == 405) {
        return pigeon.post(ApiEndpoints.paymentConfirmLegacy, data: payload);
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

      final String sessionId = _extractSessionId(createBody);
      if (sessionId.isEmpty) {
        if (!mounted) return;
        _showMessage('Payment session id is missing');
        return;
      }

      final confirmResponse = await _confirmPaymentRequest(sessionId);
      final Map<String, dynamic> confirmBody = confirmResponse.data is Map
          ? Map<String, dynamic>.from(confirmResponse.data as Map)
          : <String, dynamic>{};
      final bool confirmSuccess = confirmBody['success'] == null
          ? (confirmResponse.statusCode ?? 500) < 300
          : confirmBody['success'] == true;
      if (!confirmSuccess) {
        if (!mounted) return;
        _showMessage(
          _responseMessage(
            confirmBody,
            fallback: 'Payment confirmation failed',
          ),
        );
        return;
      }

      if (!mounted) return;
      context.pop(true);
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 6),
                    Text(
                      'Choose Payment Method',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6A7B8C),
                      ),
                    ),
                    SizedBox(height: 8),
                    _PaymentMethodTile(
                      title: 'Stripe',
                      subtitle: 'Pay securely with Stripe',
                      subtitle: 'Pay with Stripe',
                      selected: !_useCard,
                      onTap: () => setState(() => _useCard = false),
                    ),
                    const SizedBox(height: 10),
                    _FieldLabel(label: 'Card Number'),
                    const SizedBox(height: 4),
                    _PaymentInputField(
                      controller: _cardNumberController,
                      hintText: '****  ****  ****  ****',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    _FieldLabel(label: 'Cardholder Name'),
                    const SizedBox(height: 4),
                    _PaymentInputField(
                      controller: _cardHolderController,
                      hintText: 'Enter Cardholder Name',
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: _FieldLabel(label: 'Expiry Date / Valid Thru'),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(child: _FieldLabel(label: 'CVV / CVC')),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _PaymentInputField(
                            controller: _expiryController,
                            hintText: '-- / --',
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _PaymentInputField(
                            controller: _cvvController,
                            hintText: 'Enter CVV',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => setState(() => _saveCard = !_saveCard),
                      child: Row(
                        children: <Widget>[
                          _MiniToggle(selected: _saveCard),
                          const SizedBox(width: 8),
                          const Text(
                            'Save this card',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF3A4A5A),
                            ),
                          ),
                        ],
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
                      child: ElevatedButton(
                        onPressed: _isPaying ? null : _payNow,
                      child: AppElevatedButton(
                        onPressed: _payNow,
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
