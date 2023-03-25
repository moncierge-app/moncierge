import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:moncierge/General/budget.dart';
import 'package:moncierge/General/user.dart';
import 'package:moncierge/Utilities/budget_utils.dart';

class AddBudget extends StatefulWidget {
  User user;
  AddBudget({required this.user});
  @override
  State<AddBudget> createState() => _AddBudget();
}

bool validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

class _AddBudget extends State<AddBudget> {
  final formKey = GlobalKey<FormState>();
  String budgetName = '';
  int totalAmount = 0;
  DateTime creationTime = DateTime.now();
  late DateTime endTime;
  List<Category> categories = [];
  List<String> members = [];
  List<String> supervisors = [];

  final TextEditingController endDateController = TextEditingController();
  TextEditingController budgetNameController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 150,
            padding: const EdgeInsets.fromLTRB(20, 60, 10, 10),
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
            child: const Text("Create Budget",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 50, 10, 10),
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
                      controller: budgetNameController,
                      decoration: const InputDecoration(
                          labelText: "Enter Budget's name",
                          icon: Icon(Icons.arrow_forward)),
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
                      controller: totalAmountController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.currency_rupee),
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
                      controller: endDateController,
                      decoration: InputDecoration(
                        hintText: 'End time',
                        labelText: 'Last Valid Date of Budget',
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      readOnly: true,
                      validator: (selectedDate) {
                        if (selectedDate!.isEmpty) {
                          return 'Please enter valid date';
                        }
                        return null;
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        addCategory(context);
                      },
                      child: const Text(
                        'Add Categories',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        addMember(context);
                      },
                      child: const Text(
                        'Add new Member',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        addSupervisor(context);
                      },
                      child: const Text(
                        'Add Supervisor',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    // submit button
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (members.isNotEmpty &&
                            categories.isNotEmpty &&
                            budgetNameController.text != '' &&
                            totalAmountController.text != '' &&
                            endDateController.text != '') {
                          totalAmount = int.parse(totalAmountController.text);
                          budgetName = budgetNameController.text;
                          Budget budget = Budget(
                              '${widget.user.email}|$creationTime',
                              budgetName,
                              creationTime,
                              endTime,
                              members,
                              supervisors,
                              [],
                              categories,
                              totalAmount,
                              0);
                          widget.user.budgetIDs.add(budget.budgetId);
                          await BudgetUtils.createBudget(
                              budgetName,
                              creationTime,
                              widget.user.email,
                              endTime,
                              supervisors,
                              members,
                              categories,
                              totalAmount);
                          Navigator.of(context).pop();
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AlertDialog(
                                          title: const Text('Invalid Input'),
                                          content: const Text(
                                              'Please fill all the fields appropriately'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Ok'))
                                          ])));
                        }
                      },
                      child: const Text(
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

  Future addCategory(context) => showDialog(
      context: context,
      builder: (context) {
        TextEditingController categoryNameController = TextEditingController();
        TextEditingController warningAmountController = TextEditingController();
        TextEditingController totalAmountController = TextEditingController();
        return AlertDialog(
          title: const Text("Add Category name"),
          content: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    controller: categoryNameController,
                    autofocus: true,
                    decoration:
                        const InputDecoration(labelText: "Enter Category name"),
                  ),
                  TextFormField(
                    controller: warningAmountController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: const InputDecoration(
                        labelText: "Enter warning amount"),
                  ),
                  TextFormField(
                    controller: totalAmountController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration:
                        const InputDecoration(labelText: "Enter total amount"),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (categoryNameController.text == '' ||
                      warningAmountController.text == '' ||
                      totalAmountController.text == '') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AlertDialog(
                                    title: const Text('Invalid Input'),
                                    content: const Text(
                                        'Please fill all the fields appropriately'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Ok'))
                                    ])));
                  } else {
                    int warningAmount = int.parse(warningAmountController.text),
                        totalAmount = int.parse(totalAmountController.text);
                    if (warningAmount > totalAmount) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AlertDialog(
                                      title: const Text('Invalid Input'),
                                      content: const Text(
                                          'Please fill all the fields appropriately'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Ok'))
                                      ])));
                    } else {
                      categories.add(Category(
                          category: categoryNameController.text,
                          warningAmount: warningAmount,
                          totalAmount: totalAmount,
                          amountUsed: 0));
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Text('SUBMIT'))
          ],
        );
      });

  Future addMember(context) {
    return showDialog(
        context: context,
        builder: (context) {
          TextEditingController memberIDController = TextEditingController();
          return AlertDialog(
            title: const Text("Add Member Id"),
            content: TextFormField(
              controller: memberIDController,
              autofocus: true,
              decoration: const InputDecoration(labelText: "Enter Member ID"),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (memberIDController.text != '' &&
                        await BudgetUtils.checkIfUserExists(
                            memberIDController.text)) {
                      members.add(memberIDController.text);
                      Navigator.of(context).pop();
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AlertDialog(
                                      title: const Text('Invalid Input'),
                                      content: const Text(
                                          'Please fill all the fields appropriately'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Ok'))
                                      ])));
                    }
                  },
                  child: const Text('SUBMIT'))
            ],
          );
        });
  }

  Future addSupervisor(context) => showDialog(
        context: context,
        builder: (context) {
          TextEditingController supervisorIDController =
              TextEditingController();
          return AlertDialog(
            title: const Text("Add Supervisor ID"),
            content: TextFormField(
              controller: supervisorIDController,
              autofocus: true,
              decoration:
                  const InputDecoration(labelText: "Enter Supervisor ID"),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (supervisorIDController.text != '' &&
                        await BudgetUtils.checkIfUserExists(
                            supervisorIDController.text)) {
                      supervisors.add(supervisorIDController.text);
                      Navigator.of(context).pop();
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AlertDialog(
                                      title: const Text('Invalid Input'),
                                      content: const Text(
                                          'Please fill all the fields appropriately'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Ok'))
                                      ])));
                    }
                  },
                  child: const Text('SUBMIT'))
            ],
          );
        },
      );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != creationTime) {
      setState(() {
        endTime = picked;
        endDateController.text = intl.DateFormat.yMd().format(creationTime);
      });
    }
  }
}
