import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/data/account_class.dart';
import 'package:lookout_dev/screen/components.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});
  static String id = 'account_settings_screen';

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final controller = AccountController();
  AppUser? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future _getUser() async {
    AppUser? appUser = await AccountController().getCurrentUser();

    if (appUser != null) {
      setState(() {
        _user = appUser;
      });
    }
  }

  void refresh() {
    setState(() {
      _getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.94),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            if (_user == null)
              const Text('An error occurred while loading user data'),
            SettingsGroup(
              backgroundColor: Colors.white,
              settingsGroupTitle: "Information",
              items: [
                SettingsItem(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                  icons: Icons.info_rounded,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.purple,
                  ),
                  title: 'About',
                  subtitle: "Learn more about Lookout",
                ),
              ],
            ),
            SettingsGroup(
              backgroundColor: Colors.white,
              settingsGroupTitle: "Account",
              items: [
                SettingsItem(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEmailScreen(user: _user),
                      ),
                    );
                  },
                  icons: CupertinoIcons.mail_solid,
                  title: "Email",
                  subtitle: _user?.email,
                ),
                SettingsItem(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPasswordScreen(user: _user),
                      ),
                    );
                  },
                  icons: CupertinoIcons.lock,
                  title: "Password",
                  subtitle: "********",
                ),
                SettingsItem(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Confirm Account Deletion',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          content: const Text(
                              'Are you sure you want to DELETE your account?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                // Close the dialog and do nothing
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Confirm',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                controller.signOut();
                                controller.deleteAccount();
                                Navigator.popAndPushNamed(
                                    context, 'welcome_screen');
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icons: CupertinoIcons.delete_solid,
                  title: "Delete account",
                  titleStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditEmailScreen extends StatefulWidget {
  final AppUser? user;
  static const id = 'edit_email_screen';

  const EditEmailScreen({Key? key, this.user}) : super(key: key);

  @override
  _EditEmailScreenState createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AccountController _accountController = AccountController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user?.email ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      bool verify =
          await _accountController.verifyPassword(_passwordController.text);
      if (verify == false) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'Error',
          desc: 'Incorrect password. Please try again.',
          onDismissCallback: (type) {},
          headerAnimationLoop: false,
          btnOkOnPress: () {},
          btnOkColor: kTextColor,
        ).show();

        return;
      }
      setState(() {
        _accountController.changeEmail(_emailController.text);
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.topSlide,
        title: 'Verify Your Email',
        desc:
            'A verification email has been sent to your email address. Your email has been changed but not verified.',
        onDismissCallback: (type) {
          Navigator.pop(context);
        },
        headerAnimationLoop: false,
        btnOkOnPress: () {
          Navigator.pop(context);
        },
        btnOkColor: kTextColor,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Email'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Update your email',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please enter your new email and current password. We will send you a verification email. You will need to confirm the new email address.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomInputField(
                hintText: 'New Email',
                onChanged: (value) => _emailController.text = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              PasswordInputField(
                hintText: 'Current Password',
                onChanged: (value) => _passwordController.text = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonText: 'Save Changes',
                onPressed: _saveChanges,
                width: 160,
                fontSize: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditPasswordScreen extends StatefulWidget {
  final AppUser? user;
  static const id = 'edit_password_screen';

  const EditPasswordScreen({Key? key, this.user}) : super(key: key);

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AccountController _accountController = AccountController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      bool verify =
          await _accountController.verifyPassword(_oldPasswordController.text);
      if (verify == false) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'Error',
          desc: 'Incorrect password. Please try again.',
          onDismissCallback: (type) {},
          headerAnimationLoop: false,
          btnOkOnPress: () {},
          btnOkColor: kTextColor,
        ).show();

        return;
      }

      setState(() {
        _accountController.changePassword(_passwordController.text);
        _oldPasswordController.text = '';
        _passwordController.text = '';
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: 'Success',
        desc: 'Password changed successfully!',
        onDismissCallback: (type) {
          Navigator.pop(context);
        },
        headerAnimationLoop: false,
        btnOkOnPress: () {
          Navigator.pop(context);
        },
        btnOkColor: kTextColor,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Password'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Update your password',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              const Text(
                  'Please enter your existing password and your new password.'),
              const SizedBox(height: 20),
              PasswordInputField(
                hintText: 'Current Password',
                onChanged: (value) => _oldPasswordController.text = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              PasswordInputField(
                hintText: 'New Password',
                onChanged: (value) => _passwordController.text = value,
                validator: (value) => value!.length < 8
                    ? 'Password must be at least 8 characters'
                    : null,
              ),
              const SizedBox(height: 20),
              PasswordInputField(
                hintText: 'Confirm password',
                onChanged: (value) {},
                validator: (value) => value != _passwordController.text
                    ? 'Re-entered password does not match'
                    : null, // Can replace with a function here
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonText: 'Save Changes',
                onPressed: _saveChanges,
                width: 160,
                fontSize: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/logo/lookout_logo.png'),
            ),
            Text(
              'Version 1.0.0, build#1.0.0',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'This app was built by',
              textAlign: TextAlign.center,
            ),
            Text(
              '22127028 Ha Gia Bao',
              textAlign: TextAlign.center,
            ),
            Text(
              '22127200 Vo Dang Khoa',
              textAlign: TextAlign.center,
            ),
            Text(
              '22127258 Le Tri Man',
              textAlign: TextAlign.center,
            ),
            Text(
              '221272382 Cao Pham Hoang Thai',
              textAlign: TextAlign.center,
            ),
            Text(
              '221272452 Le Ngoc Vi',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
