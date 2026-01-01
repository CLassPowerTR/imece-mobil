// lib/services/api_service.dart

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imecehub/models/companies.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/models/sellerProducts.dart';
import 'package:imecehub/models/userAdress.dart';
import 'package:imecehub/models/campaigns.dart';
import 'package:imecehub/models/stories.dart';
import '../models/users.dart';
import '../models/productCategories.dart';
import '../api/api_config.dart'; // Add this line to import ApiConfig
import '../models/urunYorum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/deps.dart';

class ApiService {
  static final config = ApiConfig();
  static ApiDependencies _deps = ApiDependencies();

  // Üst seviyeden mock/özelleştirilmiş bağımlılıkları enjekte etmek için
  static void configureDependencies(ApiDependencies deps) {
    _deps = deps;
  }

  static Future<String> getAccessToken() async {
    // Konsola token yazma (güvenlik) kaldırıldı
    return _deps.tokenStorage.getAccessToken();
  }

  static Future<String> getRefreshToken() async {
    // Konsola token yazma (güvenlik) kaldırıldı
    return _deps.tokenStorage.getRefreshToken();
  }

  /// API'den User verisini çekmek için metot.
  static Future<List<Company>> fetchSellers() async {
    final response = await _deps.httpClient.get(
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
        'User verisi alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  static Future<User> fetchUserId(int? id) async {
    // HTTP GET isteği gönderilirken header'a API key eklenir.
    final response = await _deps.httpClient.get(
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
        'User verisi alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  static Future<User> fetchSellerProfile(int? id) async {
    // URL oluştur - eğer sellerProfileApiUrl boşsa usersApiUrl kullan
    final String baseUrl = config.sellerProfileApiUrl.isNotEmpty
        ? config.sellerProfileApiUrl
        : config.usersApiUrl;

    // URL formatını düzelt
    final String url = baseUrl.endsWith('/') ? '$baseUrl$id/' : '$baseUrl/$id/';

    debugPrint(
      'fetchSellerProfile: URL: $url, sellerProfileApiUrl: ${config.sellerProfileApiUrl}, usersApiUrl: ${config.usersApiUrl}',
    );

    // HTTP GET isteği gönderilirken header'a API key eklenir.
    final response = await _deps.httpClient.get(
      Uri.parse(url),
      headers: {
        'X-API-Key': config.apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Allow': 'Get',
      },
    );

    final bodyText = utf8.decode(response.bodyBytes);

    // Response'un JSON olup olmadığını kontrol et
    final contentType = response.headers['content-type']?.toLowerCase() ?? '';
    if (!contentType.contains('application/json') &&
        bodyText.trim().startsWith('<!')) {
      debugPrint(
        'fetchSellerProfile: API HTML döndü. Status: ${response.statusCode}',
      );
      debugPrint(
        'fetchSellerProfile: Response body (ilk 200 karakter): ${bodyText.length > 200 ? bodyText.substring(0, 200) : bodyText}',
      );
      throw Exception(
        'Seller profil verisi alınamadı. API yanıtı beklenen formatta değil (HTML döndü). Durum kodu: ${response.statusCode}',
      );
    }

    if (response.statusCode == 200) {
      try {
        final jsonData = json.decode(bodyText);

        // Gelen veri User.SellerProfil formatındadır
        // satici_profili alanının doğru parse edildiğinden emin ol
        if (jsonData is Map<String, dynamic>) {
          // satici_profili alanını kontrol et
          if (jsonData.containsKey('satici_profili') &&
              jsonData['satici_profili'] != null) {
            debugPrint(
              'fetchSellerProfile: satici_profili alanı bulundu - User.fromJson ile parse edilecek',
            );
            // satici_profili alanının içeriğini kontrol et
            final saticiProfiliData = jsonData['satici_profili'];
            if (saticiProfiliData is Map<String, dynamic>) {
              debugPrint(
                'fetchSellerProfile: satici_profili Map formatında - SellerProfil.fromJson ile parse edilecek',
              );
            }
          } else {
            debugPrint(
              'fetchSellerProfile: Uyarı - satici_profili alanı bulunamadı veya null',
            );
            debugPrint(
              'fetchSellerProfile: JSON keys: ${jsonData.keys.toList()}',
            );
          }
        }

        // User.fromJson içinde satici_profili zaten SellerProfil.fromJson ile parse ediliyor
        return User.fromJson(jsonData);
      } catch (e) {
        debugPrint('fetchSellerProfile: JSON parse hatası: $e');
        debugPrint(
          'fetchSellerProfile: Response body (ilk 500 karakter): ${bodyText.length > 500 ? bodyText.substring(0, 500) : bodyText}',
        );
        throw Exception(
          'Seller profil verisi parse edilemedi. Durum kodu: ${response.statusCode}, Hata: $e',
        );
      }
    } else {
      debugPrint(
        'fetchSellerProfile: HTTP hatası. Status: ${response.statusCode}',
      );
      debugPrint(
        'fetchSellerProfile: Response body (ilk 200 karakter): ${bodyText.length > 200 ? bodyText.substring(0, 200) : bodyText}',
      );
      throw Exception(
        'Seller profil verisi alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  /// API'den Product verisini çekmek için metot.
  static Future<List<Product>> fetchProducts({String? id}) async {
    // HTTP GET isteği gönderilirken header'a API key eklenir.
    final response = await _deps.httpClient.get(
      Uri.parse(
        id == null ? config.productsApiUrl : '${config.productsApiUrl}$id/',
      ),
      headers: {
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(
        utf8.decode(response.bodyBytes),
      );

      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception(
        'Ürünler verisi alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  static Future<List<Category>> fetchCategories() async {
    final response = await _deps.httpClient.get(
      Uri.parse(config.categoriesApiUrl),
      headers: {
        'X-API-Key': config.apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Allow': 'Get',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception(
        'Category verisi alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  /// API'den Product verisini çekmek için metot.
  static Future<List<Product>> fetchPopulerProducts() async {
    // HTTP GET isteği gönderilirken header'a API key eklenir.
    final response = await _deps.httpClient.get(
      Uri.parse(config.populerProductsApiUrl),
      headers: {
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(
        utf8.decode(response.bodyBytes),
      );

      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception(
        'Popüler Ürünler verisi alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  /// API'den Product verisini çekmek için metot.
  static Future<Product> fetchProduct(int? id) async {
    // HTTP GET isteği gönderilirken header'a API key eklenir.
    final response = await _deps.httpClient.get(
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
        'Ürün verisi alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  /// API'den Ürün Yorumlarını çekmek için metot.
  static Future<List<UrunYorum>> fetchUrunYorumlara({int? urunId}) async {
    // Eğer urunId verilmişse, ilgili ürünün yorumlarını çek.
    final url = urunId == null
        ? config.urunYorumApiUrl
        : '${config.urunYorumApiUrl}?urun=$urunId';

    final response = await _deps.httpClient.get(
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
        'Ürün yorumları alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  /// API'den Ürün Yorumlarını çekmek için metot.
  static Future<UrunYorumlarResponse> takeCommentsForProduct({
    int? urunId,
  }) async {
    final accessToken = await getAccessToken();
    // Eğer urunId verilmişse, ilgili ürünün yorumlarını çek.

    final response = await _deps.httpClient.post(
      Uri.parse(config.productsCommentsApiUrl),
      body: json.encode({'urun_id': urunId}),
      headers: {
        'X-API-Key': config.apiKey,
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Allow': 'Post',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(
        utf8.decode(response.bodyBytes),
      );
      return UrunYorumlarResponse.fromJson(data);
    } else {
      throw Exception(
        'Ürün yorumları alınamadı. Durum kodu:  ${response.statusCode} ${response.body}',
      );
    }
  }

  static Future<void> fetchUserRegister(
    String email,
    String userName,
    String password,
  ) async {
    http.Response response;
    try {
      response = await _deps.httpClient.post(
        Uri.parse(config.userRqRegisterApiUrl),
        body: json.encode({
          'email': email,
          'username': userName,
          'password': password,
          'rol': 'alici',
        }),
        headers: {
          'X-API-Key': config.apiKey,
          'Content-Type': 'application/json',
          'Allow': 'Post',
        },
      );
    } catch (e) {
      debugPrint('fetchUserRegister isteği başarısız: $e');
      rethrow;
    }

    final bodyText = utf8.decode(response.bodyBytes);
    Map<String, dynamic>? jsonData;
    if (bodyText.isNotEmpty) {
      try {
        final decoded = json.decode(bodyText);
        if (decoded is Map<String, dynamic>) {
          jsonData = decoded;
        }
      } catch (e) {
        debugPrint('fetchUserRegister JSON parse hatası: $e');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (jsonData?['tokens'] is Map) {
        final tokens = jsonData!['tokens'] as Map;
        final accessToken = tokens['access']?.toString() ?? '';
        final refreshToken = tokens['refresh']?.toString() ?? '';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accesToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
      }
      return;
    }

    if (jsonData != null) {
      if (jsonData['errors'] != null) {
        throw Exception(json.encode(jsonData['errors']));
      }
      throw Exception(json.encode(jsonData));
    }

    throw Exception(
      bodyText.isNotEmpty ? bodyText : 'Kullanıcı kaydı başarısız.',
    );
  }

  static Future fetchUserLogin(String email, String password) async {
    final response = await _deps.httpClient.post(
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
      final errorMessage = jsonData != null
          ? (jsonData['message'] ?? 'Kullanıcı kaydı başarısız.')
          : response.body;
      throw Exception('$errorMessage');
    }
  }

  static Future<User> fetchUserMe() async {
    final accessToken = await getAccessToken();
    final response = await _deps.httpClient.get(
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
        'Kullanıcı me bilgisi alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  static Future<String> fetchUserLogout() async {
    final refreshToken = await getRefreshToken();
    debugPrint('refreshToken: $refreshToken');
    http.Response response;
    try {
      response = await _deps.httpClient.post(
        Uri.parse(config.userLogoutApiUrl),
        body: json.encode({'refresh_token': refreshToken}),
        headers: {
          'X-API-Key': config.apiKey,
          'Content-Type': 'application/json',
          'Allow': 'Post',
        },
      );
    } catch (e) {
      debugPrint('fetchUserLogout isteği başarısız: $e');
      rethrow;
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accesToken');
      await prefs.remove('refreshToken');
    }

    final bodyText = utf8.decode(response.bodyBytes);
    Map<String, dynamic>? jsonData;

    if (bodyText.isNotEmpty) {
      try {
        final decoded = json.decode(bodyText);
        if (decoded is Map<String, dynamic>) {
          jsonData = decoded;
        }
      } catch (e) {
        debugPrint('fetchUserLogout JSON parse hatası: $e');
      }
    }

    if (response.statusCode == 200) {
      if (jsonData != null) {
        if (jsonData['status'] == 'success') {
          return (jsonData['message'] as String?) ?? 'Başarıyla çıkış yapıldı.';
        }
        return jsonData['message']?.toString() ?? 'Başarıyla çıkış yapıldı.';
      }
      return bodyText.isNotEmpty ? bodyText : 'Başarıyla çıkış yapıldı.';
    }

    final errorMessage = jsonData != null
        ? jsonData['message'] ?? jsonData['detail'] ?? jsonData.toString()
        : (bodyText.isNotEmpty ? bodyText : 'Çıkış işlemi başarısız.');
    throw Exception(errorMessage);
  }

  static Future fetchSepetEkle(int? miktar, int urunId) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final response = await _deps.httpClient.post(
      Uri.parse(config.sepetEkleApiUrl),
      body: json.encode({'miktar': miktar ?? 0, 'urun_id': urunId}),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
        'Allow': 'Post',
      },
    );
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        // Başarılı, body yoksa hata fırlatma
        return {};
      }
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      if (jsonData is Map &&
          (jsonData['status'] == null || jsonData['status'] == 'success')) {
        return jsonData;
      } else {
        throw Exception(
          'Sepete ekleme başarısız: Durum kodu: ${response.statusCode} \n${jsonData['detail'] ?? 'Bilinmeyen hata'}',
        );
      }
    } else {
      throw Exception(
        'Sepete ekleme başarısız. Durum kodu: ${response.statusCode} \n${response.body}',
      );
    }
  }

  static Future<Map<String, dynamic>> fetchSepetGet() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final response = await _deps.httpClient.get(
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
            'mesaj': jsonData['mesaj'] ?? 'Sepetinizde ürün bulunmamaktadır.',
          };
        } else {
          throw Exception('Bilinmeyen sepet durumu: ${jsonData['durum']}');
        }
      } else {
        throw Exception('Sepet verisi alınamadı: Beklenen formatta değil.');
      }
    } else {
      // Hata kontrolü burada
      if (response.statusCode == 401 && response.body.isNotEmpty) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        if (jsonData is Map<String, dynamic> &&
            jsonData['code'] == 'user_not_found') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('accesToken');
          await prefs.remove('refreshToken');
        } else if (jsonData is Map<String, dynamic> &&
            jsonData['code'] == 'token_not_valid') {
          throw Exception('Unauthorized');
        }
      }
      throw Exception(
        'Sepet verisi alınamadı. Durum kodu: ${response.statusCode} \n${response.body}',
      );
    }
  }

  static Future<Map<String, dynamic>> fetchSepetInfo() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.get(
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
            'mesaj': jsonData['mesaj'] ?? 'Sepetinizde ürün bulunmamaktadır.',
          };
        } else {
          throw Exception('Bilinmeyen sepet durumu: ${jsonData['durum']}');
        }
      } else {
        throw Exception('Sepet bilgisi alınamadı: Beklenen formatta değil.');
      }
    } else {
      throw Exception(
        'Sepet bilgisi alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  static Future<dynamic> fetchUserFavorites(
    int? id,
    int? userID,
    int? urunID,
    int? deleteID,
  ) async {
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
    http.Response response;
    if (deleteID != null) {
      // Sadece deleteID varsa DELETE işlemi
      try {
        response = await _deps.httpClient.delete(
          Uri.parse('${url}$deleteID/'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'X-API-Key': config.apiKey,
            'Content-Type': 'application/json',
          },
        );
      } catch (e) {
        debugPrint('JSON parse hatası: $e');
        rethrow;
        //throw Exception('Favori ürünler alınamadı. Durum kodu: $e');
      }
      if ((response.statusCode == 204 || response.statusCode == 200)) {
        return [];
      } else {
        throw Exception(
          'Favori ürün silinemedi. Durum kodu: ${response.statusCode}',
        );
      }
    } else if (userID != null && urunID != null) {
      if (userID == 0 || urunID == 0) {
        throw Exception('Kullanıcı veya ürün ID\'si eksik veya geçersiz!');
      }
      final body = {'alici': userID, 'urun': urunID};
      try {
        response = await _deps.httpClient.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'X-API-Key': config.apiKey,
            'Content-Type': 'application/json',
          },
          body: json.encode(body),
        );
      } catch (e) {
        debugPrint('JSON parse hatası: $e');
        rethrow;
        //throw Exception('Favori ürünler alınamadı. Durum kodu: $e');
      }
      if (response.statusCode == 201 && response.body.isNotEmpty) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return jsonData; // Map dönebilir
      } else {
        throw Exception(
          'Favori ürünler alınamadı. Durum kodu: ${response.statusCode}',
        );
      }
    } else if (userID == null && urunID == null) {
      final response = await _deps.httpClient.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'X-API-Key': config.apiKey,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return jsonData; // List dönebilir
      } else {
        throw Exception(
          'Favori ürünler alınamadı. Durum kodu: ${response.statusCode}',
        );
      }
    } else {
      return [
        'userID ve urunID birlikte dolu olmalı veya birlikte null olmalı.',
      ];
    }
  }

  static Future<List<UserAdress>> fetchUserAdress({int? userID = null}) async {
    final accessToken = await getAccessToken();

    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final baseUrl = config.userAdressApiUrl;
    if (baseUrl.isEmpty) {
      throw Exception(
        'API yapılandırmasında "userAdressApiUrl" bulunmuyor. .env yüklenmiş mi?',
      );
    }

    Uri uri;
    try {
      final parsed = Uri.parse(baseUrl);
      if (userID == null) {
        uri = parsed;
      } else {
        // Merge existing query parameters (if any) with kullanici_id
        final newQuery = Map<String, String>.from(parsed.queryParameters);
        newQuery['kullanici_id'] = userID.toString();
        uri = parsed.replace(queryParameters: newQuery);
      }
    } catch (e) {
      debugPrint('JSON parse hatası: $e');
      rethrow;
      //throw Exception('Geçersiz kullanıcı adresi URLsi: $baseUrl');
    }

    final response = await _deps.httpClient.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );

    // Eğer status 401 veya yönlendirme varsa token/kimlik problemi olabilir
    if (response.statusCode == 401) {
      throw Exception(
        'Yetkilendirme hatası (401). Lütfen yeniden giriş yapın.',
      );
    }

    // Eğer içerik tipi JSON değilse, büyük olasılıkla HTML dönüyordur -> hata ver
    final contentType = response.headers.entries
        .firstWhere(
          (e) => e.key.toLowerCase() == 'content-type',
          orElse: () => MapEntry('', ''),
        )
        .value
        .toLowerCase();

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      if (!contentType.contains('application/json')) {
        // Kısa bir önizleme verelim (maks 500 karakter) — çok büyük olmasın
        final preview = response.body.length > 500
            ? response.body.substring(0, 500)
            : response.body;
        throw Exception(
          'API JSON dönmedi. Status: ${response.statusCode}. Cevap önizlemesi:\n$preview',
        );
      }

      try {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        if (jsonData is List) {
          return jsonData
              .map((e) => UserAdress.fromJson(e as Map<String, dynamic>))
              .toList();
        } else if (jsonData is Map &&
            jsonData.containsKey('results') &&
            jsonData['results'] is List) {
          // Bazı API tasarımlarında paged response olabilir
          return (jsonData['results'] as List)
              .map((e) => UserAdress.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(
            'API beklenen formatta liste dönmedi. Gelen tip: ${jsonData.runtimeType}',
          );
        }
      } catch (e) {
        debugPrint('JSON parse hatası: $e');
        rethrow;
        //throw Exception('JSON parse hatası: $e');
      }
    } else {
      final preview = response.body.length > 500
          ? response.body.substring(0, 500)
          : response.body;
      throw Exception(
        'Adresler alınamadı. Durum kodu: ${response.statusCode}. Cevap önizlemesi:\n$preview',
      );
    }
  }

  static Future<Map<String, dynamic>> postUserAdress(
    String ulke,
    String il,
    String ilce,
    String mahalle,
    String postaKodu,
    String adresSatiri1,
    String adresSatiri2,
    String baslik,
    String adresTipi,
    bool? varsayilanAdres,
    int kullanici,
  ) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.post(
      Uri.parse(config.userAdressApiUrl),
      body: json.encode({
        'ulke': ulke,
        'il': il,
        'ilce': ilce,
        'mahalle': mahalle,
        'posta_kodu': postaKodu,
        'adres_satiri_1': adresSatiri1,
        'adres_satiri_2': adresSatiri2,
        'baslik': baslik,
        'adres_tipi': adresTipi,
        'varsayilan_adres': varsayilanAdres ?? false,
        'kullanici': kullanici,
      }),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return jsonData as Map<String, dynamic>;
      } else {
        return {};
      }
    } else {
      throw Exception(
        'Adresler alınamadı. Durum kodu: \\${response.statusCode}',
      );
    }
  }

  static Future<Map<String, dynamic>> deleteUserAdress(int id) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.delete(
      Uri.parse('${config.userAdressApiUrl}$id/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 204) {
      return {};
    } else {
      throw Exception(
        'Adres silinirken bir hata oluştu. Durum kodu: \\${response.statusCode}',
      );
    }
  }

  static Future<UserAdress> fetchUserAdressById(int id) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.get(
      Uri.parse('${config.userAdressApiUrl}$id/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      return UserAdress.fromJson(jsonData as Map<String, dynamic>);
    } else {
      throw Exception(
        'Adres bilgisi alınamadı. Durum kodu: \\${response.statusCode}',
      );
    }
  }

  static Future<Map<String, dynamic>> updateUserAdress(
    int id,
    String ulke,
    String il,
    String ilce,
    String mahalle,
    String postaKodu,
    String adresSatiri1,
    String adresSatiri2,
    String baslik,
    String adresTipi,
    bool? varsayilanAdres,
    int kullanici,
  ) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.patch(
      Uri.parse('${config.userAdressApiUrl}$id/'),
      body: json.encode({
        'ulke': ulke,
        'il': il,
        'ilce': ilce,
        'mahalle': mahalle,
        'posta_kodu': postaKodu,
        'adres_satiri_1': adresSatiri1,
        'adres_satiri_2': adresSatiri2,
        'baslik': baslik,
        'adres_tipi': adresTipi,
      }),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return jsonData as Map<String, dynamic>;
      } else {
        return {};
      }
    } else {
      throw Exception(
        'Adres güncellenirken bir hata oluştu. Durum kodu: \\${response.statusCode}',
      );
    }
  }

