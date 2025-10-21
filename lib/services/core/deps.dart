import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';

class TokenStorage {
  Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accesToken') ?? '';
  }

  Future<String> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken') ?? '';
  }

  Future<void> setTokens(
      {required String access, required String refresh}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accesToken', access);
    await prefs.setString('refreshToken', refresh);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accesToken');
    await prefs.remove('refreshToken');
  }
}

class NoInternetException implements Exception {
  final String message;
  NoInternetException([this.message = 'İnternet bağlantısı yok.']);
  @override
  String toString() => message;
}

class GuardedHttpClient extends http.BaseClient {
  final http.Client _inner;
  final Duration requestTimeout;
  final Duration slowThreshold;
  final void Function(String message)? notify;

  GuardedHttpClient(
    this._inner, {
    this.requestTimeout = const Duration(seconds: 15),
    this.slowThreshold = const Duration(seconds: 2),
    this.notify,
  });

  Future<void> _ensureConnectivity() async {
    try {
      final sw = Stopwatch()..start();
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 2));
      sw.stop();
      if (result.isEmpty || result.first.rawAddress.isEmpty) {
        throw NoInternetException();
      }
      if (sw.elapsed >= slowThreshold) {
        notify?.call('İnternet bağlantınız yavaş görünüyor.');
      }
    } on TimeoutException {
      notify?.call('Ağ yanıtı yavaş. Lütfen bekleyin veya tekrar deneyin.');
    } on SocketException {
      throw NoInternetException();
    }
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await _ensureConnectivity();
    final sw = Stopwatch()..start();
    try {
      final response = await _inner.send(request).timeout(requestTimeout);
      sw.stop();
      if (sw.elapsed >= slowThreshold) {
        notify?.call('İstek yanıtı yavaş geliyor.');
      }
      return response;
    } on TimeoutException {
      throw TimeoutException('İstek zaman aşımına uğradı: ${request.url}');
    }
  }
}

class ApiDependencies {
  final http.Client httpClient;
  final TokenStorage tokenStorage;
  final void Function(String message)? notify;

  ApiDependencies(
      {http.Client? httpClient, TokenStorage? tokenStorage, this.notify})
      : httpClient =
            httpClient ?? GuardedHttpClient(http.Client(), notify: notify),
        tokenStorage = tokenStorage ?? TokenStorage();
}
