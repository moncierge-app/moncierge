import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  final emailController = TextEditingController();
  // final auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Enter your Email-Id',
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              child: const Text("Forgot"),
              onPressed: () {
                // for authenticaton
                EnterPassword(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future EnterPassword(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Enter new Password"),
          content: TextFormField(
            autofocus: true,
            decoration: InputDecoration(labelText: "Enter  password"),
            validator: (value) {
              if (value!.isEmpty) {
                return "Password is invalid";
              } else {
                return null;
              }
            },
          ),
          actions: [
            TextButton(
                onPressed: () {
                  // membersId.add(value);
                  // enter memebr id in budget
                  submit(context);
                },
                child: Text('SUBMIT'))
          ],
        ),
      );
}

void submit(context) {
  Navigator.of(context).pop();
}
