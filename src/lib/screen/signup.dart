import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components.dart';
import 'welcome.dart';
import 'login.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/data/user_class.dart';

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
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'User Type',
        ),
        items: UserType.values.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(
              type.toString().split('.').last,
              style: TextStyle(fontSize: 20),
            ),
          );
        }).toList(),
        onChanged: (val) => setState(() => _userType = val!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, WelcomeView.id);
        return true;
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const TopScreenImage(screenImageName: 'signup.png'),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                if (_formKey.currentState!.validate()) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() => _saving = true);
                                  try {
                                    await controller.signUp(
                                      email: _email,
                                      password: _password,
                                      name: _name,
                                      userType: _userType,
                                    );
                                    if (context.mounted) {
                                      signUpAlert(
                                        context: context,
                                        title: 'GOOD JOB',
                                        desc: 'Go login now',
                                        btnText: 'Login Now',
                                        onPressed: () {
                                          setState(() => _saving = false);
                                          Navigator.pushNamed(
                                              context, LoginScreen.id);
                                        },
                                      ).show();
                                    }
                                  } catch (e) {
                                    signUpAlert(
                                      context: context,
                                      onPressed: () => SystemNavigator.pop(),
                                      title: 'SOMETHING WRONG',
                                      desc: 'Close the app and try again',
                                      btnText: 'Close Now',
                                    ).show();
                                  }
                                }
                              },
                              questionPressed: () => Navigator.popAndPushNamed(
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
      ),
    );
  }
}
