import 'package:flutter/material.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/models/userAdress.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/product/navigation/home_productDetail_router.dart';
import 'package:imecehub/screens/home/categories/categories_screen.dart';
import 'package:imecehub/screens/home/home_screen.dart';
import 'package:imecehub/screens/products/productsDetail/products_detail_screen.dart';
import 'package:imecehub/screens/profil/SignIn/sign_in_screen.dart';
import 'package:imecehub/screens/profil/addPost/add_post_screen.dart';
import 'package:imecehub/screens/profil/buyerProfil/buyer_profil_screen.dart';
import 'package:imecehub/screens/profil/buyerProfil/menu/adress/adress_add_screen.dart';
import 'package:imecehub/screens/profil/buyerProfil/menu/comments/comments_screen.dart';
import 'package:imecehub/screens/profil/messaging/messaging_view.dart';
import 'package:imecehub/screens/profil/messaging/private/messaging_private_screen.dart';
import 'package:imecehub/screens/profil/buyerProfil/menu/orders/order_detail_screen.dart';
import 'package:imecehub/screens/profil/profile_screen.dart';
import 'package:imecehub/screens/profil/sellerProfil/seller_profil_screen.dart';
import 'package:imecehub/screens/profil/sellerProfil/widgets/my_products_widgets.dart';

import 'package:imecehub/screens/profil/wallet/wallet_screen.dart';
import 'package:imecehub/screens/profil/wallet/widget/past_payments_more_view.dart';
import 'package:imecehub/screens/shoppingCart/addCreditCart/add_credit_cart.dart';

import 'package:imecehub/screens/shoppingCart/cart_screen.dart';

import '../../screens/profil/addProduct/add_product_screen.dart';
import '../../screens/profil/support/support_screen.dart';
import '../../screens/profil/support/my_tickets_screen.dart';
import '../../screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/splash': (context) => const SplashScreen(),
  '/home': (context) => HomeScreen(),
  '/cart': (context) => OrderScreen(),
  '/profil': (context) => ProfileScreen(),
  '/cart/addCreditCart': (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;

    return AddCreditCartScreen(
      cartNameController: TextEditingController(text: args['cartName']),
      cartNumberController: TextEditingController(text: args['cardNumber']),
      cartUserNameController: TextEditingController(text: args['cartUserName']),
      cvvController: TextEditingController(text: args['cvv']),
      lateUseDateController: TextEditingController(text: args['lateUseDate']),
    );
  },
  '/profil/signIn': (context) => SignInScreen(),
  '/profil/signUp': (context) => SignUpScreen(),
  '/profil/changePassword': (context) => ChangePasswordScreen(),
  '/profil/sellerProfile': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as List;
    return SellerProfilScreen(sellerProfil: args[0], myProfile: args[1]);
  },
  '/profil/messaging': (context) => MessageBox(),
  '/profil/addProduct': (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    User? user;
    Product? product;

    if (args is Map<String, dynamic>) {
      user = args['user'] as User?;
      product = args['product'] as Product?;
    } else if (args is User) {
      // Geriye dönük uyumluluk için
      user = args;
    }

    // User null ise, Product'tan satici ID'sini al veya null bırak
    if (user == null && product != null && product.satici != null) {
      // Product'tan User oluşturulamaz, sadece ID var
      // Bu durumda user null kalacak ve AddProductScreen'de hata olabilir
      // En iyisi User'ı optional yapmak
    }

    return AddProductScreen(
      user: user, // User boş gelebilir
      product: product, // Product boş gelebilir
    );
  },
  '/profil/addPost': (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return AddPost(
      sellerProfil: args['user'] as User,
      isStory: args['isStory'] as bool,
    );
  },
  '/profil/myProducts': (context) {
    final seller = ModalRoute.of(context)!.settings.arguments as User;
    return MyProductsGrid(seller: seller);
  },
  '/profil/wallet': (context) => WalletScreen(),
  '/profil/wallet/pastPayments': (context) {
    return PastPaymentsMoreView(
      pastPayments:
          ModalRoute.of(context)!.settings.arguments
              as List<Map<String, dynamic>>,
    );
  },
  '/profil/favorite': (context) => FavoriteScreen(),
  '/profil/cards': (context) => CardsScreen(),
  '/profil/orders': (context) => OrdersScreen(),
  '/profil/orders/detail': (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return OrderDetailScreen(item: args);
  },
  '/profil/follow': (context) => FollowScreen(),
  '/profil/coupons': (context) => CouponsScreen(),
  '/profil/comments': (context) => CommentsScreen(),
  '/profil/groups': (context) => GroupsScreen(),
  '/profil/myProfile': (context) => const MyProfileScreen(),
  '/profil/myProfile/edit': (context) => const MyProfileEditScreen(),
  '/profil/settings': (context) => const SettingsScreen(),
  '/profil/settings/seller': (context) => const SellerProfileSettingsScreen(),
  '/profil/support': (context) => const SupportScreen(),
  '/profil/support/tickets': (context) => const MyTicketsScreen(),
  '/profil/adress': (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return AdressScreen(buyerProfil: args['buyerProfil'] as User);
  },
  '/profil/adress/add': (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return AdressAddScreen(
      user: args['buyerProfil'] as User,
      adres: args['adres'] as UserAdress?,
      isUpdate: args['isUpdate'] as bool,
    );
  },
  '/products/productsDetail': (context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    int? productId;
    if (args is Product) {
      productId = args.urunId;
    } else if (args is int) {
      productId = args;
    }
    if (productId == null) {
      return const Scaffold(
        body: Center(child: Text('Ürün bilgisi bulunamadı.')),
      );
    }
    return ProductsDetailScreen(productId: productId);
  },
  '/home/productsDetail': (context) {
    return HomeProductDetailRouter();
  },
  '/home/category': (context) {
    return CategoriesScreen(
      categoryId: ModalRoute.of(context)!.settings.arguments as int,
    );
  },
  '/messaging/private': (context) => MessagingPrivateScreen(
    item: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
  ),
};
