import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/home.dart';
import 'package:lookout_dev/template/text_input_decorations.dart';


class LogIn extends StatefulWidget {
  final Function toggle;
  const LogIn({super.key, required this.toggle});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  // final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;


  String email = '';
  String password = '';
  String errorMsg = 'none';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(7, 0, 166, 1),
        elevation: 0.0,
        title: const Text('Log In'),
        actions: <Widget>[
          TextButton.icon(
              icon: const Icon(Icons.person),
              onPressed: () {},
              label: const Text('Register'),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0,),
              TextFormField(
                // decoration: textInputDecoration.copyWith(hintText: "Email"),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                // decoration: textInputDecoration.copyWith(hintText: "Password"),
                validator: (val) => val!.length < 6 ? 'Password must be longer than 6' : null,
                obscureText: true,
                onChanged: (val){
                  setState(() => password = val);
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home())
                    );
                  },
                  child: const Text("Sign in")
              ),
              const SizedBox(height: 20.0,),
              Text(
                errorMsg,
                style: const TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
      )
    );
  }

}
