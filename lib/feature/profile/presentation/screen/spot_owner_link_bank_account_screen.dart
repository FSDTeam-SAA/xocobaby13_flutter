import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/profile/presentation/routes/spot_owner_profile_routes.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_style.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_text_field.dart';

class SpotOwnerLinkBankAccountScreen extends StatefulWidget {
  final String initialAccountNumber;

  const SpotOwnerLinkBankAccountScreen({
    super.key,
    this.initialAccountNumber = '',
  });

  @override
  State<SpotOwnerLinkBankAccountScreen> createState() =>
      _SpotOwnerLinkBankAccountScreenState();
}

class _SpotOwnerLinkBankAccountScreenState
    extends State<SpotOwnerLinkBankAccountScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _routingController = TextEditingController();
  bool _showAccountNumber = false;

  @override
  void initState() {
    super.initState();
    final String initialAccount = widget.initialAccountNumber.trim();
    if (initialAccount.isNotEmpty) {
      _accountController.text = initialAccount;
    }
  }

  @override
  void dispose() {
    _accountController.dispose();
    _routingController.dispose();
    super.dispose();
  }

  void _submit() {
    final String accountNumber = _accountController.text.trim();
    final String routingNumber = _routingController.text.trim();
    if (accountNumber.isEmpty || routingNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill account and routing number'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    context.push(SpotOwnerProfileRouteNames.bankAccountSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return SpotOwnerFlowScaffold(
      title: 'Link Bank Account',
      showBack: true,
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 8),
                  SpotOwnerProfileTextField(
                    label: 'Account Number',
                    controller: _accountController,
                    hint: '•••• •••• ••••',
                    obscureText: !_showAccountNumber,
                    keyboardType: TextInputType.text,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(
                          () => _showAccountNumber = !_showAccountNumber,
                        );
                      },
                      icon: Icon(
                        _showAccountNumber
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: SpotOwnerProfilePalette.mutedText,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SpotOwnerProfileTextField(
                    label: 'Routing Number',
                    controller: _routingController,
                    hint: '••• •• ••••',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: SpotOwnerProfilePalette.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
