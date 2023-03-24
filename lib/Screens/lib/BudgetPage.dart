import 'dart:html';
import 'Add_Budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

List<List<String>> membersId = [
  ["abc@gmail.com", "shakshi@gmail.com"],
  ["saurav@gmail.com", "sachi@gmail.com", "Rohan@gmail.com"],
  ["priyu@gmail.com", "kailash@gmail.com"],
  ["shakshi@gmail.com"],
  []
];

List<List<String>> supervisorId = [
  ["abc@gmail.com", "shakshi@gmail.com"],
  ["saurav@gmail.com", "sachi@gmail.com", "Rohan@gmail.com"],
  ["priyu@gmail.com", "kailash@gmail.com"],
  ["shakshi@gmail.com"],
  []
];

List<String> budgets = ["Travel", "Food", "College", "stationary", "shaid"];
List<num> current_expense = [
  200.00,
  300.20,
  2000,
  2000,
  2000,
];
List<num> total_expense = [1000.00, 500.00, 5000, 5000, 6000];
final now = DateTime.now();
DateTime date = new DateTime(now.year, now.month, now.day);
List<DateTime> creationTime = [date, date, date, date, date];
List<DateTime> endTime = [date, date, date, date, date];

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);
  @override
  State<BudgetPage> createState() => _BudgetPage();
}

class _BudgetPage extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                padding: const EdgeInsets.fromLTRB(150, 20, 20, 20),
                height: 100.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(255, 29, 45, 128),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Text('My Budgets',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ))),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey.shade600,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: FloatingActionButton(
                    heroTag: 'create_budget',
                    onPressed: () {
                      // _showSupervisedDialogBox(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddSupervisorBudget()));
                    },
                    backgroundColor: Color.fromARGB(255, 166, 241, 238),
                    child: Icon(Icons.add),
                  ),
                ),
                Text("new",
                    style: TextStyle(
                      fontSize: 28,
                    )),
                Text(" Budget",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    )),
              ]),
            ),
            Container(
              child: _buildListView(),
            ),
          ]),
        ));
  }
}

ListView _buildListView() {
  return ListView.builder(
    itemCount: budgets.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) => Container(
      // double width = MediaQuery. of(context). size. width,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        elevation: 5.0,
        color: Color.fromARGB(211, 186, 104, 200),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 5.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            // width: 1.0,
                            // height: 40.0,
                            // color: Colors.purple/[300],
                            child: CircleAvatar(
                              backgroundColor: Colors.purple[200],
                              foregroundColor: Colors.purple[200],
                              backgroundImage:
                                  AssetImage('images/budget_icon.png'),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 50, 10),
                            width: 200,
                            child: Text(budgets[index],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                                '\$${current_expense[index].toString()} / \$${total_expense[index].toString()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 50, 10),
                            width: 300,
                            child: Text('Know Your Expenses',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: FloatingActionButton(
                              heroTag: 'expense',
                              onPressed: () {},
                              child: Icon(Icons.arrow_forward),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                            width: 400,
                            child: Text(
                                'Validity from ${creationTime[index].day}.${creationTime[index].month}.${creationTime[index].year} to ${endTime[index].day}.${endTime[index].month}.${endTime[index].year}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                            width: 300,
                            child: Text("Budget's User",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: FloatingActionButton(
                              heroTag: 'users',
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Users Using this Budget'),
                                        content: Container(
                                          width: double.minPositive,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: membersId[index].length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return ListTile(
                                                title:
                                                    Text(membersId[index][i]),
                                                onTap: () {
                                                  Navigator.pop(context,
                                                      membersId[index][i]);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    });
                              },
                              backgroundColor:
                                  Color.fromARGB(255, 120, 199, 212),
                              child: Icon(Icons.info_outline),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                            width: 300,
                            child: Text("Budget's Supervisor",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: FloatingActionButton(
                              heroTag: 'supervisors',
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('List of supervisor'),
                                        content: Container(
                                          width: double.minPositive,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                supervisorId[index].length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return ListTile(
                                                title: Text(
                                                    supervisorId[index][i]),
                                                onTap: () {
                                                  Navigator.pop(context,
                                                      supervisorId[index][i]);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    });
                              },
                              backgroundColor: Color.fromARGB(255, 33, 91, 100),
                              child: Icon(Icons.list),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}