import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/textButton.dart';
import 'package:imecehub/core/widgets/textField.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/services/api_service.dart';

part 'sign_in_view_header.dart';
part 'sign_in_widget_items.dart';
part '../SignUp/sign_up_screen.dart';
part '../changePassword/change_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  bool isCheckedContract = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Klavye açıldığında UI'nın kaymasını engeller
      appBar: SignInAppBar(context),
      body: SafeArea(
          child: Padding(
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
            ),
            passwordContainer(width, context,
                obscureText: true, showSuffixIcon: true),
            checkContract(
              width,
              context,
              isCheckedContract,
              (value) {
                setState(() {
                  isCheckedContract = value!;
                });
              },
            ),
            if (isLoading) const CircularProgressIndicator(),
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
              isCheckedContract,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                try {
                  await ApiService.fetchUserLogin(emailController.text.trim(),
                      passwordController.text.trim());
                  setState(() {
                    isLoading = false;
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Giriş başarılı!')),
                    );
                    Navigator.pushReplacementNamed(context, '/profil');
                  }
                } catch (e) {
                  setState(() {
                    isLoading = false;
                    errorMessage = e.toString();
                  });
                }
              },
            ),
            orLine(width, context),
            _changedPassword(context),
            signInWithGoogle(context, width),
            //SizedBox(height: 5),
            signUpText(
              context,
              () {
                setState(() {
                  Navigator.pushNamed(context, '/profil/signUp');
                });
              },
            ),
          ],
        ),
      )),
    );
  }

  SizedBox _changedPassword(BuildContext context) {
    return SizedBox(
        height: 10,
        child: TextButton(
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/profil/changePassword');
              });
            },
            child: Text('şifre değiştir')));
  }
}
