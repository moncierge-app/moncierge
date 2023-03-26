import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:moncierge/General/budget.dart';
import 'package:moncierge/General/expense.dart';
import 'package:moncierge/General/user.dart';
import 'package:moncierge/Screens/lib/Reusable/alert_message.dart';
import 'package:moncierge/Screens/lib/budgets_list.dart';
import 'package:moncierge/Utilities/budget_utils.dart';

class AddAnExpensePage extends StatefulWidget {
  final User user;
  final Budget budget;
  final List<String> categories = [];
  AddAnExpensePage({super.key, required this.user, required this.budget});
  @override
  _AddAnExpensePageState createState() => _AddAnExpensePageState();
}

class _AddAnExpensePageState extends State<AddAnExpensePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Add an Expense'),
          ),
          body: MyCustomForm(user: widget.user, budget: widget.budget)),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  final Budget budget;
  final User user;
  const MyCustomForm({super.key, required this.budget, required this.user});
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

  final TextEditingController datePaymentMadeController =
      TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController receiverController = TextEditingController();
  TextEditingController payementModeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool updatedDate = false;
  String _selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    // Initialise with default values
    DateTime creationTime = DateTime.now();
    String category = '';
    return FutureBuilder(
        future: BudgetUtils.getCategoriesForBudget(widget.budget.budgetId),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          }
          category = snapshot.data![0];
          if (_selectedCategory == '') _selectedCategory = category;
          return SingleChildScrollView(
            // Add expense form
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Amount field
                  TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.currency_rupee),
                        hintText: 'Enter Amount Spent',
                        labelText: 'Amount',
                      )),
                  // Receiver field
                  TextFormField(
                      controller: receiverController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.payments_rounded),
                        hintText: 'Whom was the payment done to',
                        labelText: 'Receiver',
                      )),
                  // Payment mode field
                  TextFormField(
                      controller: payementModeController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.mode),
                        hintText: 'UPI, Cash, Bank Transaction etc.',
                        labelText: 'Payment Mode',
                      )),
                  // Category field
                  DropdownButtonFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.category),
                        hintText: 'Select a category',
                        labelText: 'Category',
                      ),
                      value: _selectedCategory,
                      items: List.generate(
                          snapshot.data!.length,
                          (index) => DropdownMenuItem(
                              value: snapshot.data![index],
                              child: Text(snapshot.data![index]))),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      }),
                  // Date of Payment field
                  TextFormField(
                      controller: datePaymentMadeController,
                      decoration: InputDecoration(
                        hintText: 'Choose the date of payment',
                        labelText: 'Date of Payment',
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      readOnly: true),
                  // Description field (Optional)
                  TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.notes),
                        hintText: 'Description (Optional)',
                        labelText: 'Anything you want',
                      )),
                  // Submit button
                  Container(
                      padding: const EdgeInsets.only(left: 150.0, top: 0.0),
                      child: ElevatedButton(
                        child: const Text('SUBMIT'),
                        onPressed: () async {
                          // It returns true if the form is valid, otherwise returns false
                          if (_formKey.currentState!.validate()) {
                            //Check if all required fields are entered
                            if (amountController.text == '' ||
                                receiverController.text == '' ||
                                payementModeController.text == '' ||
                                _selectedCategory == '' ||
                                !updatedDate) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => alertMessage(context,
                                          content:
                                              'Please fill all the compulsory fields!')));
                            } else {
                              try {
                                int amount = int.parse(amountController.text);
                                String receiver = receiverController.text;
                                String paymentMode =
                                    payementModeController.text;
                                DateTime paymentAddedTime = _selectedDate;
                                String description = descriptionController.text;
                                bool expenseAdded =
                                    await BudgetUtils.addExpense(
                                        widget.user.email,
                                        widget.budget.budgetId,
                                        amount,
                                        _selectedCategory,
                                        paymentMode,
                                        receiver,
                                        description,
                                        creationTime,
                                        paymentAddedTime);
                                if (!expenseAdded) {
                                  // check if expense addition was successful
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => alertMessage(context,
                                              content: 'Enter valid inputs!')));
                                } else {
                                  // Create expense object
                                  Expenses(
                                      userId: widget.user.email,
                                      budgetId: widget.budget.budgetId,
                                      amount: amount,
                                      category: _selectedCategory,
                                      paymentMode: paymentMode,
                                      description: description,
                                      timeOfExpenseAddition: creationTime,
                                      timeOfPayment: paymentAddedTime,
                                      receiver: receiver);

                                  // Convert datetimestamp to string and convert to second precision
                                  String timeStampAddedString =
                                      creationTime.toString();
                                  timeStampAddedString =
                                      timeStampAddedString.substring(
                                          0, timeStampAddedString.length - 7);
                                  widget.budget.expenses.add(
                                      '${widget.user.email}|$timeStampAddedString');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              BudgetPage(user: widget.user)));
                                }
                              } catch (e) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => alertMessage(context)));
                              }
                            }
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => alertMessage(context)));
                          }
                        },
                      )),
                ],
              ),
            ),
          );
        });
  }

  // Date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        updatedDate = true;
        datePaymentMadeController.text =
            intl.DateFormat.yMd().format(_selectedDate);
      });
    }
  }
}
