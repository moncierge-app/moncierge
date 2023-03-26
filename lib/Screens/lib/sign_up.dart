import 'package:flutter/material.dart';
import 'package:moncierge/General/user.dart';
import 'package:moncierge/Screens/lib/budgets_list.dart';
import 'package:moncierge/Utilities/user_utils.dart';

class EmailFieldValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class NameFieldValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'Name can\'t be empty' : null;
  }
}

class MobileNumberFieldValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'Mobile Number can\'t be empty' : null;
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password, _name, _mobile;

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
                    validator: EmailFieldValidator.validate,
                    onSaved: (value) => _email = value!,
                  ),
                  // Password field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: PasswordFieldValidator.validate,
                    onSaved: (value) => _password = value!,
                  ),
                  // Name field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    obscureText: false,
                    validator: NameFieldValidator.validate,
                    onSaved: (value) => _name = value!,
                  ),
                  // Mobile number field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Mobile No.'),
                    obscureText: false,
                    validator: MobileNumberFieldValidator.validate,
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
                              name: _name!,
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
