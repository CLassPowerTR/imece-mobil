import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/buttons/textButton.dart';
import 'package:imecehub/core/widgets/textField.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
// import 'package:imecehub/providers/auth_provider.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/screens/profil/profile_screen.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/screens/home/home_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'sign_in_view_header.dart';
part 'sign_in_widget_items.dart';
part '../SignUp/sign_up_screen.dart';
part '../changePassword/change_password_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreen();
}

class _SignInScreen extends ConsumerState<SignInScreen> with RouteAware {
  bool isCheckedContract = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage; // Genel hata
  Map<String, dynamic>? fieldErrors; // Alan bazlı hatalar
  bool showPassword = true;

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
    ProfileScreen(refresh: true);
  }

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
                spacing: 20,
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  headText(context),
                  emailAdressContainer(
                    width,
                    context,
                    controller: emailController,
                    errorText: fieldErrors?['email'] != null
                        ? (fieldErrors?['email'] is List
                              ? (fieldErrors?['email'] as List).join(', ')
                              : fieldErrors?['email'].toString())
                        : null,
                  ),
                  passwordContainer(
                    width,
                    context,
                    textFieldController: passwordController,
                    obscureText: showPassword,
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    showSuffixIcon: true,
                    errorText: fieldErrors?['password'] != null
                        ? (fieldErrors?['password'] is List
                              ? (fieldErrors?['password'] as List).join(', ')
                              : fieldErrors?['password'].toString())
                        : null,
                  ),
                  checkContract(width, context, isCheckedContract, (value) {
                    setState(() {
                      isCheckedContract = value!;
                    });
                  }),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: 100, // Maksimum yükseklik belirleyin
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  NextButton(
                    context,
                    'Giriş Yap',
                    isCheckedContract,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                        errorMessage = null;
                        fieldErrors = null;
                      });
                      try {
                        await ref
                            .read(userProvider.notifier)
                            .login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                        setState(() {
                          isLoading = false;
                        });
                        if (mounted) {
                          showTemporarySnackBar(
                            context,
                            'Giriş başarılı!',
                            type: SnackBarType.success,
                          );

                          ref.read(bottomNavIndexProvider.notifier).setIndex(3);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                            arguments: {'refresh': true},
                          );

                          //Navigator.pushReplacementNamed(context, '/home');
                        }
                      } catch (e) {
                        final s = e.toString();
                        if (s.contains('Invalid email or password')) {
                          setState(() {
                            isLoading = false;
                            errorMessage = null;
                            fieldErrors = null;
                          });
                          showTemporarySnackBar(
                            context,
                            'Kullanıcı adı veya şifre hatalı.',
                            type: SnackBarType.error,
                          );
                        } else {
                          setState(() {
                            isLoading = false;
                            Map<String, dynamic>? parsed;
                            try {
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
                              fieldErrors = parsed;
                              errorMessage = null;
                            } else {
                              errorMessage = s;
                            }
                          });
                        }
                      }
                    },
                  ),
                  orLine(width, context),
                  signInWithGoogle(context, width),
                  //SizedBox(height: 5),
                  signUpText(context, () {
                    setState(() {
                      Navigator.pushNamed(context, '/profil/signUp');
                    });
                  }),
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

  // Removed unused _changedPassword
}
