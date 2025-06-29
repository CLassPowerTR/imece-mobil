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
  static final config = ApiConfig();

  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accesToken') ?? '';
  }

  /// API'den User verisini çekmek için metot.
  static Future<List<Company>> fetchSellers() async {
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

  static Future fetchUserRegister(
      String email, String userName, String password) async {
    final response = await http.post(
      Uri.parse(config.userRqRegisterApiUrl),
      body: json.encode({
        'email': email,
        'username': userName,
        'password': password,
        'rol': 'alici'
      }),
      headers: {
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
        'Allow': 'Post',
      },
    );
    final contentType = response.headers.entries
        .firstWhere((e) => e.key.toLowerCase() == 'content-type',
            orElse: () => MapEntry('', ''))
        .value;
    final isJson = contentType.contains('application/json');
    dynamic jsonData;
    if (isJson) {
      jsonData = json.decode(utf8.decode(response.bodyBytes));
    } else {
      jsonData = null;
    }
    if (response.statusCode == 200 && jsonData != null) {
      // Tokenları kaydet
      if (jsonData['tokens'] != null) {
        final accessToken = jsonData['tokens']['access'] ?? '';
        final refreshToken = jsonData['tokens']['refresh'] ?? '';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accesToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
      }
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

  static Future fetchUserLogin(String email, String password) async {
    final response = await http.post(
      Uri.parse(config.userRqLoginApiUrl),
      body: json.encode({'email': email, 'password': password}),
      headers: {
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
        'Allow': 'Post',
      },
    );
    final jsonData = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200 && jsonData != null) {
      if (jsonData['tokens'] != null) {
        final accessToken = jsonData['tokens']['access'] ?? '';
        final refreshToken = jsonData['tokens']['refresh'] ?? '';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accesToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
      }
    } else {
      final errorStatus = jsonData['status'] ?? response.statusCode;
      final errorMessage = jsonData['message'] ?? 'Kullanıcı girişi başarısız.';
      throw Exception('Status: $errorStatus \nMessage: $errorMessage');
    }
  }

  static Future<User> fetchUserMe() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse(config.userMeApiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
        'Allow': 'Get',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      return User.fromJson(jsonData);
    } else {
      throw Exception(
          'Kullanıcı me bilgisi alınamadı. Durum kodu: ${response.statusCode}');
    }
  }

  static Future<String> fetchUserLogout() async {
    final accessToken = await getAccessToken();
    try {
      final response = await http.delete(
        Uri.parse(config.userLogoutApiUrl),
        body: json.encode({'refresh_token': accessToken}),
        headers: {
          'X-API-Key': config.apiKey,
          'Content-Type': 'application/json',
          'Allow': 'Post',
        },
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        if (jsonData is Map && jsonData['status'] == 'success') {
          return jsonData['message'];
        } else {
          throw Exception(
              'Çıkış başarısız: ${jsonData['message'] ?? 'Bilinmeyen hata'}');
        }
      } else {
        throw Exception('${response.body}');
      }
    } finally {
      await SharedPreferences.getInstance()
          .then((prefs) => prefs.remove('accesToken'));
    }
  }

  static Future fetchSepetEkle(int? miktar, int urunId) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final response = await http.post(
      Uri.parse(config.sepetEkleApiUrl),
      body: json.encode({
        'miktar': miktar ?? 0,
        'urun_id': urunId,
      }),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
        'Allow': 'Post',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      if (jsonData is Map && jsonData['status'] == 'success') {
        return jsonData['message'];
      } else {
        throw Exception(
            'Sepete ekleme başarısız: Durum kodu: ${response.statusCode} \n${jsonData['detail'] ?? 'Bilinmeyen hata'}');
      }
    } else {
      throw Exception(
          'Sepete ekleme başarısız. Durum kodu: ${response.statusCode} \n${response.body}');
    }
  }

  static Future<Map<String, dynamic>> fetchSepetGet() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final response = await http.get(
      Uri.parse(config.sepetGetApiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('durum')) {
        if (jsonData['durum'] == 'SEPET_DOLU' && jsonData['sepet'] is List) {
          return {'durum': 'SEPET_DOLU', 'sepet': jsonData['sepet']};
        } else if (jsonData['durum'] == 'BOS_SEPET') {
          return {
            'durum': 'BOS_SEPET',
            'mesaj': jsonData['mesaj'] ?? 'Sepetinizde ürün bulunmamaktadır.'
          };
        } else {
          throw Exception('Bilinmeyen sepet durumu: \\${jsonData['durum']}');
        }
      } else {
        throw Exception('Sepet verisi alınamadı: Beklenen formatta değil.');
      }
    } else {
      throw Exception(
          'Sepet verisi alınamadı. Durum kodu: \\${response.statusCode} \\n\\${response.body}');
    }
  }

  static Future<Map<String, dynamic>> fetchSepetInfo() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.get(
      Uri.parse(config.sepetInfoApiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('durum')) {
        if (jsonData['durum'] == 'SEPET_DOLU') {
          return jsonData;
        } else if (jsonData['durum'] == 'BOS_SEPET') {
          return {
            'durum': 'BOS_SEPET',
            'mesaj': jsonData['mesaj'] ?? 'Sepetinizde ürün bulunmamaktadır.'
          };
        } else {
          throw Exception('Bilinmeyen sepet durumu: \\${jsonData['durum']}');
        }
      } else {
        throw Exception('Sepet bilgisi alınamadı: Beklenen formatta değil.');
      }
    } else {
      throw Exception(
          'Sepet bilgisi alınamadı. Durum kodu: \\${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchUserFavorites(
      int? id, int? userID, int? urunID) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    String url;
    if (id == null) {
      url = config.userFavoritesApiUrl;
    } else {
      url = '${config.userFavoritesApiUrl}$id/';
    }
    // userID ve urunID doluysa query parametre olarak ekle
    if (userID != null || urunID != null) {
      if (userID != null || urunID != null) {
        return ['userID ve urunID boş olamaz.'];
      } else {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'X-API-Key': config.apiKey,
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'alici': userID,
            'urun': urunID,
          }),
        );
        if (response.statusCode == 200 && response.body.isNotEmpty) {
          final jsonData = json.decode(utf8.decode(response.bodyBytes));
          return jsonData;
        } else {
          throw Exception(
              'Favori ürünler alınamadı. Durum kodu: \\${response.statusCode}');
        }
      }
    } else {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'X-API-Key': config.apiKey,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return jsonData;
      } else {
        throw Exception(
            'Favori ürünler alınamadı. Durum kodu: \\${response.statusCode}');
      }
    }
  }
}
