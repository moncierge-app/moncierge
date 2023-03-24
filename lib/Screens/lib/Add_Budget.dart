import 'package:flutter/foundation.dart';

import 'BudgetPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

class AddSupervisorBudget extends StatefulWidget {
  // const AddSupervisorBudget({Key? key}) ;
  const AddSupervisorBudget({Key? key}) : super(key: key);
  @override
  State<AddSupervisorBudget> createState() => _AddSupervisorBudget();
}

void _showDatePicker(context) {
  showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2025),
  );
}

bool validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

class _AddSupervisorBudget extends State<AddSupervisorBudget> {
  @override
  final formKey = GlobalKey<FormState>();
  String? categories;
  DateTime creationTime = DateTime.now();
  late DateTime endTime;
  final TextEditingController _dateController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 150,
            padding: EdgeInsets.fromLTRB(20, 60, 10, 10),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.yellow],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60)),
            ),
            child: Text("Create Budget",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
              width: MediaQuery.of(context).size.width - 50,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Enter Budget's name",
                          icon: const Icon(Icons.arrow_forward)),
                      validator: (value) {
                        if (value!.isEmpty ||
                            RegExp(r'^[a-z A-Z 0-9]').hasMatch(value)) {
                          return "Budget name is invalid";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        // icon: const Icon(Icons.calendar_today),
                        // hintText: 'Enter Total Expense',
                        icon: const Icon(Icons.currency_rupee),
                        labelText: 'Total Amount',
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            RegExp(r'^[0-9 .]').hasMatch(value)) {
                          return "expense is invalid";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        hintText: 'End time',
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
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.category),
                        hintText: 'Select a category',
                        labelText: 'Category',
                      ),
                      value: categories,
                      items: [
                        DropdownMenuItem(
                          value: 'Food',
                          child: Text('Food'),
                        ),
                        DropdownMenuItem(
                          value: 'Travel',
                          child: Text('Travel'),
                        ),
                        DropdownMenuItem(
                          value: 'Personal Expense',
                          child: Text('Personal Expense'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          categories = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field cant remain empty.';
                        }

                        return null;
                      },
                    ),
                    // end date
                    // add member button
                    TextButton(
                      onPressed: () {
                        AddMember(context);
                      },
                      child: Text(
                        'Add new Member',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        AddSupervisor(context);
                      },
                      child: Text(
                        'Add Supervisor',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    // submit button
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // add the budget to data base
                        // budgets.add()

                        submit(context);
                      },
                      child: Text(
                        'Create',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //
                  ],
                ),
              ))
        ],
      )),
    );
  }

  Future AddMember(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Add Supervisor Id"),
          content: TextFormField(
            autofocus: true,
            decoration: InputDecoration(labelText: "Enter Supervisor ID"),
            validator: (value) {
              if (value!.isEmpty || !validateEmail(value)) {
                return "Supervisor is invalid";
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
  Future AddSupervisor(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Add Member Id"),
          content: TextFormField(
            autofocus: true,
            decoration: InputDecoration(labelText: "Enter Member ID"),
            validator: (value) {
              if (value!.isEmpty || !validateEmail(value)) {
                return "MemberId is invalid";
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
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != creationTime)
      setState(() {
        creationTime = picked;
        _dateController.text = intl.DateFormat.yMd().format(creationTime!);
      });
  }
}

void submit(context) {
  Navigator.of(context).pop();
}

// Future AddMember(context) => showDialog(
//   context: context, 
//   builder: (context)=>AlertDialog(
//     title: Text("Add Member Id"),

//   ),
// )

