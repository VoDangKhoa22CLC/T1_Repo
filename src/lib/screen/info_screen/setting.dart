import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/data/account_class.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:lookout_dev/screen/components.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});
  static String id = 'account_settings_screen';

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final controller = AccountController();
  AppUser? user;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    user = await controller.getCurrentUser();
    setState(() {}); // Update the UI after getting the user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.94),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.popAndPushNamed(context, 'home_screen'),
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
            // Check if the user data is loaded
            if (user != null)
              SimpleUserCard(
                userName: user!.name,
                userProfilePic: const AssetImage("assets/images/dummy.png"),
              ),
            // If user data is not loaded, show a loading indicator
            if (user == null) Center(child: CircularProgressIndicator()),

            SettingsGroup(
              backgroundColor: Colors.white,
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: CupertinoIcons.pencil_outline,
                  iconStyle: IconStyle(),
                  title: 'Your events',
                  subtitle: "Have a look at your attended events",
                  titleMaxLine: 1,
                  subtitleMaxLine: 1,
                ),
                SettingsItem(
                  onTap: () {},
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
                  onTap: () =>
                      Navigator.pushNamed(context, EditDisplayNameScreen.id),
                  icons: Icons.comment_outlined,
                  title: "Display name",
                  subtitle: user?.name ?? 'Not set',
                ),
                SettingsItem(
                  onTap: () => Navigator.pushNamed(context, EditEmailScreen.id),
                  icons: CupertinoIcons.mail_solid,
                  title: "Email",
                  subtitle: user?.email,
                ),
                SettingsItem(
                  onTap: () =>
                      Navigator.pushNamed(context, EditPasswordScreen.id),
                  icons: CupertinoIcons.lock,
                  title: "Password",
                  subtitle: "********",
                ),
                SettingsItem(
                  onTap: () {
                    controller.signOut();
                    controller.deleteAccount();
                    Navigator.popAndPushNamed(context, 'login_screen');
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

class EditDisplayNameScreen extends StatefulWidget {
  final AppUser? user;
  static const id = 'edit_display_name_screen';

  const EditDisplayNameScreen({Key? key, this.user}) : super(key: key);

  @override
  _EditDisplayNameScreenState createState() => _EditDisplayNameScreenState();
}

class _EditDisplayNameScreenState extends State<EditDisplayNameScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final AccountController _accountController = AccountController();

  @override
  void initState() {
    super.initState();
    _displayNameController.text = widget.user?.name ?? '';
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.user?.name = _displayNameController.text;
        _accountController.updateInfo(widget.user!);
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Success',
        desc: 'Your display name has been updated.',
        onDismissCallback: (type) {
          Navigator.popAndPushNamed(context, 'account_settings_screen');
        },
        headerAnimationLoop: false,
        btnOkOnPress: () {
          Navigator.popAndPushNamed(context, 'account_settings_screen');
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
        title: const Text('Edit Display Name'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          onPressed: () =>
              Navigator.popAndPushNamed(context, 'account_settings_screen'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildInputField(
                hintText: 'New name',
                onChanged: (value) => _displayNameController.text = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new name';
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

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _accountController.changeEmail(_emailController.text);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email updated successfully!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Email'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          onPressed: () =>
              Navigator.popAndPushNamed(context, 'account_settings_screen'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildInputField(
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
  final TextEditingController _passwordController = TextEditingController();
  final AccountController _accountController = AccountController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        // Handle password update here
        _accountController.changePassword(_passwordController.text);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Password updated successfully!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Password'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          onPressed: () =>
              Navigator.popAndPushNamed(context, 'account_settings_screen'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildInputField(
                hintText: 'Password',
                onChanged: (value) => _passwordController.text = value,
                validator: (value) => value!.length < 8
                    ? 'Password must be at least 8 characters'
                    : null, // Can replace with a function here
                obscureText: true,
              ),
              SizedBox(height: 20),
              buildInputField(
                hintText: 'Re-enter Password',
                onChanged: (value) {},
                validator: (value) => value != _passwordController.text
                    ? 'Passwords do not match'
                    : null, // Can replace with a function here
                obscureText: true,
              ),
              SizedBox(height: 20),
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
