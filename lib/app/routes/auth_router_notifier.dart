import 'dart:async';

import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/foundation.dart';

class AuthRouterNotifier extends ChangeNotifier {
  AuthRouterNotifier(this._authorizedPigeon) {
    _status = AuthLoading();
    _subscription = _authorizedPigeon.authStream.listen((AuthStatus status) {
      _status = status;
      notifyListeners();
    });
  }

  final AuthorizedPigeon _authorizedPigeon;
  late final StreamSubscription<AuthStatus> _subscription;
  AuthStatus _status = AuthLoading();

  AuthStatus get status => _status;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
