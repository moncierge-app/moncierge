import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:email_validator/email_validator.dart';

class AddAnExpensePage extends StatefulWidget {
  @override
  _AddAnExpensePageState createState() => _AddAnExpensePageState();
}

class _AddAnExpensePageState extends State<AddAnExpensePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Add an Expense'),
          ),
          body: MyCustomForm()),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;

  late DateTime _expenseAdditionDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter your full name',
              labelText: 'Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          // TextFormField(
          //   decoration: const InputDecoration(
          //     icon: const Icon(Icons.phone),
          //     hintText: 'Enter a phone number',
          //     labelText: 'Phone',
          //   ),
          //   validator: (value) {
          //     if (value!.isEmpty) {
          //       return 'Please enter valid phone number';
          //     }
          //     return null;
          //   },
          // ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.currency_rupee),
              hintText: 'Enter Amount Spent',
              labelText: 'Amount',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.payments_rounded),
              hintText: 'Whom was the payment done to',
              labelText: 'Paid To',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.mail),
              hintText: "Enter user's mail id",
              labelText: 'Mail Id',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field cant remain empty.';
              }
              if (!EmailValidator.validate(value)) {
                return "Invalid email address.";
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              icon: const Icon(Icons.category),
              hintText: 'Select a category',
              labelText: 'Category',
            ),
            value: _selectedCategory,
            items: [
              DropdownMenuItem(
                value: 'Option 1',
                child: Text('Option 1'),
              ),
              DropdownMenuItem(
                value: 'Option 2',
                child: Text('Option 2'),
              ),
              DropdownMenuItem(
                value: 'Option 3',
                child: Text('Option 3'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field cant remain empty.';
              }

              return null;
            },
          ),

          TextFormField(
            controller: _dateController,
            decoration: InputDecoration(
              hintText: 'Choose the date of payment',
              labelText: 'Date of Payment',
              prefixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
            readOnly: true,
            validator: (_selectedDate) {
              if (_selectedDate!.isEmpty) {
                return 'Please enter valid date';
              }
              return null;
            },
          ),
          new Container(
              padding: const EdgeInsets.only(left: 150.0, top: 0.0),
              child: new ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a Snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Data is in processing.')));
                  } else {
                    _expenseAdditionDate = DateTime.now();
                  }
                },
              )),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _dateController.text = intl.DateFormat.yMd().format(_selectedDate!);
      });
  }
}
