import 'package:first_app/main.dart';
import 'package:first_app/Add_An_Expense.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/main.dart';
import 'package:intl/intl.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

// Replace this List with the list fetched from the database
// To Be Replaced
String payment_Date = DateFormat('dd/MM/yyyy').format(DateTime.now());
List<Map<String, dynamic>> products = [
  {
    'Date of Payment': "16/03/23",
    'Paid To': 'Product 1',
    'Category': 'flight ticket',
    'Payment Mode': "UPI",
    'Amount Spent': 40.00
  },
  {
    'Date of Payment': "16/03/23",
    'Paid To': 'Product 1',
    'Category': 'food',
    'Payment Mode': "UPI",
    'Amount Spent': 40.00
  },
  {
    'Date of Payment': "16/03/23",
    'Paid To': 'Product 1',
    'Category': 'travel',
    'Payment Mode': "UPI",
    'Amount Spent': 40.00
  },
  {
    'Date of Payment': "16/03/23",
    'Paid To': 'Product 1',
    'Category': 'miscellaneous',
    'Payment Mode': "UPI",
    'Amount Spent': 40.00
  },
];

// To Be Replaced
DateTime date_Of_Expiry = DateTime.now();

String formatted_Date_Of_Expiry =
    DateFormat('dd/MM/yyyy').format(date_Of_Expiry);

// To Be Replaced
DateTime date_Of_Creation = DateTime.now();

String formatted_Date_Of_Creation =
DateFormat('dd/MM/yyyy').format(date_Of_Expiry);

class _ExpensesPageState extends State<ExpensesPage> {
  final TextEditingController _textEditingController = TextEditingController();
  int _selectedIndex = -1;

  // To Be Replaced
  final threshold_Amount = 65;
  // To Be Replaced
  final expense_Max_Limit = 100;
  // To Be Replaced
  final current_Expense = 25;

  final _scrollController = ScrollController();

  void _showEditDialog(int index) {
    setState(() {
      _selectedIndex = index;
      _textEditingController.text = products[index]['Amount Spent'].toString();
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Amount Spent'),
          content: TextFormField(
            controller: _textEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a value';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Amount Spent',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                setState(() {
                  _selectedIndex = -1;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('SAVE'),
              onPressed: () {

                if (_textEditingController.text.isNotEmpty &&
                    double.tryParse(_textEditingController.text) != null) {
                  setState(() {
                    products[index]['Amount Spent'] =
                        double.parse(_textEditingController.text);
                    _selectedIndex = -1;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Transaction Details'),
          ),
          body: Center(
            child: Column(children: <Widget>[
              SizedBox(height: 20),
              Container(
                height: 40,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => AddAnExpensePage()));
                  },
                  icon: SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(Icons.add, color: Colors.black),
                  ),
                  label: Text(
                    'Add an Expense',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Maximum Expense Limit: "),
                          Expanded(
                            child: Text("$expense_Max_Limit"),
                          ),
                        ],
                      ),
                      SizedBox(height: 10), // add space between rows

                      Row(
                        children: [
                          Text("Threshold Amount: "),
                          Expanded(
                            child: Text("$threshold_Amount"),
                          ),
                        ],
                      ),
                      SizedBox(height: 10), // add space between rows

                      Row(
                        children: [
                          Text("Date of Expiry : "),
                          Expanded(
                            child: Text("$formatted_Date_Of_Expiry."),
                          ),
                        ],
                      ),
                      SizedBox(height: 10), // add space between rows

                      Row(
                        children: [
                          Text("Date of Creation : "),
                          Expanded(
                            child: Text("$formatted_Date_Of_Creation"),
                          ),
                        ],
                      ),

                      SizedBox(height: 10), // add space between rows

                      Row(
                        children: [
                          Text("Amount Spent : "),
                          Expanded(
                            child: Text("$current_Expense"),
                          ),
                        ],
                      ),
                    ],
                  )),
              SizedBox(height: 10),
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    child: FittedBox(
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(
                            label: Text(
                              'Paid On' ,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                              maxLines: 3,
                            ),
                          ),
                          DataColumn(label: Text('Paid to')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Mode')),
                        ],
                        rows: List<DataRow>.generate(
                          products.length,
                              (index) => DataRow(
                            cells: [
                              DataCell(Text(products[index]['Date of Payment'].toString())),
                              DataCell(Text(products[index]['Paid To'])),
                              DataCell(Text(products[index]['Category'].toString())),
                              DataCell(
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      Text(products[index]['Amount Spent'].toString()),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                  onTap: () {
                                    _showEditDialog(index);
                                  },
                                ),
                              ),
                              DataCell(Text(products[index]['Payment Mode'].toString())),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            //child:
          )),
    );
  }
}

// STATIC Table code :

// return Scaffold(
// appBar: AppBar(
// title: Text('Home Page'),
// ),
// body: Center(
// child: Container(
// height: 80,
// width: 150,
// decoration: BoxDecoration(
// color: Colors.blue, borderRadius: BorderRadius.circular(10)),
// child: TextButton(
// onPressed: () {
// Navigator.pop(context);
// },
// child: Text(
// 'Welcome',
// style: TextStyle(color: Colors.white, fontSize: 25),
// ),
// ),
// ),
// ),
// );
// DETAILS OF BUDGET + EXPENSES
//
