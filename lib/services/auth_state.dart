import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._apiClient);

  final ApiClient _apiClient;
  String? _token;
  bool _isLoggingOut = false;

  String? get token => _token;
  bool get isLoggedIn => _token != null;
  bool get isLoggingOut => _isLoggingOut;

  Future<void> login(String username, String password) async {
    _token = await _apiClient.obtainToken(username, password);
    notifyListeners();
  }

  Future<void> logout() async {
    final currentToken = _token;
    if (currentToken == null || _isLoggingOut) return;

    _isLoggingOut = true;
    notifyListeners();
    try {
      await _apiClient.logout(token: currentToken);
    } finally {
      _token = null;
      _isLoggingOut = false;
      notifyListeners();
    }
  }
}
