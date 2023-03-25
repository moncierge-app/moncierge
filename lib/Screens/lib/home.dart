import 'package:flutter/material.dart';
import 'package:moncierge/General/user.dart';
import 'package:moncierge/Screens/lib/sign_up.dart';
import 'package:moncierge/Screens/lib/budgets_list.dart';
import 'package:moncierge/Utilities/budget_utils.dart';
import 'package:moncierge/Utilities/notification_utils.dart';
import 'package:moncierge/Utilities/user_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Welcome to Moncierge"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Center(
                    child: Container(
                        width: 1000,
                        height: 300,
                        child: Image.asset('assets/body.jpeg')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Email', hintText: 'abc@gmail.com'),
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Password', hintText: 'Secure password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value!,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //TODO FORGOT PASSWORD SCREEN GOES HERE
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        User user = User.emailPassword(
                            email: _email!, password: _password!);
                        //Firebase authentication
                        final err = await user.signIn(
                            email: user.email, password: user.password);
                        if (err) {
                          user = await UserUtils.getUserWithEmail(_email!);
                          //Load budgets of the user
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BudgetPage(user: user)));
                        } else {
                          //   Navigator.push(
                          // context, MaterialPageRoute(builder: (_) => BudgetPage()));
                          showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Login Failed'),
                                  ));
                        }
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: const Text('New User? Create Account'),
                )
              ],
            ),
          ),
        ));
  }
}
