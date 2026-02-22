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

  bool canReset() {
    return _email.isNotEmpty &&
        _otp.isNotEmpty &&
        _otp.length >= 6 &&
        _password.isNotEmpty &&
        _password.length >= 6 &&
        _confirmPassword.isNotEmpty &&
        _password == _confirmPassword;
  }

  void updateButtonState() {
    if (canReset()) {
      processStatusNotifier.setEnabled();
    } else {
      processStatusNotifier.setDisabled();
    }
  }

  set email(String value) {
    if (value != _email) {
      _email = value.trim();
      updateButtonState();
      notifyListeners();
    }
  }

  set otp(String value) {
    if (value != _otp) {
      _otp = value.trim();
      updateButtonState();
      notifyListeners();
    }
  }

  set password(String value) {
    if (value != _password) {
      _password = value;
      updateButtonState();
      notifyListeners();
    }
  }

  set confirmPassword(String value) {
    if (value != _confirmPassword) {
      _confirmPassword = value;
      updateButtonState();
      notifyListeners();
    }
  }

  Future<void> resetPassword({required VoidCallback onSuccess}) async {
    if (!canReset()) {
      if (_password != _confirmPassword) {
        snackbarNotifier.notifyError(message: 'Passwords do not match');
      } else {
        snackbarNotifier.notifyError(
          message: 'Please fill all fields correctly',
        );
      }
      return;
    }

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
