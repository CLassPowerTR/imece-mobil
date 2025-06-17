import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/textButton.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/screens/profil/sellerProfil/seller_profil_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:imecehub/models/users.dart';

import '../../core/widgets/showTemporarySnackBar.dart';
part 'profileNotLogin.dart';

part 'SignUp/sign_up_view_header.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String accesToken = '';
  bool isTimeout = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
    _startTimeout();
  }

  void _startTimeout() {
    _timer?.cancel();
    isTimeout = false;
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted && userAsyncIsLoading()) {
        setState(() {
          isTimeout = true;
        });
      }
    });
  }

  bool userAsyncIsLoading() {
    final userAsync = ref.read(userProvider);
    return userAsync is AsyncLoading<User?>;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accesToken') ?? '';
    setState(() {
      accesToken = token;
    });
    if (accesToken.isNotEmpty) {
      ref.read(userProvider.notifier).fetchUserLogin(accesToken);
      ref.read(loginStateProvider.notifier).state = true; // örnek olarak login
    }
    _startTimeout();
  }

  Future<void> _refreshSeller() async {
    await ref.read(userProvider.notifier).fetchUserLogin(accesToken);
    _startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(loginStateProvider);
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshSeller,
        child: Builder(
          builder: (context) {
            final user = userAsync.value;
            print('user: $user');
            if (!isLoggedIn || user == null) {
              return ProfileNotLogin();
            }
            if (user.aliciProfili == null && user.saticiProfili != null) {
              return SellerProfilScreen(
                sellerProfil: user,
                myProfile: isLoggedIn,
              );
            } else if (user.saticiProfili == null &&
                user.aliciProfili != null) {
              // Henüz alıcı profili ekranı yok, şimdilik boş bir Container dönüyoruz
              return Container(
                alignment: Alignment.center,
                child: Text('Alıcı profili ekranı yakında!'),
              );
            } else {
              // Her iki profil de yoksa profil bulunamadı uyarı barı ve giriş ekranı
              return Builder(
                builder: (context) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showTemporarySnackBar(context, 'Profil bulunamadı.');
                  });
                  return ProfileNotLogin();
                },
              );
            }
          },
        ),
      ),
    );
  }
}
