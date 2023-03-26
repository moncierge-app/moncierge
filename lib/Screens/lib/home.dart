import 'package:flutter/material.dart';
import 'package:moncierge/General/user.dart';
import 'package:moncierge/Screens/lib/sign_up.dart';
import 'package:moncierge/Screens/lib/budgets_list.dart';
import 'package:moncierge/Utilities/user_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  const LoginDemo({super.key});

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

// Login screen
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
          // Login form
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Center(
                    child: SizedBox(
                        width: 1000,
                        height: 300,
                        child: Image.asset('assets/body.jpeg')),
                  ),
                ),
                // Email id field
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
                // Password field
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
                // Login button
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      // check if form state if valid
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // create a user object
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
                          showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Invalid Credentials!'),
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
                // Signup option for new users
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
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
