import 'package:flutter/material.dart';
import 'components.dart'; // Ensure these imports are correct
import 'login.dart';
import 'signup.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});
  static String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopScreenImage(screenImageName: 'home.jpg'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const ScreenTitle(title: 'Hello'),
                      Text(
                        'Welcome to Lookout, your gateway to campus events! Let’s make every moment count together!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.width *
                              0.05, // Responsive font size
                        ),
                      ),
                      const SizedBox(height: 15),
                      Hero(
                        tag: 'login_btn',
                        child: CustomButton(
                          buttonText: 'Login',
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Hero(
                        tag: 'signup_btn',
                        child: CustomButton(
                          buttonText: 'Sign Up',
                          isOutlined: true,
                          onPressed: () {
                            Navigator.pushNamed(context, SignUpScreen.id);
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
