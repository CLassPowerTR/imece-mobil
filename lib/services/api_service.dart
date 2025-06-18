// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imecehub/models/companies.dart';
import 'package:imecehub/models/products.dart';
import '../models/users.dart';
import '../models/productCategories.dart';
import '../api/api_config.dart'; // Add this line to import ApiConfig
import '../models/urunYorum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  /// API'den User verisini çekmek için metot.
  static Future<List<Company>> fetchSellers() async {
    // API konfigürasyon bilgilerini yükle.
    final config = await ApiConfig.loadFromAsset();

    // HTTP GET isteği gönderilirken header'a API key eklenir.
    final response = await http.get(
      Uri.parse(config.companiesApiUrl),
      headers: {
        'X-API-Key': config.apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Allow': 'Get',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Company.fromJson(json)).toList();
    } else {
      throw Exception(
          'User verisi alınamadı. Durum kodu: ${response.statusCode}');
    }
  }

  static Future<User> fetchUserId(int? id) async {
    // API konfigürasyon bilgilerini yükle.
    final config = await ApiConfig.loadFromAsset();

    // HTTP GET isteği gönderilirken header'a API key eklenir.
    final response = await http.get(
      Uri.parse('${config.usersApiUrl}$id/'),
      headers: {
        'X-API-Key': config.apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Allow': 'Get',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      return User.fromJson(jsonData);
    } else {
      throw Exception(
          'User verisi alınamadı. Durum kodu: ${response.statusCode}');
    }
  }

  /// API'den Product verisini çekmek için metot.
  static Future<List<Product>> fetchProducts({String? id}) async {
    // API konfigürasyon bilgilerini yükle.
    final config = await ApiConfig.loadFromAsset();

    // HTTP GET isteği gönderilirken header'a API key eklenir.
    final response = await http.get(
      Uri.parse(
          id == null ? config.productsApiUrl : '${config.productsApiUrl}$id/'),
      headers: {
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));

      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception(
          'Ürünler verisi alınamadı. Durum kodu: ${response.statusCode}');
    }
  }

  static Future<List<Category>> fetchCategories() async {
    // API konfigürasyon bilgilerini yükle.
    final config = await ApiConfig.loadFromAsset();

    // HTTP GET isteği gönderilirken header'a API key eklenir.
    final response = await http.get(
      Uri.parse(config.categoriesApiUrl),
      headers: {
        'X-API-Key': config.apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Allow': 'Get',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception(
          'Category verisi alınamadı. Durum kodu: ${response.statusCode}');
    }
  }

  /// API'den Product verisini çekmek için metot.
  static Future<List<Product>> fetchPopulerProducts() async {
    // API konfigürasyon bilgilerini yükle.
    final config = await ApiConfig.loadFromAsset();

    // HTTP GET isteği gönderilirken header'a API key eklenir.
    final response = await http.get(
      Uri.parse(config.populerProductsApiUrl),
      headers: {
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));

      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception(
          'Popüler Ürünler verisi alınamadı. Durum kodu: ${response.statusCode}');
    }
  }

  /// API'den Product verisini çekmek için metot.
  static Future<Product> fetchProduct(int? id) async {
    // API konfigürasyon bilgilerini yükle.
    final config = await ApiConfig.loadFromAsset();

    // HTTP GET isteği gönderilirken header'a API key eklenir.
    final response = await http.get(
      Uri.parse('${config.productsApiUrl}$id/'),
      headers: {
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      return Product.fromJson(jsonData);
    } else {
      throw Exception(
          'Ürün verisi alınamadı. Durum kodu: ${response.statusCode}');
    }
  }

  /// API'den Ürün Yorumlarını çekmek için metot.
  static Future<List<UrunYorum>> fetchUrunYorumlar({int? urunId}) async {
    // API konfigürasyon bilgilerini yükle.
    final config = await ApiConfig.loadFromAsset();

    // Eğer urunId verilmişse, ilgili ürünün yorumlarını çek.
    final url = urunId == null
        ? config.urunYorumApiUrl
        : '${config.urunYorumApiUrl}?urun=$urunId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-API-Key': config.apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Allow': 'Get',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => UrunYorum.fromJson(json)).toList();
    } else {
      throw Exception(
          'Ürün yorumları alınamadı. Durum kodu: [31m[1m${response.statusCode}[0m');
    }
  }

  static Future<User> fetchUserRegister(
      String email, String userName, String password) async {
    final config = await ApiConfig.loadFromAsset();
    final response = await http.post(
      Uri.parse(config.userRqLoginApiUrl),
      body: {
        'email': email,
        'username': userName,
        'password': password,
        'rol': 'alici'
      },
    );
    final isJson =
        response.headers['content-type']?.contains('application/json') ?? false;
    dynamic jsonData;
    if (isJson) {
      jsonData = json.decode(utf8.decode(response.bodyBytes));
    } else {
      jsonData = null;
    }
    if (response.statusCode == 200) {
      // Tokenları kaydet
      if (jsonData != null && jsonData['tokens'] != null) {
        final accessToken = jsonData['tokens']['access'] ?? '';
        final refreshToken = jsonData['tokens']['refresh'] ?? '';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accesToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
      }
      return User.fromJson(jsonData);
    } else {
      final errorStatus = jsonData != null
          ? (jsonData['status'] ?? response.statusCode)
          : response.statusCode;
      final errorMessage = jsonData != null
          ? (jsonData['message'] ?? 'Kullanıcı kaydı başarısız.')
          : response.body;
      throw Exception('Status: $errorStatus \nMessage: $errorMessage');
    }
  }

  static Future<User> fetchUserLogin(String email, String password) async {
    final config = await ApiConfig.loadFromAsset();
    final response = await http.post(
      Uri.parse(config.userRqLoginApiUrl),
      body: {'email': email, 'password': password},
    );
    final isJson =
        response.headers['content-type']?.contains('application/json') ?? false;
    dynamic jsonData;
    if (isJson) {
      jsonData = json.decode(utf8.decode(response.bodyBytes));
    } else {
      jsonData = null;
    }
    if (response.statusCode == 200) {
      // Tokenları kaydet
      if (jsonData != null && jsonData['tokens'] != null) {
        final accessToken = jsonData['tokens']['access'] ?? '';
        final refreshToken = jsonData['tokens']['refresh'] ?? '';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accesToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
      }
      return User.fromJson(jsonData);
    } else {
      final errorStatus = jsonData != null
          ? (jsonData['status'] ?? response.statusCode)
          : response.statusCode;
      final errorMessage = jsonData != null
          ? (jsonData['message'] ?? 'Kullanıcı girişi başarısız.')
          : response.body;
      throw Exception('Status: $errorStatus \nMessage: $errorMessage');
    }
  }
}
