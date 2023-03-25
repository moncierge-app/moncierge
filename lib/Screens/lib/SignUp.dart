import 'package:flutter/material.dart';

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

class FirstNameFieldValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'First Name can\'t be empty' : null;
  }
}
class LastNameFieldValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'Last Name  can\'t be empty' : null;
  }
}

class MobileNumberFieldValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'Mobile Number  can\'t be empty' : null;
  }
}

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
                validator: EmailFieldValidator.validate,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: PasswordFieldValidator.validate,
                onSaved: (value) => _password = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                obscureText: true,
                validator: FirstNameFieldValidator.validate,
                onSaved: (value) => _firstName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                obscureText: true,
                validator: LastNameFieldValidator.validate,
                onSaved: (value) => _lastName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile No'),
                obscureText: true,
                validator:MobileNumberFieldValidator.validate,
                onSaved: (value) => _mobile = value!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // TODO: Implement sign-up logic
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
