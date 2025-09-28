// lib/services/api_service.dart

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:imecehub/models/companies.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/models/userAdress.dart';
import 'package:imecehub/models/campaigns.dart';
import 'package:imecehub/models/stories.dart';
import '../models/users.dart';
import '../models/productCategories.dart';
import '../api/api_config.dart'; // Add this line to import ApiConfig
import '../models/urunYorum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final config = ApiConfig();

  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('accesToken'));
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

  static Future<User> fetchSellerProfile(int? id) async {
    // HTTP GET isteği gönderilirken header'a API key eklenir.
    final response = await http.get(
      Uri.parse('${config.sellerProfileApiUrl}$id/'),
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
        'Content-Type': 'application/json',
        'Allow': 'Get',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
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
  static Future<List<UrunYorum>> fetchUrunYorumlara({int? urunId}) async {
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
          'Ürün yorumları alınamadı. Durum kodu:  [31m [1m${response.statusCode} [0m');
    }
  }

  /// API'den Ürün Yorumlarını çekmek için metot.
  static Future<UrunYorumlarResponse> takeCommentsForProduct(
      {int? urunId}) async {
    final accessToken = await getAccessToken();
    // Eğer urunId verilmişse, ilgili ürünün yorumlarını çek.

    final response = await http.post(
      Uri.parse(config.productsCommentsApiUrl),
      body: json.encode({
        'urun_id': urunId,
      }),
      headers: {
        'X-API-Key': config.apiKey,
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Allow': 'Post',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(utf8.decode(response.bodyBytes));
      return UrunYorumlarResponse.fromJson(data);
    } else {
      throw Exception(
          'Ürün yorumları alınamadı. Durum kodu:  ${response.statusCode} ${response.body}');
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
      // Sunucu JSON dönerse map olarak ilet; değilse metni döndür
      if (jsonData is Map<String, dynamic>) {
        // Beklenen örnek: { email: [..], password: [..], username: [..] }
        throw Exception(json.encode(jsonData));
      } else {
        final errorMessage = jsonData != null
            ? (jsonData['errors'] ?? 'Kullanıcı kaydı başarısız.')
            : response.body;
        throw Exception('$errorMessage');
      }
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
      final errorMessage = jsonData != null
          ? (jsonData['message'] ?? 'Kullanıcı kaydı başarısız.')
          : response.body;
      throw Exception('$errorMessage');
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

  static Future<dynamic> fetchUserFavorites(
      int? id, int? userID, int? urunID, int? deleteID) async {
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
        response = await http.delete(
          Uri.parse('${url}$deleteID/'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'X-API-Key': config.apiKey,
            'Content-Type': 'application/json',
          },
        );
      } catch (e) {
        throw Exception('Favori ürünler alınamadı. Durum kodu: $e');
      }
      if ((response.statusCode == 204 || response.statusCode == 200)) {
        return [];
      } else {
        throw Exception(
            'Favori ürün silinemedi. Durum kodu: ${response.statusCode}');
      }
    } else if (userID != null && urunID != null) {
      if (userID == 0 || urunID == 0) {
        throw Exception('Kullanıcı veya ürün ID\'si eksik veya geçersiz!');
      }
      final body = {
        'alici': userID,
        'urun': urunID,
      };
      try {
        response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'X-API-Key': config.apiKey,
            'Content-Type': 'application/json',
          },
          body: json.encode(body),
        );
      } catch (e) {
        throw Exception('Favori ürünler alınamadı. Durum kodu: $e');
      }
      if (response.statusCode == 201 && response.body.isNotEmpty) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return jsonData; // Map dönebilir
      } else {
        throw Exception(
            'Favori ürünler alınamadı. Durum kodu: ${response.statusCode}');
      }
    } else if (userID == null && urunID == null) {
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
        return jsonData; // List dönebilir
      } else {
        throw Exception(
            'Favori ürünler alınamadı. Durum kodu: ${response.statusCode}');
      }
    } else {
      return [
        'userID ve urunID birlikte dolu olmalı veya birlikte null olmalı.'
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
          'API yapılandırmasında "userAdressApiUrl" bulunmuyor. .env yüklenmiş mi?');
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
      throw Exception('Geçersiz kullanıcı adresi URLsi: $baseUrl');
    }

    final response = await http.get(
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
          'Yetkilendirme hatası (401). Lütfen yeniden giriş yapın.');
    }

    // Eğer içerik tipi JSON değilse, büyük olasılıkla HTML dönüyordur -> hata ver
    final contentType = response.headers.entries
        .firstWhere((e) => e.key.toLowerCase() == 'content-type',
            orElse: () => MapEntry('', ''))
        .value
        .toLowerCase();

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      if (!contentType.contains('application/json')) {
        // Kısa bir önizleme verelim (maks 500 karakter) — çok büyük olmasın
        final preview = response.body.length > 500
            ? response.body.substring(0, 500)
            : response.body;
        throw Exception(
            'API JSON dönmedi. Status: ${response.statusCode}. Cevap önizlemesi:\n$preview');
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
              'API beklenen formatta liste dönmedi. Gelen tip: ${jsonData.runtimeType}');
        }
      } catch (e) {
        throw Exception('JSON parse hatası: $e');
      }
    } else {
      final preview = response.body.length > 500
          ? response.body.substring(0, 500)
          : response.body;
      throw Exception(
          'Adresler alınamadı. Durum kodu: ${response.statusCode}. Cevap önizlemesi:\n$preview');
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
      int kullanici) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.post(
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
          'Adresler alınamadı. Durum kodu: \\${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> deleteUserAdress(int id) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.delete(
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
          'Adres silinirken bir hata oluştu. Durum kodu: \\${response.statusCode}');
    }
  }

  static Future<UserAdress> fetchUserAdressById(int id) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.get(
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
          'Adres bilgisi alınamadı. Durum kodu: \\${response.statusCode}');
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
      int kullanici) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.patch(
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
          'Adres güncellenirken bir hata oluştu. Durum kodu: \\${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchUserFollow() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.get(
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
          'Takip edilenler alınamadı. Durum kodu: \\${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> postUserFollow(
      int sellerID, int userID) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.post(
      Uri.parse(config.userFollowApiUrl),
      body: json.encode({
        'satici': sellerID,
        'kullanici': userID,
      }),
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
          'Takip Ederken bir hata oluştu. Durum kodu: \\${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> deleteUserFollow(int id) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.delete(
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
          'Takipten çıkarken bir hata oluştu. Durum kodu: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchUserCoupons() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.get(
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
      throw Exception(
          'Kuponlar alınamadı. Durum kodu: \\${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchProductsComments(
      int? kullaniciID, int? magazaID) async {
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
          'Yorumlar alınamadı. Durum kodu: \\${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchSellersComments(
      int? kullaniciID, int? magazaID) async {
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
          'Yorumlar alınamadı. Durum kodu: \\${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchLogisticOrder(int? aliciID) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final response = await http.get(
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
          'Kargo bilgileri alınamadı. Durum kodu: \\${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> postTriggerPayment(
      Map<String, dynamic> paymentPayload) async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }

    final String url = config.paymentTriggerApiUrl.isNotEmpty
        ? config.paymentTriggerApiUrl
        : 'https://imecehub.com/api/payment/siparisitem/trigger-payment/';

    http.Response response;
    try {
      response = await http.post(
        Uri.parse(url),
        body: json.encode(paymentPayload),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'X-API-Key': config.apiKey,
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      throw Exception('Ödeme isteği gönderilemedi: $e');
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
        throw Exception('Ödeme cevabı JSON parse hatası: $e');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonData ?? {'raw': bodyText};
    } else {
      if (jsonData != null) {
        throw Exception(json.encode(jsonData));
      } else {
        throw Exception(bodyText.isNotEmpty
            ? bodyText
            : 'Ödeme başarısız. Durum kodu: ${response.statusCode}');
      }
    }
  }

  static Future<Campaigns> fetchProductsCampaings() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.get(
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
            'Kampanyalar beklenen formatta değil: ${jsonData.runtimeType}');
      }
    } else {
      throw Exception(
          'Kampanyalar alınamadı. Durum kodu: \\${response.statusCode}');
    }
  }

  // Hikayeler için placeholder; API netleşene kadar boş liste döndürür
  static Future<Stories> fetchCampaignsStories() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.get(
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
          'Hikayeler alınamadı. Durum kodu: \\${response.statusCode}');
    }
  }

  static Future<Stories> fetchStories() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.get(
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
          'Hikayeler alınamadı. Durum kodu: \\${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchUserGroups() async {
    final accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      throw Exception('Kullanıcı oturumu kapalı.');
    }
    final response = await http.get(
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
        final dynamic maybeList = decoded['results'] ??
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
          'Kullanıcı grupları alınamadı. Durum kodu: \\${response.statusCode}');
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
      response = await http.post(
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
      ).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw Exception(
          'İstek zaman aşımına uğradı (10s). Lütfen tekrar deneyin.');
    } catch (e) {
      throw Exception('Sipariş onay isteği gönderilemedi: $e');
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
        throw Exception('Cevap JSON parse hatası: $e');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonData ?? {'raw': bodyText};
    } else {
      if (jsonData != null) {
        throw Exception(json.encode(jsonData));
      } else {
        throw Exception(bodyText.isNotEmpty
            ? bodyText
            : 'Sipariş onay başarısız. Durum kodu: ${response.statusCode}');
      }
    }
  }
}
