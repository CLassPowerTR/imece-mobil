import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  final String usersApiUrl = dotenv.env['USERS_API_URL'] ?? '';
  final String userMeApiUrl = dotenv.env['USER_ME_API_URL'] ?? '';
  final String userRqLoginApiUrl = dotenv.env['USER_RQ_LOGIN_API_URL'] ?? '';
  final String userRqRegisterApiUrl =
      dotenv.env['USER_RQ_REGISTER_API_URL'] ?? '';
  final String userLogoutApiUrl = dotenv.env['USER_LOGOUT_API_URL'] ?? '';
  final String userFavoritesApiUrl = dotenv.env['USER_FAVORITES_API_URL'] ?? '';
  final String productsApiUrl = dotenv.env['PRODUCTS_API_URL'] ?? '';
  final String userAdressApiUrl = dotenv.env['USER_ADRESS_API_URL'] ?? '';
  final String userFollowApiUrl = dotenv.env['USER_FOLLOW_API_URL'] ?? '';
  final String userCouponsApiUrl = dotenv.env['USER_COUPONS_API_URL'] ?? '';
  final String userGroupsApiUrl = dotenv.env['USER_GROUPS_API_URL'] ?? '';
  final String sellerProductsApiUrl =
      dotenv.env['SELLER_PRODUCTS_API_URL'] ?? '';
  final String productsCategoryApiUrl =
      dotenv.env['PRODUCTS_CATEGORY_API_URL'] ?? '';
  final String categoriesApiUrl = dotenv.env['CATEGORIES_API_URL'] ?? '';
  final String populerProductsApiUrl =
      dotenv.env['POPULER_PRODUCTS_API_URL'] ?? '';
  final String productsCampaingsApiUrl = dotenv.env['PRODUCTS_CAMPAINGS'] ?? '';
  final String companiesApiUrl = dotenv.env['COMPANIES_API_URL'] ?? '';
  final String productsCampaignsStoriesApiUrl =
      dotenv.env['PRODUCTS_CAMPAIGNS_STORIES_API_URL'] ?? '';
  final String productsStoriesApiUrl =
      dotenv.env['PRODUCTS_STORIES_API_URL'] ?? '';
  final String urunYorumApiUrl = dotenv.env['URUN_YORUM_API_URL'] ?? '';
  final String productsCommentsApiUrl =
      dotenv.env['COMMENTS_PRODUCTS_API_URL'] ?? '';
  final String sepetGetApiUrl = dotenv.env['SEPET_GET_API_URL'] ?? '';
  final String sepetEkleApiUrl = dotenv.env['SEPET_EKLE_API_URL'] ?? '';
  final String sepetInfoApiUrl = dotenv.env['SEPET_INFO_API_URL'] ?? '';
  final String sellerProfileApiUrl = dotenv.env['SELLER_PROFILE_API_URL'] ?? '';
  final String logisticOrderApiUrl = dotenv.env['LOGISTIC_ORDER_API_URL'] ?? '';
  final String paymentSiparisApiUrl =
      dotenv.env['PAYMENT_SIPARIS_API_URL'] ?? '';
  final String paymentTriggerApiUrl =
      dotenv.env['PAYMENT_TRIGGER_API_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  // Singleton pattern (isteğe bağlı)
  static final ApiConfig instance = ApiConfig._internal();
  factory ApiConfig() => instance;
  ApiConfig._internal();
}
