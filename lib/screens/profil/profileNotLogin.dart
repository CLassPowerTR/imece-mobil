part of 'profile_screen.dart';

class ProfileNotLogin extends StatefulWidget {
  const ProfileNotLogin({super.key});

  @override
  State<ProfileNotLogin> createState() => _profileNotLoginState();
}

class _profileNotLoginState extends State<ProfileNotLogin> with RouteAware {
  final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(refresh: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                NotFound.LogoPNGUrl,
                fit: BoxFit.cover,
                errorBuilder:
                    (
                      BuildContext context,
                      Object exception,
                      StackTrace? stackTrace,
                    ) {
                      return Image.network(NotFound.LogoPNGUrl);
                    },
              ),
              customText(
                'Profilim',
                context,
                size: HomeStyle(context: context).bodyLarge.fontSize,
                weight: FontWeight.bold,
              ),
              customText(
                'Profilinizi görüntüleyebilmek için lütfen giriş yapın...',
                context,
                size: 13,
              ),
              textButton(
                context,

                'Üye Ol',
                onPressed: () {
                  Navigator.pushNamed(context, '/profil/signUp');
                },
              ),
              textButton(
                context,
                'Giriş Yap',
                buttonColor: HomeStyle(
                  context: context,
                ).secondary.withOpacity(0.2),
                titleColor: HomeStyle(context: context).tertiary,

                onPressed: () {
                  Navigator.pushNamed(context, '/profil/signIn');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
