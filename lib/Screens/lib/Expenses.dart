import 'package:flutter/material.dart';
import 'package:moncierge/General/budget.dart';
import 'package:moncierge/General/expense.dart';
import 'package:moncierge/General/user.dart';
import 'package:moncierge/Screens/lib/add_an_expense.dart';
import 'package:moncierge/Utilities/budget_utils.dart';
import 'package:pie_chart/pie_chart.dart';

class ExpensesPage extends StatefulWidget {
  final User user;
  final String budgetID;
  final bool isMember;
  const ExpensesPage(
      {super.key,
      required this.user,
      required this.budgetID,
      required this.isMember});

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

Map<String, double> getMap(List<Expenses> expenses) {
  Map<String, double> datamap =
      expenses.fold({}, (Map<String, double> acc, product) {
    String category = product.category;
    double amount = product.amount.toDouble();
    acc.update(category, (value) => value + amount, ifAbsent: () => amount);
    return acc;
  });

  return datamap;
}

class _ExpensesPageState extends State<ExpensesPage> {
  late Budget budget;
  List<Expenses> expenses = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Transaction Details'),
          ),
          body: SingleChildScrollView(
            child: FutureBuilder(
                future: getBudgetandExpenses(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData == false) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(children: <Widget>[
                    const SizedBox(height: 20),
                    // If the user is member, they can add expense
                    Visibility(
                      visible: widget.isMember,
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            width: 250,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AddAnExpensePage(
                                            user: widget.user,
                                            budget: budget)));
                              },
                              icon: const SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(Icons.add, color: Colors.black),
                              ),
                              label: const Text(
                                'Add an Expense',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    // Details of budget
                    Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Maximum Expense Limit: "),
                                Expanded(
                                  child: Text("${budget.totalAmount}"),
                                ),
                              ],
                            ),
                            const SizedBox(
                                height:
                                    10), // add space between rows// add space between rows

                            Row(
                              children: [
                                const Text("Date of Expiry: "),
                                Expanded(
                                  child: Text(
                                      "${budget.endTime.day} / ${budget.endTime.month} / ${budget.endTime.year}"),
                                ),
                              ],
                            ),
                            const SizedBox(
                                height: 10), // add space between rows

                            Row(
                              children: [
                                const Text("Date of Creation: "),
                                Expanded(
                                  child: Text(
                                      "${budget.creationTime.day} / ${budget.creationTime.month} / ${budget.creationTime.year}"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text("Amount Spent: "),
                                Expanded(
                                  child: Text("${budget.amountUsed}"),
                                ),
                              ],
                            ),
                          ],
                        )),
                        // Pie chart of categorywise split of budget
                    const SizedBox(height: 10),
                    (expenses.isNotEmpty)
                        ? Column(
                            children: [
                              const Text('Categorywise split',
                                  style: TextStyle(fontSize: 18)),
                              PieChart(
                                dataMap: getMap(expenses),
                                chartRadius:
                                    MediaQuery.of(context).size.width / 2.7,
                                legendOptions: const LegendOptions(
                                  legendTextStyle: TextStyle(fontSize: 16),
                                  showLegendsInRow: false,
                                  legendPosition: LegendPosition.right,
                                ),
                                chartValuesOptions: const ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: true,
                                  showChartValuesInPercentage: true,
                                  showChartValuesOutside: true,
                                  decimalPlaces: 1,
                                ),
                              ),
                            ],
                          )
                        : const Text('---'),
                    const SizedBox(height: 20),
                    // Expenses table of budget
                    const Text('Expenses', style: TextStyle(fontSize: 18)),
                    (expenses.isNotEmpty)
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FittedBox(
                              child: DataTable(
                                columnSpacing: 10,
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      'Amount',
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      maxLines: 3,
                                    ),
                                  ),
                                  DataColumn(label: Text('Category')),
                                  DataColumn(label: Text('Spent By')),
                                  DataColumn(label: Text('Paid to')),
                                  DataColumn(label: Text('Paid On')),
                                  DataColumn(label: Text('Mode')),
                                  DataColumn(label: Text('Decription'))
                                ],
                                rows: List<DataRow>.generate(
                                  expenses.length,
                                  (index) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(expenses[index].amount.toString()),
                                      ),
                                      DataCell(Text(expenses[index].category)),
                                      DataCell(Text(expenses[index].getUserId)),
                                      DataCell(Text(expenses[index].receiver)),
                                      DataCell(Text(
                                          '${expenses[index].timeOfPayment.day}/${expenses[index].timeOfPayment.month}/${expenses[index].timeOfPayment.year}')),
                                      DataCell(Text(expenses[index]
                                          .paymentMode
                                          .toString())),
                                      DataCell(
                                          Text(expenses[index].description))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const Text('---'),
                  ]);
                }),
            //child:
          )),
    );
  }

  // Get budget details and its coressponding expense details
  Future<List<Expenses>> getBudgetandExpenses() async {
    String budgetID = widget.budgetID;
    budget = await BudgetUtils.getBudget(budgetID);
    expenses = [];
    for (var expenseID in budget.expenses) {
      Expenses expense = await BudgetUtils.getExpense(budgetID, expenseID);
      expenses.add(expense);
    }
    return expenses;
  }
}
