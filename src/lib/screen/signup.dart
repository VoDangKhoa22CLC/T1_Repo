import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/home.dart';
import 'components.dart';
import 'welcome.dart';
import 'login.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/data/user_class.dart';
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
                              if (constraints.maxHeight > 600)
                                const TopScreenImage(
                                    screenImageName: 'signup.png'),
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
                                      buildInputField(
                                        hintText: _userType == UserType.Student
                                            ? 'Student Name'
                                            : 'Club Name',
                                        onChanged: (value) => _name = value,
                                        validator: (value) => value!.isEmpty
                                            ? 'Please enter a name'
                                            : null, // Can replace with a function here
                                      ),
                                      buildInputField(
                                        hintText: 'Email',
                                        onChanged: (value) => _email = value,
                                        validator: (value) => !value!
                                                .contains('@')
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
                                      buildInputField(
                                        hintText: 'Re-enter Password',
                                        onChanged: (value) {},
                                        validator: (value) => value != _password
                                            ? 'Passwords do not match'
                                            : null, // Can replace with a function here
                                        obscureText: true,
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

                                            var (
                                              AppUser? user,
                                              String? errorMessage
                                            ) = await controller.signUp(
                                              email: _email,
                                              password: _password,
                                              name: _name,
                                              userType: _userType,
                                            );
                                            if (user != null) {
                                              if (context.mounted) {
                                                setState(() {
                                                  _saving = false;
                                                });
                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.success,
                                                  animType: AnimType.topSlide,
                                                  title: 'Sign Up Successful',
                                                  desc:
                                                      'Welcome, ${user.name}!',
                                                  onDismissCallback: (type) {
                                                    setState(() {
                                                      _saving = false;
                                                    });
                                                  },
                                                  headerAnimationLoop: false,
                                                  btnOkOnPress: () {
                                                    setState(
                                                        () => _saving = false);
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
