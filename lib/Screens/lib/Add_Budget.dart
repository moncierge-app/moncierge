import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:moncierge/General/budget.dart';
import 'package:moncierge/General/user.dart';
import 'package:moncierge/Screens/lib/Reusable/alert_message.dart';
import 'package:moncierge/Screens/lib/budgets_list.dart';
import 'package:moncierge/Utilities/budget_utils.dart';

class AddBudget extends StatefulWidget {
  final User user;
  const AddBudget({super.key, required this.user});
  @override
  State<AddBudget> createState() => _AddBudget();
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
              // Form for bugdet creation
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Budget name field
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
                    // Total amount field
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
                    // End Date field
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
                    // Category field
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
                    // Members field
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
                    // Supervisors field
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
                        // Check if any compulsory field is empty
                        if (members.isNotEmpty &&
                            categories.isNotEmpty &&
                            budgetNameController.text != '' &&
                            totalAmountController.text != '' &&
                            endDateController.text != '') {
                          totalAmount = int.parse(totalAmountController.text);
                          budgetName = budgetNameController.text;

                          // Check if sum of limits of all categories doesn't exceed the budget limit
                          int totalOfCategories = 0;
                          for (Category category in categories) {
                            totalOfCategories += category.totalAmount;
                          }
                          if (totalOfCategories > totalAmount) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => alertMessage(context,
                                        content:
                                            'The categorywise sum of limits should not exceed overall limit!')));
                          } else {
                            // create budget object
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
                            // add to user's budget list
                            widget.user.budgetIDs.add(budget.budgetId);
                            // Add budget to database
                            await BudgetUtils.createBudget(
                                budgetName,
                                creationTime,
                                widget.user.email,
                                endTime,
                                supervisors,
                                members,
                                categories,
                                totalAmount);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            // redirect to budget lists screen
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        BudgetPage(user: widget.user)));
                          }
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => alertMessage(context,
                                      content:
                                          'Budget creation failed due to invalid inputs!')));
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

  //popup widget to add category
  Future addCategory(context) => showDialog(
      context: context,
      builder: (context) {
        TextEditingController categoryNameController = TextEditingController();
        TextEditingController warningAmountController = TextEditingController();
        TextEditingController totalAmountController = TextEditingController();
        return AlertDialog(
          title: const Text("Add Category"),
          content: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Category name field
                  TextFormField(
                    controller: categoryNameController,
                    autofocus: true,
                    decoration:
                        const InputDecoration(labelText: "Enter Category name"),
                  ),
                  // Category warning amount field
                  TextFormField(
                    controller: warningAmountController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: const InputDecoration(
                        labelText: "Enter warning amount"),
                  ),
                  // Category total amount field
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
                  // Check if any field is empty
                  if (categoryNameController.text == '' ||
                      warningAmountController.text == '' ||
                      totalAmountController.text == '') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => alertMessage(context,
                                content:
                                    'Please fill all the compulsory fields!')));
                  } else {
                    int warningAmount = int.parse(warningAmountController.text),
                        totalAmount = int.parse(totalAmountController.text);
                    if (warningAmount > totalAmount) {
                      // check if warning amount > total amount
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => alertMessage(context,
                                  content:
                                      'Warning Amount must not exceed Total Amount!')));
                    } else {
                      // add to categoris list
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

  //popup widget to add member
  Future addMember(context) {
    return showDialog(
        context: context,
        builder: (context) {
          TextEditingController memberIDController = TextEditingController();
          return AlertDialog(
            title: const Text("Add Member"),
            // Member ID field
            content: TextFormField(
              controller: memberIDController,
              autofocus: true,
              decoration: const InputDecoration(labelText: "Enter Member ID"),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    //Check if input is empty or invalid
                    if (memberIDController.text != '' &&
                        await BudgetUtils.checkIfUserExists(
                            memberIDController.text)) {
                      members.add(memberIDController.text);
                      Navigator.of(context).pop();
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => alertMessage(context,
                                  content: 'Please enter a valid user ID')));
                    }
                  },
                  child: const Text('SUBMIT'))
            ],
          );
        });
  }

  //popup widget to add supervisor
  Future addSupervisor(context) => showDialog(
        context: context,
        builder: (context) {
          TextEditingController supervisorIDController =
              TextEditingController();
          return AlertDialog(
            title: const Text("Add Supervisor"),
            //supervisor id field
            content: TextFormField(
              controller: supervisorIDController,
              autofocus: true,
              decoration:
                  const InputDecoration(labelText: "Enter Supervisor ID"),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    // Check if supervisor id is empty or invalid
                    if (supervisorIDController.text != '' &&
                        await BudgetUtils.checkIfUserExists(
                            supervisorIDController.text)) {
                      supervisors.add(supervisorIDController.text);
                      Navigator.of(context).pop();
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => alertMessage(context,
                                  content: 'Please add a valid user ID')));
                    }
                  },
                  child: const Text('SUBMIT'))
            ],
          );
        },
      );

  //date picker
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
