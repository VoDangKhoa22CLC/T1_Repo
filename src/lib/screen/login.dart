import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/welcome.dart';
import 'components.dart';
import 'home.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lookout_dev/controller/account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = AccountController();
  late String _email;
  late String _password;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, WelcomeView.id);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, WelcomeView.id);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const TopScreenImage(screenImageName: 'welcome.png'),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ScreenTitle(title: 'Login'),
                        buildInputField(
                          hintText: 'Email',
                          onChanged: (value) => _email = value,
                          validator: (value) => !value!.contains('@')
                              ? 'Please enter a valid email'
                              : null, // Can replace with a function here
                        ),
                        buildInputField(
                          hintText: 'Password',
                          onChanged: (value) => _password = value,
                          validator: (value) => value!.length < 8
                              ? 'Password must be at least 8 characters'
                              : null, // Can replace with a function here
                          obscureText: true,
                        ),
                        CustomBottomScreen(
                          textButton: 'Login',
                          heroTag: 'login_btn',
                          question: 'Forgot password?',
                          buttonPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              _saving = true;
                            });
                            try {
                              controller.signIn(
                                  email: _email, password: _password);

                              if (context.mounted) {
                                setState(() {
                                  _saving = false;
                                  Navigator.popAndPushNamed(
                                      context, LoginScreen.id);
                                });
                                Navigator.pushNamed(context, Home.id);
                              }
                            } catch (e) {
                              signUpAlert(
                                context: context,
                                onPressed: () {
                                  setState(() {
                                    _saving = false;
                                  });
                                  Navigator.popAndPushNamed(
                                      context, LoginScreen.id);
                                },
                                title: 'WRONG PASSWORD OR EMAIL',
                                desc:
                                    'Confirm your email and password and try again',
                                btnText: 'OK',
                              ).show();
                            }
                          },
                          questionPressed: () {
                            signUpAlert(
                              onPressed: () async {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: _email);
                              },
                              title: 'RESET YOUR PASSWORD',
                              desc:
                                  'Click on the button to reset your password',
                              btnText: 'Reset Now',
                              context: context,
                            ).show();
                          },
                        ),
                        Text(
                          'Sign up using',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: MediaQuery.of(context).size.width *
                                0.04, // Responsive font size
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: CircleAvatar(
                            radius: MediaQuery.of(context).size.width *
                                0.08, // Responsive radius
                            backgroundColor: Colors.transparent,
                            child:
                                Image.asset('assets/images/icons/google.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
