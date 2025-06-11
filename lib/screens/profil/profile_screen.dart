import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/textButton.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/screens/profil/sellerProfil/seller_profil_screen.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/providers/auth_provider.dart';
part 'profileNotLogin.dart';

part 'SignUp/widget/sign_up_view_header.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int testUserId = 3;

  @override
  void initState() {
    super.initState();
    // Uygulama ilk açıldığında kullanıcıyı çek
    Future.microtask(() {
      ref.read(userProvider.notifier).fetchUser(testUserId);
      ref.read(loginStateProvider.notifier).state = true; // örnek olarak login
    });
  }

  Future<void> _refreshSeller() async {
    await ref.read(userProvider.notifier).fetchUser(testUserId);
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(loginStateProvider);
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshSeller,
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                textButton(
                  context,
                  'Tekrar Dene',
                  onPressed: () {
                    ref.read(userProvider.notifier).fetchUser(testUserId);
                  },
                )
              ],
            ),
          ),
          data: (user) {
            if (!isLoggedIn || user == null) {
              return ProfileNotLogin();
            }
            return SellerProfilScreen(
              sellerProfil: user,
              myProfile: isLoggedIn,
            );
          },
        ),
      ),
    );
  }
}
