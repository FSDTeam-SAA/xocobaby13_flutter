import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../interface/auth_interface.dart';
import '../model/reset_password_request_model.dart';

class ResetPasswordController extends ChangeNotifier {
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier();
  final SnackbarNotifier snackbarNotifier;

  String _email = '';
  String _otp = '';
  String _password = '';
  String _confirmPassword = '';

  String get email => _email;
  String get otp => _otp;
  String get password => _password;
  String get confirmPassword => _confirmPassword;

  ResetPasswordController(this.snackbarNotifier);

  set email(String value) {
    if (value != _email) {
      _email = value.trim();
      processStatusNotifier.setEnabled();
      notifyListeners();
    }
  }

  set otp(String value) {
    if (value != _otp) {
      _otp = value.trim();
      processStatusNotifier.setEnabled();
      notifyListeners();
    }
  }

  set password(String value) {
    if (value != _password) {
      _password = value;
      processStatusNotifier.setEnabled();
      notifyListeners();
    }
  }

  set confirmPassword(String value) {
    if (value != _confirmPassword) {
      _confirmPassword = value;
      processStatusNotifier.setEnabled();
      notifyListeners();
    }
  }

  Future<void> resetPassword({required VoidCallback onSuccess}) async {
    processStatusNotifier.setLoading();

    await Future.delayed(const Duration(milliseconds: 500));

    await Get.find<AuthInterface>()
        .resetPassword(
          param: ResetPasswordRequestModel(
            email: email,
            otp: otp,
            password: password,
          ),
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
