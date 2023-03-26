import 'package:flutter/material.dart';
import 'package:moncierge/General/user.dart';
import 'package:moncierge/Screens/lib/budgets_list.dart';
import 'package:moncierge/Utilities/user_utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password, _firstName, _mobile;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: h,
            ),
            // Sign up form
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Email field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                  ),
                  // Password field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value!,
                  ),
                  // Name field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Name';
                      }
                      return null;
                    },
                    onSaved: (value) => _firstName = value!,
                  ),
                  // Mobile number field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Mobile No.'),
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Mobile Number';
                      }
                      return null;
                    },
                    onSaved: (value) => _mobile = value!,
                  ),
                  // submit button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // check form state
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Create user object
                          User newUser = User(
                              name: _firstName!,
                              phoneNumber: _mobile!,
                              email: _email!,
                              password: _password!);

                          //Firebase authentication
                          newUser.signUp(
                              email: newUser.email, password: newUser.password);

                          //Add new user to database
                          UserUtils.addNewUser(newUser.email, newUser.password,
                              newUser.name, newUser.phoneNumber);

                          //Load budgets of the user
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BudgetPage(user: newUser)));
                        }
                      },
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
