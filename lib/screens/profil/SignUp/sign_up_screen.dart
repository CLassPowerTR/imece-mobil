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
  String? errorMessage;
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Klavye açıldığında UI'nın kaymasını engeller
      appBar: SignInAppBar(context),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          spacing: 15,
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            headText(context),
            emailAdressContainer(width, context,
                textFieldHeight: 50,
                containerHeight: 80,
                controller: emailController),
            usernameContainer(width, context,
                textFieldHeight: 50,
                containerHeight: 80,
                controller: usernameController),
            passwordContainer(width, context,
                textFieldHeight: 50,
                containerHeight: 80,
                obscureText: showPassword,
                showSuffixIcon: true, onTap: () {
              setState(() {
                showPassword = !showPassword;
              });
            }, textFieldController: passwordController),
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
            NextButton(context, isCheckedContract, minSizeHeight: 50,
                onPressed: () async {
              setState(() {
                isLoading = true;
                errorMessage = null;
              });
              try {
                await ApiService.fetchUserRegister(
                  emailController.text.trim(),
                  usernameController.text.trim(),
                  passwordController.text.trim(),
                );
                setState(() {
                  isLoading = false;
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kayıt başarılı!')),
                  );
                  ref.read(bottomNavIndexProvider.notifier).state = 3;
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false,
                      arguments: {'refresh': true});
                }
              } catch (e) {
                setState(() {
                  isLoading = false;
                  errorMessage = e.toString();
                });
              }
            }),
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
            )
          ],
        ),
      )),
    );
  }
}
