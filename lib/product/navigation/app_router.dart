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

import 'package:imecehub/screens/profil/wallet/wallet_screen.dart';
import 'package:imecehub/screens/profil/wallet/widget/past_payments_more_view.dart';
import 'package:imecehub/screens/shoppingCart/addCreditCart/add_credit_cart.dart';

import 'package:imecehub/screens/shoppingCart/cart_screen.dart';

import '../../screens/profil/addProduct/add_product_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
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
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return AddProductScreen(user: user);
  },
  '/profil/addPost': (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return AddPost(
      sellerProfil: args['user'] as User,
      isStory: args['isStory'] as bool,
    );
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
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return ProductsDetailScreen(product: product);
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
