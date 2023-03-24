import 'package:first_app/Screens/lib/BudgetPage.dart';
import 'package:flutter/material.dart';
import 'package:first_app/Screens/lib/SignUp.dart';
import 'package:first_app/General/User.dart';
import 'package:first_app/Utilities/user_utils.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Login Page"),
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
                        // decoration: BoxDecoration(
                        //     color: Colors.red,
                        //     borderRadius: BorderRadius.circular(5.0)),
                        child: Image.asset('/assets/body.jpeg')),
                  ),
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
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
                    decoration: InputDecoration(
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
                  child: Text(
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

                        User user = User();
                        user.email = _email.toString();
                        user.password = _password.toString();

                        //Firebase authentication
                        final err = await user.signIn(
                            email: user.email, password: user.password);

                        if (err) {
                          //Load budgets of the user
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => BudgetPage()));
                        } else {
                          //   Navigator.push(
                          // context, MaterialPageRoute(builder: (_) => BudgetPage()));
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Login Failed'),
                                  ));
                        }
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text('New User? Create Account'),
                )
              ],
            ),
          ),
        ));
  }
}
