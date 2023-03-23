import 'package:flutter/material.dart';
import 'package:first_app/General/User.dart';
import 'package:first_app/Screens/lib/BudgetPage.dart';
import 'package:first_app/Utilities/user_utils.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password, _firstName, _lastName, _mobile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                obscureText: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your First Name';
                  }
                  return null;
                },
                onSaved: (value) => _firstName = value!,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile No'),
                obscureText: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Mobile Number';
                  }
                  return null;
                },
                onSaved: (value) => _mobile = value!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      User new_user = User();
                      new_user.email = _email.toString();
                      new_user.password = _password.toString();

                      //Firebase authentication
                      new_user.signUp(
                          email: new_user.email, password: new_user.password);

                      //Add new user to database
                      UserUtils.addNewUser(
                          new_user.email,
                          new_user.password,
                          new_user.name,
                          new_user.phoneNumber);

                      //Load budgets of the user
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => BudgetPage()));
                    }
                  },
                  child: Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
