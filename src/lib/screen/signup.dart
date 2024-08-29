import 'package:flutter/material.dart';
import 'components.dart';
import 'welcome.dart';
import 'login.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/data/account_class.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final controller = AccountController();
  final _formKey = GlobalKey<FormState>();
  late String _email = '';
  late String _password = '';
  late String _name = '';
  late UserType _userType = UserType.Student;
  bool _saving = false;

  Widget _buildDropdown() {
    return CustomTextField(
      child: DropdownButtonFormField(
        value: _userType,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'User Type',
        ),
        items: UserType.values.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(
              type.toString().split('.').last,
              style: const TextStyle(fontSize: 20),
            ),
          );
        }).toList(),
        onChanged: (val) => setState(() => _userType = val!),
      ),
    );
  }

  void _showVerificationDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.topSlide,
      title: 'Verify Your Email',
      desc:
          'A verification email has been sent to your email address. Please verify your email before logging in.',
      btnOkOnPress: () =>
          Navigator.pushReplacementNamed(context, LoginScreen.id),
      btnOkColor: kTextColor,
    ).show();
  }

  String? extractAdminAccountName(String input) {
    if (input.contains('ඞඞlookoutadminඞඞ')) {
      return input.replaceAll('ඞඞlookoutadminඞඞ', '');
    }
    return null;
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const TopScreenImage(
                                  screenImageName: 'signup.png'),
                              //if (constraints.maxHeight > 700)

                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const ScreenTitle(title: 'Sign Up'),
                                      _buildDropdown(),
                                      CustomInputField(
                                        hintText: _userType == UserType.Student
                                            ? 'Student Name'
                                            : 'Club Name',
                                        onChanged: (value) => _name = value,
                                        validator: (value) => value!.isEmpty
                                            ? 'Please enter a name'
                                            : null,
                                      ),
                                      CustomInputField(
                                        hintText: 'Email',
                                        onChanged: (value) => _email = value,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                              .hasMatch(value)) {
                                            return 'Please enter a valid email address';
                                          }
                                          return null;
                                        },
                                      ),
                                      PasswordInputField(
                                        hintText: 'Password',
                                        onChanged: (value) => _password = value,
                                        validator: (value) => value!.length < 8
                                            ? 'Password must be at least 8 characters'
                                            : null,
                                      ),
                                      PasswordInputField(
                                        hintText: 'Confirm password',
                                        onChanged: (value) {},
                                        validator: (value) => value != _password
                                            ? 'Passwords do not match'
                                            : null,
                                      ),
                                      CustomBottomScreen(
                                        textButton: 'Sign Up',
                                        heroTag: 'signup_btn',
                                        question: 'Have an account?',
                                        buttonPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            setState(() => _saving = true);
                                            AppUser? user;
                                            String? errorMessage;
                                            if (extractAdminAccountName(
                                                        _name) !=
                                                    null &&
                                                _userType == UserType.Club) {
                                              _name = extractAdminAccountName(
                                                  _name)!;
                                              (user, errorMessage) =
                                                  await controller
                                                      .createAdminAccount(
                                                email: _email,
                                                password: _password,
                                                name: _name,
                                              );
                                            } else {
                                              (user, errorMessage) =
                                                  await controller.signUp(
                                                email: _email,
                                                password: _password,
                                                name: _name,
                                                userType: _userType,
                                              );
                                            }
                                            if (user != null) {
                                              if (context.mounted) {
                                                setState(() {
                                                  _saving = false;
                                                });
                                                _showVerificationDialog();
                                              }
                                            } else {
                                              if (context.mounted) {
                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType.error,
                                                  animType: AnimType.topSlide,
                                                  title: 'Sign Up Failed',
                                                  desc: errorMessage,
                                                  onDismissCallback: (type) {
                                                    setState(() {
                                                      _saving = false;
                                                    });
                                                  },
                                                  headerAnimationLoop: false,
                                                  btnOkOnPress: () {
                                                    setState(
                                                        () => _saving = false);
                                                  },
                                                  btnOkColor: kTextColor,
                                                ).show();
                                              }
                                            }
                                          }
                                        },
                                        questionPressed: () =>
                                            Navigator.popAndPushNamed(
                                                context, LoginScreen.id),
                                      ),
                                    ],
                                  ),
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
