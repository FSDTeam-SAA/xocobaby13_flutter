import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../interface/auth_interface.dart';
import '../model/verify_email_request_model.dart';

class VerifyEmailController extends ChangeNotifier {
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier();
  final SnackbarNotifier snackbarNotifier;

  String _email = '';
  String _otp = '';

  String get email => _email;
  String get otp => _otp;

  VerifyEmailController(this.snackbarNotifier);

  set email(String value) {
    if (value != _email) {
      _email = value.trim();
      processStatusNotifier.setEnabled();
      notifyListeners();
    }
  }

  set otp(String value) {
    if (value != _otp) {
      _otp = value;
      processStatusNotifier.setEnabled();
      notifyListeners();
    }
  }

  Future<void> verifyEmail({required VoidCallback onSuccess}) async {
    processStatusNotifier.setLoading();

    await Future.delayed(const Duration(milliseconds: 500));

    await Get.find<AuthInterface>()
        .verifyEmail(
          param: VerifyEmailRequestModel(email: email, otp: otp),
        )
        .then((result) {
          handleFold(
            either: result,
            processStatusNotifier: processStatusNotifier,
            successSnackbarNotifier: snackbarNotifier,
            errorSnackbarNotifier: snackbarNotifier,
            onSuccess: (_) {
              onSuccess();
            },
          );
        });
  }

  @override
  void dispose() {
    processStatusNotifier.dispose();
    super.dispose();
  }
}
