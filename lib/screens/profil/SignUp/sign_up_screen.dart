part of '../SignIn/sign_in_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool isCheckedContract = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  Map<String, dynamic>? errorMessage;
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Klavye açıldığında UI'nın kaymasını engeller
      appBar: SignInAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                spacing: 15,
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  headText(context),
                  emailAdressContainer(
                    width,
                    context,
                    textFieldHeight: 50,
                    containerHeight: 90,
                    controller: emailController,
                    errorText: errorMessage?['email'] != null
                        ? (errorMessage?['email'] is List
                              ? (errorMessage?['email'] as List).join(', ')
                              : errorMessage?['email'].toString())
                        : null,
                  ),
                  usernameContainer(
                    width,
                    context,
                    textFieldHeight: 50,
                    containerHeight: 90,
                    controller: usernameController,
                    errorText: errorMessage?['username'] != null
                        ? (errorMessage?['username'] is List
                              ? (errorMessage?['username'] as List).join(', ')
                              : errorMessage?['username'].toString())
                        : null,
                  ),
                  passwordContainer(
                    width,
                    context,
                    textFieldHeight: 50,
                    containerHeight: 90,
                    obscureText: showPassword,
                    showSuffixIcon: true,
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    textFieldController: passwordController,
                    errorText: errorMessage?['password'] != null
                        ? (errorMessage?['password'] is List
                              ? (errorMessage?['password'] as List).join(', ')
                              : errorMessage?['password'].toString())
                        : null,
                  ),
                  checkContract(width, context, isCheckedContract, (value) {
                    setState(() {
                      isCheckedContract = value!;
                    });
                  }),
                  // Alan bazlı hata gösterimi input altında yapıldığı için üst genel hata alanını kaldırdık
                  NextButton(
                    context,
                    'Üye Ol',
                    isCheckedContract,
                    minSizeHeight: 50,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                        errorMessage = null;
                      });
                      try {
                        await ref
                            .read(userProvider.notifier)
                            .register(
                              email: emailController.text.trim(),
                              username: usernameController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                        setState(() {
                          isLoading = false;
                        });
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Kayıt başarılı!')),
                          );
                          ref.read(bottomNavIndexProvider.notifier).setIndex(3);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                            arguments: {'refresh': true},
                          );
                        }
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                          // Exception: { ... } gövdesini ayıkla ve parse et
                          Map<String, dynamic>? parsed;
                          try {
                            final s = e.toString();
                            final start = s.indexOf('{');
                            final end = s.lastIndexOf('}');
                            if (start != -1 && end != -1 && end > start) {
                              parsed =
                                  json.decode(s.substring(start, end + 1))
                                      as Map<String, dynamic>;
                            }
                          } catch (_) {
                            parsed = null;
                          }
                          if (parsed != null) {
                            // Eğer {status, errors: {...}} formatındaysa sadece errors'u al
                            if (parsed['errors'] is Map<String, dynamic>) {
                              errorMessage = Map<String, dynamic>.from(
                                parsed['errors'],
                              );
                            } else {
                              errorMessage = parsed;
                            }
                          } else {
                            // JSON değilse anahtar kelime arayarak alanlara dağıt
                            final message = e.toString();
                            errorMessage = {
                              'email': message.contains('email')
                                  ? message
                                  : null,
                              'username': message.contains('username')
                                  ? message
                                  : null,
                              'password': message.contains('password')
                                  ? message
                                  : null,
                            };
                          }
                        });
                      }
                    },
                  ),
                  orLine(width, context, containerHeight: 16),
                  signInWithGoogle(context, width, containerHeight: 50),
                  //SizedBox(height: 5),
                  signUpText(
                    textFirst: 'Already have an account?',
                    textSecond: 'Sign in',
                    context,
                    () {
                      setState(() {
                        Navigator.pushNamed(context, '/profil/signIn');
                      });
                    },
                  ),
                ],
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(child: buildLoadingBar(context)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