  static Future<List<dynamic>> fetchUserFollow() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.get(
      Uri.parse(config.userFollowApiUrl),
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
        'Takip edilenler alınamadı. Durum kodu: \\${response.statusCode}',
      );
    }
  }

  static Future<Map<String, dynamic>> postUserFollow(
    int sellerID,
    int userID,
  ) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.post(
      Uri.parse(config.userFollowApiUrl),
      body: json.encode({'satici': sellerID, 'kullanici': userID}),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData as Map<String, dynamic>;
    } else {
      throw Exception(
        'Takip Ederken bir hata oluştu. Durum kodu: \\${response.statusCode}',
      );
    }
  }

  static Future<Map<String, dynamic>> deleteUserFollow(int id) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.delete(
      Uri.parse('${config.userFollowApiUrl}$id/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 204) {
      // 204 No Content: Başarılı, body yok
      return {};
    } else if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData as Map<String, dynamic>;
    } else {
      throw Exception(
        'Takipten çıkarken bir hata oluştu. Durum kodu: ${response.statusCode}',
      );
    }
  }

  static Future<List<dynamic>> fetchUserCoupons() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.get(
      Uri.parse(config.userCouponsApiUrl),
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
      throw Exception('Kuponlar alınamadı. Durum kodu: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchProductsComments(
    int? kullaniciID,
    int? magazaID,
  ) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    String url;
    if (kullaniciID != null) {
      url = '${config.urunYorumApiUrl}?kullanici_id=$kullaniciID';
    } else if (magazaID != null) {
      url = '${config.urunYorumApiUrl}?magaza_id=$magazaID';
    } else {
      url = config.urunYorumApiUrl;
    }
    final response = await _deps.httpClient.get(
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
      throw Exception('Yorumlar alınamadı. Durum kodu: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchSellersComments(
    int? kullaniciID,
    int? magazaID,
  ) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    String url;
    if (kullaniciID != null) {
      url = '${config.urunYorumApiUrl}?kullanici_id=$kullaniciID';
    } else if (magazaID != null) {
      url = '${config.urunYorumApiUrl}?magaza_id=$magazaID';
    } else {
      url = config.urunYorumApiUrl;
    }
    final response = await _deps.httpClient.get(
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
      throw Exception('Yorumlar alınamadı. Durum kodu: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchLogisticOrder(int? aliciID) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final response = await _deps.httpClient.get(
      Uri.parse(config.logisticOrderApiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      if (decoded is List) {
        return decoded;
      } else if (decoded is Map<String, dynamic>) {
        if (decoded['results'] is List) {
          return (decoded['results'] as List);
        }
        return [decoded];
      } else {
        return [];
      }
    } else {
      throw Exception(
        'Kargo bilgileri alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  static Future<Map<String, dynamic>> postTriggerPayment(
    Map<String, dynamic> paymentPayload,
  ) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final String url = config.paymentTriggerApiUrl.isNotEmpty
        ? config.paymentTriggerApiUrl
        : 'https://imecehub.com/api/payment/siparisitem/trigger-payment/';

    http.Response response;
    try {
      response = await _deps.httpClient.post(
        Uri.parse(url),
        body: json.encode(paymentPayload),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'X-API-Key': config.apiKey,
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      debugPrint('JSON parse hatası: $e');
      rethrow;
      //throw Exception('Ödeme isteği gönderilemedi: $e');
    }

    final String contentType =
        response.headers['content-type']?.toLowerCase() ?? '';
    final String bodyText = utf8.decode(response.bodyBytes);

    Map<String, dynamic>? jsonData;
    if (contentType.contains('application/json')) {
      try {
        final decoded = json.decode(bodyText);
        if (decoded is Map<String, dynamic>) {
          jsonData = decoded;
        }
      } catch (e) {
        debugPrint('JSON parse hatası: $e');
        rethrow;
        //throw Exception('Ödeme cevabı JSON parse hatası: $e');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonData ?? {'raw': bodyText};
    } else {
      if (jsonData != null) {
        throw Exception(json.encode(jsonData));
      } else {
        throw Exception(
          bodyText.isNotEmpty
              ? bodyText
              : 'Ödeme başarısız. Durum kodu: ${response.statusCode}',
        );
      }
    }
  }

  static Future<Campaigns> fetchProductsCampaings() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.get(
      Uri.parse(config.productsCampaingsApiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final dynamic jsonData = json.decode(utf8.decode(response.bodyBytes));
      if (jsonData is Map<String, dynamic>) {
        return Campaigns.fromJson(jsonData);
      } else {
        throw Exception(
          'Kampanyalar beklenen formatta değil: ${jsonData.runtimeType}',
        );
      }
    } else {
      throw Exception(
        'Kampanyalar alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  // Hikayeler için placeholder; API netleşene kadar boş liste döndürür
  static Future<Stories> fetchCampaignsStories() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.get(
      Uri.parse(config.productsCampaignsStoriesApiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      if (jsonData is Map<String, dynamic>) {
        return Stories.fromJson(jsonData);
      } else {
        throw Exception('Hikayeler beklenen formatta değil');
      }
    } else {
      throw Exception(
        'Hikayeler alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  static Future<Stories> fetchStories() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.get(
      Uri.parse(config.productsStoriesApiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      if (jsonData is Map<String, dynamic>) {
        return Stories.fromJson(jsonData);
      } else {
        throw Exception('Hikayeler beklenen formatta değil');
      }
    } else {
      throw Exception(
        'Hikayeler alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  static Future<List<dynamic>> fetchUserGroups() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await _deps.httpClient.get(
      Uri.parse(config.userGroupsApiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      if (decoded is List) {
        return decoded;
      } else if (decoded is Map<String, dynamic>) {
        // Yaygın liste alanlarını kontrol et
        final dynamic maybeList =
            decoded['results'] ??
            decoded['data'] ??
            decoded['items'] ??
            decoded['groups'];
        if (maybeList is List) {
          return maybeList;
        }
        // Liste bulunamazsa tek öğe olarak sar
        return [decoded];
      } else {
        // Beklenmeyen tip; stringe çevirip tek öğe olarak döndür
        return [decoded.toString()];
      }
    } else {
      throw Exception(
        'Kullanıcı grupları alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  static Future<Map<String, dynamic>> fetchPaymentSiparisOnayla({
    required int teslimatAdresId,
    required int faturaAdresId,
  }) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    // URL boşsa fallback kullan
    final String url = config.paymentSiparisApiUrl.isNotEmpty
        ? config.paymentSiparisApiUrl
        : 'https://imecehub.com/api/payment/siparisitem/siparisi-onayla/';

    http.Response response;
    try {
      response = await _deps.httpClient
          .post(
            Uri.parse(url),
            body: json.encode({
              'teslimat_adres_id': teslimatAdresId,
              'fatura_adres_id': faturaAdresId,
            }),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'X-API-Key': config.apiKey,
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw Exception(
        'İstek zaman aşımına uğradı (10s). Lütfen tekrar deneyin.',
      );
    } catch (e) {
      debugPrint('JSON parse hatası: $e');
      rethrow;
      //throw Exception('Sipariş onay isteği gönderilemedi: $e');
    }

    final String contentType =
        response.headers['content-type']?.toLowerCase() ?? '';
    final String bodyText = utf8.decode(response.bodyBytes);

    Map<String, dynamic>? jsonData;
    if (contentType.contains('application/json')) {
      try {
        final decoded = json.decode(bodyText);
        if (decoded is Map<String, dynamic>) {
          jsonData = decoded;
        }
      } catch (e) {
        debugPrint('JSON parse hatası: $e');
        rethrow;
        //throw Exception('Cevap JSON parse hatası: $e');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonData ?? {'raw': bodyText};
    } else {
      if (jsonData != null) {
        throw Exception(json.encode(jsonData));
      } else {
        throw Exception(
          bodyText.isNotEmpty
              ? bodyText
              : 'Sipariş onay başarısız. Durum kodu: ${response.statusCode}',
        );
      }
    }
  }

  static Future<List<SellerProducts>> fetchSellerProducts(int? id) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final String sellerProductsUrl = (config.sellerProductsApiUrl.isNotEmpty)
        ? config.sellerProductsApiUrl
        : 'https://imecehub.com/users/seller-products/';
    final response = await _deps.httpClient.post(
      Uri.parse(sellerProductsUrl),
      body: json.encode({'kullanici_id': id}),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final dynamic jsonData = json.decode(utf8.decode(response.bodyBytes));
      if (jsonData is List) {
        return jsonData
            .map((e) => SellerProducts.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (jsonData is Map && jsonData['results'] is List) {
        return (jsonData['results'] as List)
            .map((e) => SellerProducts.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Beklenmeyen yanıt formatı: ${jsonData.runtimeType}');
      }
    } else {
      throw Exception('Ürünler alınamadı. Durum kodu: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> postSellerAddProduct(
    Map<String, dynamic> productPayload,
  ) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final uri = Uri.parse(config.sellerAddProductApiUrl);
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
      });

    productPayload.forEach((key, value) {
      if (value == null) return;

      if (value is http.MultipartFile) {
        request.files.add(value);
      } else if (value is List<http.MultipartFile>) {
        request.files.addAll(value);
      } else if (value is List) {
        for (final item in value) {
          if (item == null) continue;
          request.fields[key] = item.toString();
        }
      } else {
        request.fields[key] = value.toString();
      }
    });

    http.StreamedResponse streamedResponse;
    try {
      streamedResponse = await _deps.httpClient.send(request);
    } catch (e) {
      debugPrint('postSellerAddProduct isteği başarısız: $e');
      rethrow;
    }

    final response = await http.Response.fromStream(streamedResponse);
    final bodyText = utf8.decode(response.bodyBytes);

    Map<String, dynamic>? jsonData;
    if (bodyText.isNotEmpty) {
      try {
        final decoded = json.decode(bodyText);
        if (decoded is Map<String, dynamic>) {
          jsonData = decoded;
        }
      } catch (e) {
        debugPrint('postSellerAddProduct JSON parse hatası: $e');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonData ?? {'raw': bodyText};
    }

    final errorMessage =
        jsonData?['message'] ??
        jsonData?['detail'] ??
        jsonData?.toString() ??
        (bodyText.isNotEmpty ? bodyText : 'Ürün ekleme başarısız.');
    throw Exception(errorMessage);
  }

  static Future<Map<String, dynamic>> putSellerUpdateProduct(
    int productId,
    Map<String, dynamic> productPayload,
  ) async {
    debugPrint(
      'putSellerUpdateProduct: Başlatılıyor - productId: $productId, payload keys: ${productPayload.keys.toList()}',
    );
    debugPrint(
      'putSellerUpdateProduct: productPayload: ${productPayload.toString()}',
    );

    // Update işlemi için field isimlerini API formatına dönüştür
    final Map<String, dynamic> mappedPayload = {};
    productPayload.forEach((key, value) {
      String mappedKey = key;

      // Field isimlerini dönüştür
      if (key == 'satici_id') {
        mappedKey = 'satici';
      } else if (key == 'stok_miktari') {
        mappedKey = 'stok_durumu';
      } else if (key == 'urun_aciklama') {
        mappedKey = 'aciklama';
      }
      // Diğer field'lar aynı kalacak (urun_adi, urun_perakende_fiyati, vb.)

      mappedPayload[mappedKey] = value;
    });

    // Zorunlu alanları kontrol et ve ekle
    if (!mappedPayload.containsKey('urun_adi') ||
        mappedPayload['urun_adi'] == null ||
        mappedPayload['urun_adi'].toString().isEmpty) {
      throw Exception('urun_adi alanı zorunludur.');
    }
    if (!mappedPayload.containsKey('aciklama') ||
        mappedPayload['aciklama'] == null ||
        mappedPayload['aciklama'].toString().isEmpty) {
      throw Exception('aciklama alanı zorunludur.');
    }
    if (!mappedPayload.containsKey('stok_durumu') ||
        mappedPayload['stok_durumu'] == null) {
      throw Exception('stok_durumu alanı zorunludur.');
    }
    if (!mappedPayload.containsKey('satici') ||
        mappedPayload['satici'] == null) {
      throw Exception('satici alanı zorunludur.');
    }
    // degerlendirme_puani kontrolü ve dönüşümü
    if (!mappedPayload.containsKey('degerlendirme_puani') ||
        mappedPayload['degerlendirme_puani'] == null) {
      // Eğer degerlendirme_puani yoksa, 0.0 ver
      mappedPayload['degerlendirme_puani'] = 0.0;
    } else {
      // String olarak "0,0" veya "0.0" geliyorsa, double'a çevir
      if (mappedPayload['degerlendirme_puani'] is String) {
        final strValue = mappedPayload['degerlendirme_puani']
            .toString()
            .replaceAll(',', '.');
        mappedPayload['degerlendirme_puani'] = double.tryParse(strValue) ?? 0.0;
      } else if (mappedPayload['degerlendirme_puani'] is! num) {
        // Sayı değilse 0.0 yap
        mappedPayload['degerlendirme_puani'] = 0.0;
      }
    }

    debugPrint(
      'putSellerUpdateProduct: Mapped payload keys: ${mappedPayload.keys.toList()}',
    );
    debugPrint(
      'putSellerUpdateProduct: Mapped payload: ${mappedPayload.toString()}',
    );

    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      debugPrint('putSellerUpdateProduct: HATA - Access token boş!');
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    // URL oluştur - eğer config'de yoksa fallback kullan
    final String baseUrl = config.productsApiUrl.isNotEmpty
        ? config.productsApiUrl
        : config.productsApiUrl;
    final String updateUrl = baseUrl.endsWith('/')
        ? '$baseUrl$productId/'
        : '$baseUrl/$productId/';

    debugPrint('putSellerUpdateProduct: URL oluşturuldu - $updateUrl');

    // Dosya alanlarını kontrol et (lab_sonuc_pdf, urun_sertifika_pdf, kapak_gorseli)
    final hasFiles = mappedPayload.entries.any((entry) {
      final value = entry.value;
      return value is http.MultipartFile || value is List<http.MultipartFile>;
    });

    debugPrint('putSellerUpdateProduct: Dosya kontrolü - hasFiles: $hasFiles');

    // Eğer dosya varsa multipart request kullan
    if (hasFiles) {
      final uri = Uri.parse(updateUrl);
      final request = http.MultipartRequest('PUT', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $accessToken',
          'X-API-Key': config.apiKey,
        });

      mappedPayload.forEach((key, value) {
        if (value == null) return;

        if (value is http.MultipartFile) {
          request.files.add(value);
        } else if (value is List<http.MultipartFile>) {
          request.files.addAll(value);
        } else if (value is List) {
          for (final item in value) {
            if (item == null) continue;
            request.fields[key] = item.toString();
          }
        } else {
          request.fields[key] = value.toString();
        }
      });

      http.StreamedResponse streamedResponse;
      try {
        debugPrint(
          'putSellerUpdateProduct: Multipart PUT isteği gönderiliyor - URL: $updateUrl, files: ${request.files.length}, fields: ${request.fields.keys.toList()}',
        );
        streamedResponse = await _deps.httpClient.send(request);
        debugPrint(
          'putSellerUpdateProduct: Multipart istek gönderildi - Status: ${streamedResponse.statusCode}',
        );
      } catch (e, stackTrace) {
        debugPrint(
          'putSellerUpdateProduct: Multipart istek gönderilirken hata oluştu - Hata: $e',
        );
        debugPrint('putSellerUpdateProduct: Stack trace: $stackTrace');
        rethrow;
      }

      final response = await http.Response.fromStream(streamedResponse);
      final bodyText = utf8.decode(response.bodyBytes);

      debugPrint(
        'putSellerUpdateProduct: Response alındı - Status: ${response.statusCode}, Body length: ${bodyText.length}',
      );

      Map<String, dynamic>? jsonData;
      if (bodyText.isNotEmpty) {
        try {
          final decoded = json.decode(bodyText);
          if (decoded is Map<String, dynamic>) {
            jsonData = decoded;
            debugPrint('putSellerUpdateProduct: JSON parse başarılı');
          } else {
            debugPrint(
              'putSellerUpdateProduct: JSON parse uyarısı - Beklenen Map<String, dynamic>, alınan: ${decoded.runtimeType}',
            );
          }
        } catch (e, stackTrace) {
          debugPrint(
            'putSellerUpdateProduct: JSON parse hatası - Hata: $e, Body: ${bodyText.length > 500 ? bodyText.substring(0, 500) + "..." : bodyText}',
          );
          debugPrint('putSellerUpdateProduct: Stack trace: $stackTrace');
        }
      } else {
        debugPrint('putSellerUpdateProduct: Response body boş');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint(
          'putSellerUpdateProduct: Başarılı - Status: ${response.statusCode}',
        );
        return jsonData ?? {'raw': bodyText};
      }

      debugPrint(
        'putSellerUpdateProduct: HATA - Status: ${response.statusCode}, Body: ${bodyText.length > 500 ? bodyText.substring(0, 500) + "..." : bodyText}',
      );

      final errorMessage =
          jsonData?['message'] ??
          jsonData?['detail'] ??
          jsonData?.toString() ??
          (bodyText.isNotEmpty ? bodyText : 'Ürün güncelleme başarısız.');

      debugPrint('putSellerUpdateProduct: Hata mesajı: $errorMessage');
      throw Exception(errorMessage);
    } else {
      // Dosya yoksa normal JSON request
      try {
        final jsonBody = json.encode(mappedPayload);
        debugPrint(
          'putSellerUpdateProduct: JSON PUT isteği gönderiliyor - URL: $updateUrl, Body length: ${jsonBody.length}',
        );

        final response = await _deps.httpClient.put(
          Uri.parse(updateUrl),
          body: jsonBody,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'X-API-Key': config.apiKey,
            'Content-Type': 'application/json',
          },
        );

        final bodyText = utf8.decode(response.bodyBytes);

        debugPrint(
          'putSellerUpdateProduct: JSON Response alındı - Status: ${response.statusCode}, Body length: ${bodyText.length}',
        );

        Map<String, dynamic>? jsonData;

        if (bodyText.isNotEmpty) {
          try {
            final decoded = json.decode(bodyText);
            if (decoded is Map<String, dynamic>) {
              jsonData = decoded;
              debugPrint('putSellerUpdateProduct: JSON parse başarılı');
            } else {
              debugPrint(
                'putSellerUpdateProduct: JSON parse uyarısı - Beklenen Map<String, dynamic>, alınan: ${decoded.runtimeType}',
              );
            }
          } catch (e, stackTrace) {
            debugPrint(
              'putSellerUpdateProduct: JSON parse hatası - Hata: $e, Body: ${bodyText.length > 500 ? bodyText.substring(0, 500) + "..." : bodyText}',
            );
            debugPrint('putSellerUpdateProduct: Stack trace: $stackTrace');
          }
        } else {
          debugPrint('putSellerUpdateProduct: Response body boş');
        }

        if (response.statusCode >= 200 && response.statusCode < 300) {
          debugPrint(
            'putSellerUpdateProduct: Başarılı - Status: ${response.statusCode}',
          );
          return jsonData ?? {'raw': bodyText};
        }

        debugPrint(
          'putSellerUpdateProduct: HATA - Status: ${response.statusCode}, Body: ${bodyText.length > 500 ? bodyText.substring(0, 500) + "..." : bodyText}',
        );

        final errorMessage =
            jsonData?['message'] ??
            jsonData?['detail'] ??
            jsonData?.toString() ??
            (bodyText.isNotEmpty ? bodyText : 'Ürün güncelleme başarısız.');

        debugPrint('putSellerUpdateProduct: Hata mesajı: $errorMessage');
        throw Exception(errorMessage);
      } catch (e, stackTrace) {
        if (e is Exception) {
          rethrow;
        }
        debugPrint(
          'putSellerUpdateProduct: JSON istek gönderilirken beklenmeyen hata - Hata: $e',
        );
        debugPrint('putSellerUpdateProduct: Stack trace: $stackTrace');
        throw Exception('Ürün güncelleme sırasında bir hata oluştu: $e');
      }
    }
  }

  static Future<Map<String, dynamic>> postStories(
    Map<String, dynamic> payload, {
    required bool isStories,
  }) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final uri = Uri.parse(
      isStories ? config.productsStoriesApiUrl : config.productsCampaingsApiUrl,
    );
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
      });

    payload.forEach((key, value) {
      if (value == null) return;

      if (value is http.MultipartFile) {
        request.files.add(value);
      } else if (value is List<http.MultipartFile>) {
        request.files.addAll(value);
      } else if (value is List) {
        for (final item in value) {
          if (item == null) continue;
          request.fields[key] = item.toString();
        }
      } else {
        request.fields[key] = value.toString();
      }
    });

    http.StreamedResponse streamedResponse;
    try {
      streamedResponse = await _deps.httpClient.send(request);
    } catch (e) {
      debugPrint('postStories isteği başarısız: $e');
      rethrow;
    }

    final response = await http.Response.fromStream(streamedResponse);
    final bodyText = utf8.decode(response.bodyBytes);

    Map<String, dynamic>? jsonData;
    if (bodyText.isNotEmpty) {
      try {
        final decoded = json.decode(bodyText);
        if (decoded is Map<String, dynamic>) {
          jsonData = decoded;
        }
      } catch (e) {
        debugPrint('postStories JSON parse hatası: $e');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonData ?? {'raw': bodyText};
    }

    final errorMessage =
        jsonData?['message'] ??
        jsonData?['detail'] ??
        jsonData?.toString() ??
        (bodyText.isNotEmpty ? bodyText : 'Hikaye gönderimi başarısız.');
    debugPrint(
      'postStories hata: status=${response.statusCode}, body=$bodyText, error=$errorMessage',
    );
    throw Exception(errorMessage);
  }

  /// Alıcı profilini günceller (PATCH)
  /// Güncellenebilen alanlar:
  /// - Kullanıcı: first_name, last_name, telno, profil_fotograf, is_online
  /// - Alıcı: cinsiyet, adres
  static Future<Map<String, dynamic>> putBuyerUpdate(
    Map<String, dynamic> userPayload,
  ) async {
    debugPrint(
      'putBuyerUpdate: Başlatılıyor - payload keys: ${userPayload.keys.toList()}',
    );
    debugPrint('putBuyerUpdate: userPayload: ${userPayload.toString()}');

    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      debugPrint('putBuyerUpdate: HATA - Access token boş!');
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final uri = Uri.parse(config.buyerUpdateApiUrl);
    debugPrint('putBuyerUpdate: URL oluşturuldu - $uri');

    // Dosya alanlarını kontrol et (profil_fotograf)
    final hasFiles = userPayload.entries.any((entry) {
      final value = entry.value;
      return value is http.MultipartFile || value is List<http.MultipartFile>;
    });

    debugPrint('putBuyerUpdate: Dosya kontrolü - hasFiles: $hasFiles');

    // Eğer dosya varsa multipart request kullan
    if (hasFiles) {
      final request = http.MultipartRequest('PUT', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $accessToken',
          'X-API-Key': config.apiKey,
        });

      userPayload.forEach((key, value) {
        if (value == null) return;

        if (value is http.MultipartFile) {
          request.files.add(value);
        } else if (value is List<http.MultipartFile>) {
          request.files.addAll(value);
        } else if (value is List) {
          for (final item in value) {
            if (item == null) continue;
            request.fields[key] = item.toString();
          }
        } else {
          request.fields[key] = value.toString();
        }
      });

      debugPrint(
        'putBuyerUpdate: Multipart request hazırlandı - URL: $uri, files: ${request.files.length}, fields: ${request.fields.keys.toList()}',
      );

      http.StreamedResponse streamedResponse;
      try {
        streamedResponse = await _deps.httpClient.send(request);
        debugPrint(
          'putBuyerUpdate: Multipart istek gönderildi - Status: ${streamedResponse.statusCode}',
        );
      } catch (e, stackTrace) {
        debugPrint(
          'putBuyerUpdate: Multipart istek gönderilirken hata oluştu - Hata: $e',
        );
        debugPrint('putBuyerUpdate: Stack trace: $stackTrace');
        rethrow;
      }

      final response = await http.Response.fromStream(streamedResponse);
      final bodyText = utf8.decode(response.bodyBytes);

      debugPrint(
        'putBuyerUpdate: Response alındı - Status: ${response.statusCode}, Body length: ${bodyText.length}',
      );

      Map<String, dynamic>? jsonData;
      if (bodyText.isNotEmpty) {
        try {
          final decoded = json.decode(bodyText);
          if (decoded is Map<String, dynamic>) {
            jsonData = decoded;
            debugPrint('putBuyerUpdate: JSON parse başarılı');
          }
        } catch (e) {
          debugPrint('putBuyerUpdate: JSON parse hatası - Hata: $e');
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('putBuyerUpdate: Başarılı - Status: ${response.statusCode}');
        return jsonData ?? {'raw': bodyText};
      }

      final errorMessage =
          jsonData?['message'] ??
          jsonData?['detail'] ??
          jsonData?.toString() ??
          (bodyText.isNotEmpty ? bodyText : 'Alıcı profili güncelleme başarısız.');

      debugPrint('putBuyerUpdate: Hata mesajı: $errorMessage');
      throw Exception(errorMessage);
    } else {
      // Dosya yoksa normal JSON request (PATCH)
      try {
        final jsonBody = json.encode(userPayload);
        debugPrint(
          'putBuyerUpdate: JSON PATCH isteği gönderiliyor - URL: $uri, Body length: ${jsonBody.length}',
        );

        final response = await _deps.httpClient.patch(
          uri,
          body: jsonBody,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'X-API-Key': config.apiKey,
            'Content-Type': 'application/json',
          },
        );

        final bodyText = utf8.decode(response.bodyBytes);

        debugPrint(
          'putBuyerUpdate: JSON Response alındı - Status: ${response.statusCode}, Body length: ${bodyText.length}',
        );

        Map<String, dynamic>? jsonData;
        if (bodyText.isNotEmpty) {
          try {
            final decoded = json.decode(bodyText);
            if (decoded is Map<String, dynamic>) {
              jsonData = decoded;
              debugPrint('putBuyerUpdate: JSON parse başarılı');
            }
          } catch (e) {
            debugPrint('putBuyerUpdate: JSON parse hatası - Hata: $e');
          }
        }

        if (response.statusCode >= 200 && response.statusCode < 300) {
          debugPrint(
            'putBuyerUpdate: Başarılı - Status: ${response.statusCode}',
          );
          return jsonData ?? {'raw': bodyText};
        }

        final errorMessage =
            jsonData?['message'] ??
            jsonData?['detail'] ??
            jsonData?.toString() ??
            (bodyText.isNotEmpty ? bodyText : 'Alıcı profili güncelleme başarısız.');

        debugPrint('putBuyerUpdate: Hata mesajı: $errorMessage');
        throw Exception(errorMessage);
      } catch (e, stackTrace) {
        if (e is Exception) {
          rethrow;
        }
        debugPrint(
          'putBuyerUpdate: JSON istek gönderilirken beklenmeyen hata - Hata: $e',
        );
        debugPrint('putBuyerUpdate: Stack trace: $stackTrace');
        throw Exception('Alıcı profili güncelleme sırasında bir hata oluştu: $e');
      }
    }
  }

  /// Satıcı profilini günceller (PATCH)
  /// Güncellenebilen alanlar:
  /// - Kullanıcı: first_name, last_name, telno, profil_fotograf, is_online
  /// - Satıcı: profil_banner, profil_tanitim_yazisi, magaza_adi, satici_vergi_numarasi, satici_iban, profession
  static Future<Map<String, dynamic>> putSellerUpdate(
    Map<String, dynamic> userPayload,
  ) async {
    debugPrint(
      'putSellerUpdate: Başlatılıyor - payload keys: ${userPayload.keys.toList()}',
    );
    debugPrint('putSellerUpdate: userPayload: ${userPayload.toString()}');

    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      debugPrint('putSellerUpdate: HATA - Access token boş!');
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final uri = Uri.parse(config.sellerUpdateApiUrl);
    debugPrint('putSellerUpdate: URL oluşturuldu - $uri');

    // Dosya alanlarını kontrol et (profil_fotograf, profil_banner)
    final hasFiles = userPayload.entries.any((entry) {
      final value = entry.value;
      return value is http.MultipartFile || value is List<http.MultipartFile>;
    });

    debugPrint('putSellerUpdate: Dosya kontrolü - hasFiles: $hasFiles');

    // Eğer dosya varsa multipart request kullan
    if (hasFiles) {
      final request = http.MultipartRequest('PUT', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $accessToken',
          'X-API-Key': config.apiKey,
        });

      userPayload.forEach((key, value) {
        if (value == null) return;

        if (value is http.MultipartFile) {
          request.files.add(value);
        } else if (value is List<http.MultipartFile>) {
          request.files.addAll(value);
        } else if (value is List) {
          for (final item in value) {
            if (item == null) continue;
            request.fields[key] = item.toString();
          }
        } else {
          request.fields[key] = value.toString();
        }
      });

      debugPrint(
        'putSellerUpdate: Multipart request hazırlandı - URL: $uri, files: ${request.files.length}, fields: ${request.fields.keys.toList()}',
      );

      http.StreamedResponse streamedResponse;
      try {
        streamedResponse = await _deps.httpClient.send(request);
        debugPrint(
          'putSellerUpdate: Multipart istek gönderildi - Status: ${streamedResponse.statusCode}',
        );
      } catch (e, stackTrace) {
        debugPrint(
          'putSellerUpdate: Multipart istek gönderilirken hata oluştu - Hata: $e',
        );
        debugPrint('putSellerUpdate: Stack trace: $stackTrace');
        rethrow;
      }

      final response = await http.Response.fromStream(streamedResponse);
      final bodyText = utf8.decode(response.bodyBytes);

      debugPrint(
        'putSellerUpdate: Response alındı - Status: ${response.statusCode}, Body length: ${bodyText.length}',
      );

      Map<String, dynamic>? jsonData;
      if (bodyText.isNotEmpty) {
        try {
          final decoded = json.decode(bodyText);
          if (decoded is Map<String, dynamic>) {
            jsonData = decoded;
            debugPrint('putSellerUpdate: JSON parse başarılı');
          }
        } catch (e) {
          debugPrint('putSellerUpdate: JSON parse hatası - Hata: $e');
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('putSellerUpdate: Başarılı - Status: ${response.statusCode}');
        return jsonData ?? {'raw': bodyText};
      }

      final errorMessage =
          jsonData?['message'] ??
          jsonData?['detail'] ??
          jsonData?.toString() ??
          (bodyText.isNotEmpty ? bodyText : 'Satıcı profili güncelleme başarısız.');

      debugPrint('putSellerUpdate: Hata mesajı: $errorMessage');
      throw Exception(errorMessage);
    } else {
      // Dosya yoksa normal JSON request (PATCH)
      try {
        final jsonBody = json.encode(userPayload);
        debugPrint(
          'putSellerUpdate: JSON PATCH isteği gönderiliyor - URL: $uri, Body length: ${jsonBody.length}',
        );

        final response = await _deps.httpClient.patch(
          uri,
          body: jsonBody,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'X-API-Key': config.apiKey,
            'Content-Type': 'application/json',
          },
        );

        final bodyText = utf8.decode(response.bodyBytes);

        debugPrint(
          'putSellerUpdate: JSON Response alındı - Status: ${response.statusCode}, Body length: ${bodyText.length}',
        );

        Map<String, dynamic>? jsonData;
        if (bodyText.isNotEmpty) {
          try {
            final decoded = json.decode(bodyText);
            if (decoded is Map<String, dynamic>) {
              jsonData = decoded;
              debugPrint('putSellerUpdate: JSON parse başarılı');
            }
          } catch (e) {
            debugPrint('putSellerUpdate: JSON parse hatası - Hata: $e');
          }
        }

        if (response.statusCode >= 200 && response.statusCode < 300) {
          debugPrint(
            'putSellerUpdate: Başarılı - Status: ${response.statusCode}',
          );
          return jsonData ?? {'raw': bodyText};
        }

        final errorMessage =
            jsonData?['message'] ??
            jsonData?['detail'] ??
            jsonData?.toString() ??
            (bodyText.isNotEmpty ? bodyText : 'Satıcı profili güncelleme başarısız.');

        debugPrint('putSellerUpdate: Hata mesajı: $errorMessage');
        throw Exception(errorMessage);
      } catch (e, stackTrace) {
        if (e is Exception) {
          rethrow;
        }
        debugPrint(
          'putSellerUpdate: JSON istek gönderilirken beklenmeyen hata - Hata: $e',
        );
        debugPrint('putSellerUpdate: Stack trace: $stackTrace');
        throw Exception('Satıcı profili güncelleme sırasında bir hata oluştu: $e');
      }
    }
  }

  /// Legacy putUserUpdate - uses putBuyerUpdate or putSellerUpdate based on isSeller flag
  /// @deprecated Use putBuyerUpdate or putSellerUpdate instead
  static Future<Map<String, dynamic>> putUserUpdate(
    Map<String, dynamic> userPayload, {
    bool? isSeller,
  }) async {
    if (isSeller == true) {
      return putSellerUpdate(userPayload);
    } else {
      return putBuyerUpdate(userPayload);
    }
  }

  // ============================================================================
  // SUPPORT TICKET API METHODS
  // ============================================================================

  /// 1. Yeni Destek Talebi Oluştur
  /// Method: POST
  /// URL: {config.supportTicketApiUrl}
  /// Body (FormData): name, email, phone, subject, message, attachment (optional)
  static Future<Map<String, dynamic>> postSupportTicket({
    required String name,
    required String email,
    String? phone,
    required String subject,
    required String message,
    http.MultipartFile? attachment,
  }) async {
    debugPrint('postSupportTicket: Başlatılıyor');

    if (config.supportTicketApiUrl.isEmpty) {
      throw Exception(
        'API yapılandırmasında "supportTicketApiUrl" bulunmuyor.',
      );
    }

    final uri = Uri.parse(config.supportTicketApiUrl);
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'X-API-Key': config.apiKey,
        'Accept': 'application/json',
      });

    // Field'ları ekle
    request.fields['name'] = name;
    request.fields['email'] = email;
    if (phone != null && phone.isNotEmpty) {
      request.fields['phone'] = phone;
    }
    request.fields['subject'] = subject;
    request.fields['message'] = message;

    debugPrint(
      'postSupportTicket: Fields eklendi - ${request.fields.keys.toList()}',
    );

    // Dosyayı ekle (varsa)
    if (attachment != null) {
      debugPrint(
        'postSupportTicket: Dosya ekleniyor - filename: ${attachment.filename}, '
        'length: ${attachment.length} bytes, '
        'contentType: ${attachment.contentType}',
      );
      request.files.add(attachment);
      debugPrint(
        'postSupportTicket: Dosya eklendi - Total files: ${request.files.length}',
      );
    }

    http.StreamedResponse streamedResponse;
    try {
      debugPrint(
        'postSupportTicket: Multipart request gönderiliyor - '
        'URL: $uri, '
        'fields: ${request.fields.keys.toList()}, '
        'files: ${request.files.length}',
      );
      streamedResponse = await _deps.httpClient.send(request);
      debugPrint(
        'postSupportTicket: Response alındı - Status: ${streamedResponse.statusCode}',
      );
    } catch (e, stackTrace) {
      debugPrint('postSupportTicket: İstek gönderilirken hata - Hata: $e');
      debugPrint('postSupportTicket: Stack trace: $stackTrace');
      rethrow;
    }

    final response = await http.Response.fromStream(streamedResponse);
    final bodyText = utf8.decode(response.bodyBytes);

    debugPrint(
      'postSupportTicket: Response body length: ${bodyText.length}, '
      'Status: ${response.statusCode}',
    );

    Map<String, dynamic>? jsonData;
    if (bodyText.isNotEmpty) {
      try {
        final decoded = json.decode(bodyText);
        if (decoded is Map<String, dynamic>) {
          jsonData = decoded;
          debugPrint('postSupportTicket: JSON parse başarılı');
        } else {
          debugPrint(
            'postSupportTicket: JSON parse uyarısı - Beklenen Map, alınan: ${decoded.runtimeType}',
          );
        }
      } catch (e, stackTrace) {
        debugPrint(
          'postSupportTicket: JSON parse hatası - $e, Body: ${bodyText.length > 200 ? bodyText.substring(0, 200) + "..." : bodyText}',
        );
        debugPrint('postSupportTicket: Stack trace: $stackTrace');
      }
    } else {
      debugPrint('postSupportTicket: Response body boş');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint(
        'postSupportTicket: Başarılı - Status: ${response.statusCode}',
      );
      return jsonData ?? {'raw': bodyText, 'status': 'success'};
    }

    final errorMessage =
        jsonData?['message'] ??
        jsonData?['detail'] ??
        jsonData?['error'] ??
        jsonData?.toString() ??
        (bodyText.isNotEmpty ? bodyText : 'Destek talebi oluşturulamadı.');

    debugPrint(
      'postSupportTicket: HATA - Status: ${response.statusCode}, Message: $errorMessage',
    );
    throw Exception(errorMessage);
  }

  /// 2. Ticket Listesi (Admin)
  /// Method: GET
  /// URL: {config.supportTicketApiUrl}
  /// Query Parameters: status, subject, search
  static Future<List<dynamic>> fetchSupportTickets({
    String? status,
    String? subject,
    String? search,
  }) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    if (config.supportTicketApiUrl.isEmpty) {
      throw Exception(
        'API yapılandırmasında "supportTicketApiUrl" bulunmuyor.',
      );
    }

    // Query parametrelerini oluştur
    final queryParams = <String, String>{};
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    if (subject != null && subject.isNotEmpty) {
      queryParams['subject'] = subject;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final uri = Uri.parse(
      config.supportTicketApiUrl,
    ).replace(queryParameters: queryParams);

    debugPrint('fetchSupportTickets: İstek gönderiliyor - URL: $uri');

    final response = await _deps.httpClient.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      if (decoded is List) {
        debugPrint(
          'fetchSupportTickets: Başarılı - ${decoded.length} ticket bulundu',
        );
        return decoded;
      } else if (decoded is Map<String, dynamic>) {
        if (decoded['results'] is List) {
          debugPrint(
            'fetchSupportTickets: Başarılı - ${(decoded['results'] as List).length} ticket bulundu',
          );
          return decoded['results'] as List;
        }
        return [decoded];
      } else {
        return [];
      }
    } else {
      throw Exception(
        'Ticket listesi alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  /// 3. Ticket Detayı (Admin)
  /// Method: GET
  /// URL: {config.supportTicketApiUrl}{ticketId}/
  static Future<Map<String, dynamic>> fetchSupportTicketDetail(
    int ticketId,
  ) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    if (config.supportTicketApiUrl.isEmpty) {
      throw Exception(
        'API yapılandırmasında "supportTicketApiUrl" bulunmuyor.',
      );
    }

    final String url = config.supportTicketApiUrl.endsWith('/')
        ? '${config.supportTicketApiUrl}$ticketId/'
        : '${config.supportTicketApiUrl}/$ticketId/';

    debugPrint('fetchSupportTicketDetail: İstek gönderiliyor - URL: $url');

    final response = await _deps.httpClient.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      if (jsonData is Map<String, dynamic>) {
        debugPrint('fetchSupportTicketDetail: Başarılı');
        return jsonData;
      } else {
        throw Exception('Ticket detayı beklenen formatta değil.');
      }
    } else {
      throw Exception(
        'Ticket detayı alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  /// 4. Ticket Durumunu Güncelle (Admin)
  /// Method: PATCH
  /// URL: {config.supportTicketApiUrl}{ticketId}/update_status/
  /// Body (FormData): status
  static Future<Map<String, dynamic>> patchSupportTicketStatus({
    required int ticketId,
    required String status,
  }) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    if (config.supportTicketApiUrl.isEmpty) {
      throw Exception(
        'API yapılandırmasında "supportTicketApiUrl" bulunmuyor.',
      );
    }

    final String baseUrl = config.supportTicketApiUrl.endsWith('/')
        ? config.supportTicketApiUrl
        : '${config.supportTicketApiUrl}/';
    final String url = '${baseUrl}$ticketId/update_status/';

    debugPrint('patchSupportTicketStatus: İstek gönderiliyor - URL: $url');

    final uri = Uri.parse(url);
    final request = http.MultipartRequest('PATCH', uri)
      ..headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
      })
      ..fields['status'] = status;

    http.StreamedResponse streamedResponse;
    try {
      streamedResponse = await _deps.httpClient.send(request);
      debugPrint(
        'patchSupportTicketStatus: İstek gönderildi - Status: ${streamedResponse.statusCode}',
      );
    } catch (e, stackTrace) {
      debugPrint(
        'patchSupportTicketStatus: İstek gönderilirken hata - Hata: $e',
      );
      debugPrint('patchSupportTicketStatus: Stack trace: $stackTrace');
      rethrow;
    }

    final response = await http.Response.fromStream(streamedResponse);
    final bodyText = utf8.decode(response.bodyBytes);

    Map<String, dynamic>? jsonData;
    if (bodyText.isNotEmpty) {
      try {
        final decoded = json.decode(bodyText);
        if (decoded is Map<String, dynamic>) {
          jsonData = decoded;
        }
      } catch (e) {
        debugPrint('patchSupportTicketStatus: JSON parse hatası - $e');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('patchSupportTicketStatus: Başarılı');
      return jsonData ?? {'raw': bodyText};
    }

    final errorMessage =
        jsonData?['message'] ??
        jsonData?['detail'] ??
        jsonData?.toString() ??
        (bodyText.isNotEmpty ? bodyText : 'Ticket durumu güncellenemedi.');

    debugPrint('patchSupportTicketStatus: Hata mesajı: $errorMessage');
    throw Exception(errorMessage);
  }

  /// 5. Ticket'ı Personele Ata (Admin)
  /// Method: PATCH
  /// URL: {config.supportTicketApiUrl}{ticketId}/assign/
  /// Body (FormData): assigned_to
  static Future<Map<String, dynamic>> patchSupportTicketAssign({
    required int ticketId,
    required int assignedTo,
  }) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    if (config.supportTicketApiUrl.isEmpty) {
      throw Exception(
        'API yapılandırmasında "supportTicketApiUrl" bulunmuyor.',
      );
    }

    final String baseUrl = config.supportTicketApiUrl.endsWith('/')
        ? config.supportTicketApiUrl
        : '${config.supportTicketApiUrl}/';
    final String url = '${baseUrl}$ticketId/assign/';

    debugPrint('patchSupportTicketAssign: İstek gönderiliyor - URL: $url');

    final uri = Uri.parse(url);
    final request = http.MultipartRequest('PATCH', uri)
      ..headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
      })
      ..fields['assigned_to'] = assignedTo.toString();

    http.StreamedResponse streamedResponse;
    try {
      streamedResponse = await _deps.httpClient.send(request);
      debugPrint(
        'patchSupportTicketAssign: İstek gönderildi - Status: ${streamedResponse.statusCode}',
      );
    } catch (e, stackTrace) {
      debugPrint(
        'patchSupportTicketAssign: İstek gönderilirken hata - Hata: $e',
      );
      debugPrint('patchSupportTicketAssign: Stack trace: $stackTrace');
      rethrow;
    }

    final response = await http.Response.fromStream(streamedResponse);
    final bodyText = utf8.decode(response.bodyBytes);

    Map<String, dynamic>? jsonData;
    if (bodyText.isNotEmpty) {
      try {
        final decoded = json.decode(bodyText);
        if (decoded is Map<String, dynamic>) {
          jsonData = decoded;
        }
      } catch (e) {
        debugPrint('patchSupportTicketAssign: JSON parse hatası - $e');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('patchSupportTicketAssign: Başarılı');
      return jsonData ?? {'raw': bodyText};
    }

    final errorMessage =
        jsonData?['message'] ??
        jsonData?['detail'] ??
        jsonData?.toString() ??
        (bodyText.isNotEmpty ? bodyText : 'Ticket atanamadı.');

    debugPrint('patchSupportTicketAssign: Hata mesajı: $errorMessage');
    throw Exception(errorMessage);
  }

  /// 6. Ticket Notlarını Güncelle (Admin)
  /// Method: PATCH
  /// URL: {config.supportTicketApiUrl}{ticketId}/
  /// Body (FormData): notes
  static Future<Map<String, dynamic>> patchSupportTicketNotes({
    required int ticketId,
    required String notes,
  }) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    if (config.supportTicketApiUrl.isEmpty) {
      throw Exception(
        'API yapılandırmasında "supportTicketApiUrl" bulunmuyor.',
      );
    }

    final String url = config.supportTicketApiUrl.endsWith('/')
        ? '${config.supportTicketApiUrl}$ticketId/'
        : '${config.supportTicketApiUrl}/$ticketId/';

    debugPrint('patchSupportTicketNotes: İstek gönderiliyor - URL: $url');

    final uri = Uri.parse(url);
    final request = http.MultipartRequest('PATCH', uri)
      ..headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
      })
      ..fields['notes'] = notes;

    http.StreamedResponse streamedResponse;
    try {
      streamedResponse = await _deps.httpClient.send(request);
      debugPrint(
        'patchSupportTicketNotes: İstek gönderildi - Status: ${streamedResponse.statusCode}',
      );
    } catch (e, stackTrace) {
      debugPrint(
        'patchSupportTicketNotes: İstek gönderilirken hata - Hata: $e',
      );
      debugPrint('patchSupportTicketNotes: Stack trace: $stackTrace');
      rethrow;
    }

    final response = await http.Response.fromStream(streamedResponse);
    final bodyText = utf8.decode(response.bodyBytes);

    Map<String, dynamic>? jsonData;
    if (bodyText.isNotEmpty) {
      try {
        final decoded = json.decode(bodyText);
        if (decoded is Map<String, dynamic>) {
          jsonData = decoded;
        }
      } catch (e) {
        debugPrint('patchSupportTicketNotes: JSON parse hatası - $e');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('patchSupportTicketNotes: Başarılı');
      return jsonData ?? {'raw': bodyText};
    }

    final errorMessage =
        jsonData?['message'] ??
        jsonData?['detail'] ??
        jsonData?.toString() ??
        (bodyText.isNotEmpty ? bodyText : 'Ticket notları güncellenemedi.');

    debugPrint('patchSupportTicketNotes: Hata mesajı: $errorMessage');
    throw Exception(errorMessage);
  }

  /// 7. Staff Kullanıcıları Listesi (Admin)
  /// Method: GET
  /// URL: {config.baseUrl}/api/users/staff-users/
  static Future<List<dynamic>> fetchStaffUsers() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    // Staff users için özel URL oluştur
    final String staffUsersUrl = config.baseUrl.endsWith('/')
        ? '${config.baseUrl}api/users/staff-users/'
        : '${config.baseUrl}/api/users/staff-users/';

    debugPrint('fetchStaffUsers: İstek gönderiliyor - URL: $staffUsersUrl');

    final response = await _deps.httpClient.get(
      Uri.parse(staffUsersUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      if (decoded is List) {
        debugPrint(
          'fetchStaffUsers: Başarılı - ${decoded.length} staff kullanıcı bulundu',
        );
        return decoded;
      } else if (decoded is Map<String, dynamic>) {
        if (decoded['results'] is List) {
          return decoded['results'] as List;
        }
        return [decoded];
      } else {
        return [];
      }
    } else {
      throw Exception(
        'Staff kullanıcıları alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }
}
