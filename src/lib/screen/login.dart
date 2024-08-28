import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/welcome.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'components.dart';
import 'home.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = AccountController();
  final _formKey = GlobalKey<FormState>();
  late String _email = '';
  late String _password = '';
  bool _saving = false;

  void _showResetPasswordDialog(String title, String message) {
    AwesomeDialog(
      context: context,
      dialogType: title == 'Success' ? DialogType.success : DialogType.error,
      animType: AnimType.topSlide,
      title: title,
      desc: message,
      headerAnimationLoop: false,
      btnOkOnPress: () {},
      btnOkColor: kTextColor,
    ).show();
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String email = '';
        return AlertDialog(
          title: const Text('Reset Password'),
          backgroundColor: Colors.white,
          content: TextField(
            onChanged: (value) {
              email = value;
            },
            decoration: const InputDecoration(
                hintText: "Enter your email", hoverColor: kBackgroundColor),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: kTextColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send Reset Link',
                  style: TextStyle(color: kTextColor)),
              onPressed: () async {
                if (email.isNotEmpty) {
                  setState(() {
                    _saving = true;
                  });
                  Navigator.of(context).pop();
                  String? result = await controller.resetPassword(email);
                  setState(() {
                    _saving = false;
                  });
                  if (result == null) {
                    _showResetPasswordDialog(
                        'Success', 'Password reset link sent to your email.');
                  } else {
                    _showResetPasswordDialog('Error', result);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        Navigator.popAndPushNamed(context, WelcomeScreen.id);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, WelcomeScreen.id);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const TopScreenImage(
                                  screenImageName: 'welcome.png'),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const ScreenTitle(title: 'Login'),
                                    buildInputField(
                                      hintText: 'Email',
                                      onChanged: (value) => _email = value,
                                      validator: (value) =>
                                          !value!.contains('@')
                                              ? 'Please enter a valid email'
                                              : null,
                                    ),
                                    buildInputField(
                                      hintText: 'Password',
                                      onChanged: (value) => _password = value,
                                      validator: (value) => value!.length < 8
                                          ? 'Password must be at least 8 characters'
                                          : null,
                                      obscureText: true,
                                    ),
                                    CustomBottomScreen(
                                      textButton: 'Login',
                                      heroTag: 'login_btn',
                                      question: 'Forgot password?',
                                      buttonPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          setState(() {
                                            _saving = true;
                                          });
                                          var (user, errorMessage) =
                                              await controller.signIn(
                                            email: _email,
                                            password: _password,
                                          );
                                          if (user != null) {
                                            if (context.mounted) {
                                              setState(() {
                                                _saving = false;
                                              });
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.success,
                                                animType: AnimType.topSlide,
                                                title: 'Login Successful',
                                                desc:
                                                    'Welcome back, ${user.name}!',
                                                headerAnimationLoop: false,
                                                btnOkOnPress: () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, Home.id);
                                                },
                                                btnOkColor: kTextColor,
                                              ).show();
                                            }
                                          } else {
                                            if (context.mounted) {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.error,
                                                animType: AnimType.topSlide,
                                                title: 'Login Failed',
                                                desc: errorMessage,
                                                headerAnimationLoop: false,
                                                btnOkOnPress: () {
                                                  setState(() {
                                                    _saving = false;
                                                  });
                                                },
                                                btnOkColor: kTextColor,
                                              ).show();
                                            }
                                          }
                                        }
                                      },
                                      questionPressed: () {
                                        // Reset password
                                        _handleForgotPassword();
                                      },
                                    ),
                                    Row(children: <Widget>[
                                      const Expanded(child: Divider()),
                                      Text(
                                        'OR',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04, // Responsive font size
                                        ),
                                      ),
                                      const Expanded(child: Divider()),
                                    ]),
                                    SignInButton(
                                      Buttons.google,
                                      text: "Sign in with Google",
                                      onPressed: () async {
                                        var (user, errorMessage) =
                                            await controller.signInWithGoogle();
                                        if (user != null) {
                                          if (context.mounted) {
                                            setState(() {
                                              _saving = false;
                                            });
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.success,
                                              animType: AnimType.topSlide,
                                              title: 'Login Successful',
                                              desc:
                                                  'Welcome back, ${user.name}!',
                                              headerAnimationLoop: false,
                                              btnOkOnPress: () {
                                                Navigator.pushReplacementNamed(
                                                    context, Home.id);
                                              },
                                              btnOkColor: kTextColor,
                                            ).show();
                                          }
                                        } else {
                                          if (context.mounted) {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.topSlide,
                                              title: 'Login Failed',
                                              desc: errorMessage,
                                              headerAnimationLoop: false,
                                              btnOkOnPress: () {
                                                setState(() {
                                                  _saving = false;
                                                });
                                              },
                                              btnOkColor: kTextColor,
                                            ).show();
                                          }
                                        }
                                      },
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
              },
            ),
          ),
        ),
      ),
    );
  }
}
