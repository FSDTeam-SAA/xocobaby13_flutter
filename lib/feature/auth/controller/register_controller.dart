import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../interface/auth_interface.dart';
import '../model/register_request_model.dart';

class RegisterScreenController extends ChangeNotifier {
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier();
  final SnackbarNotifier snackbarNotifier;

  RegisterScreenController(this.snackbarNotifier);

  String _name = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _confirmPassword = '';

  // Simple flags you can use in UI without depending on ProcessStatusNotifier internals
  bool _busy = false;
  bool get isBusy => _busy;

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get password => _password;
  String get confirmPassword => _confirmPassword;

  set name(String v) {
    if (v != _name) {
      _name = v.trim();
      notifyListeners();
    }
  }

  set email(String v) {
    if (v != _email) {
      _email = v.trim();
      notifyListeners();
    }
  }

  set phone(String v) {
    if (v != _phone) {
      _phone = v.trim();
      notifyListeners();
    }
  }

  set password(String v) {
    if (v != _password) {
      _password = v;
      notifyListeners();
    }
  }

  set confirmPassword(String v) {
    if (v != _confirmPassword) {
      _confirmPassword = v;
      notifyListeners();
    }
  }

  Future<void> register({
    VoidCallback? onSuccessNavigate, // Optional: navigate upon success
  }) async {
    _busy = true;
    notifyListeners();
    processStatusNotifier.setLoading();

    final payload = RegisterRequest(
      name: _name,
      email: _email,
      phone: _phone,
      password: _password,
      confirmPassword: _confirmPassword,
    );

    // Optional small delay to match your login behavior
    await Future.delayed(const Duration(milliseconds: 600));

    final either = await Get.find<AuthInterface>().register(param: payload);
    bool didSucceed = false;
    either.fold((_) {}, (_) => didSucceed = true);
    handleFold(
      either: either,
      processStatusNotifier: processStatusNotifier,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
    );
    if (didSucceed && onSuccessNavigate != null) {
      onSuccessNavigate();
    }

    _busy = false;
    notifyListeners();
  }
}
