import 'package:moncierge/General/budget.dart';
import 'package:moncierge/Screens/lib/expenses.dart';
import 'package:moncierge/Screens/lib/home.dart';
import 'package:moncierge/Utilities/budget_utils.dart';
import 'add_budget.dart';
import 'package:flutter/material.dart';
import 'package:moncierge/General/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

class BudgetPage extends StatefulWidget {
  User user;
  BudgetPage({required this.user});
  @override
  State<BudgetPage> createState() => _BudgetPage();
}

class _BudgetPage extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: h,
              ),
              child: Column(children: [
                TextButton(
                  child: const Text('Sign Out'),
                  onPressed: () async {
                    widget.user.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginDemo()),
                        (route) => false);
                  },
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  width: w,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddBudget(user: widget.user)));
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                    const Text("Create new budget",
                        style: TextStyle(
                          fontSize: 28,
                        )),
                  ]),
                ),
                Text(
                  'Member',
                  style: TextStyle(fontSize: 19),
                ),
                FutureBuilder(
                    future: getMemberBudgets(),
                    builder: (context, AsyncSnapshot<List<Budget>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            child: Card(
                              elevation: 5.0,
                              color: const Color.fromARGB(211, 186, 104, 200),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const SizedBox(width: 5.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Colors.purple[200],
                                                  foregroundColor:
                                                      Colors.purple[200],
                                                  backgroundImage: const AssetImage(
                                                      'assets/budget_icon.png'),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 50, 10),
                                                  width: 200,
                                                  child: Text(
                                                      snapshot.data![index]
                                                          .budgetName,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20.0,
                                                          letterSpacing: 1.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Text(
                                                    '${snapshot.data![index].amountUsed} / ${snapshot.data![index].totalAmount}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 50, 10),
                                                  width: w * 0.7,
                                                  child: const Text(
                                                      'Know Your Expenses',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) => ExpensesPage(
                                                                  user: widget
                                                                      .user,
                                                                  budgetID: snapshot
                                                                      .data![
                                                                          index]
                                                                      .budgetId)));
                                                    },
                                                    child: const Icon(
                                                        Icons.arrow_forward,
                                                        color: Colors.amber),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 20, 0, 10),
                                                  width: w * 0.7,
                                                  child: Text(
                                                      'Validity from ${snapshot.data![index].creationTime.day}.${snapshot.data![index].creationTime.month}.${snapshot.data![index].creationTime.year} to ${snapshot.data![index].endTime.day}.${snapshot.data![index].endTime.month}.${snapshot.data![index].endTime.year}',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 20, 0, 10),
                                                  width: w * 0.7,
                                                  child: const Text(
                                                      "Budget's User",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Users Using this Budget'),
                                                              content:
                                                                  Container(
                                                                width: double
                                                                    .minPositive,
                                                                child: ListView
                                                                    .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: snapshot
                                                                      .data![
                                                                          index]
                                                                      .membersId
                                                                      .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int i) {
                                                                    return ListTile(
                                                                      title: Text(snapshot
                                                                          .data![
                                                                              index]
                                                                          .membersId[i]),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context,
                                                                            snapshot.data![index].membersId[i]);
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: const Icon(
                                                        Icons.info_outline,
                                                        color: Colors.amber),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 20, 0, 10),
                                                  width: w * 0.7,
                                                  child: const Text(
                                                      "Budget's Supervisor",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'List of supervisor'),
                                                              content:
                                                                  Container(
                                                                width: double
                                                                    .minPositive,
                                                                child: ListView
                                                                    .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: snapshot
                                                                      .data![
                                                                          index]
                                                                      .supervisorsId
                                                                      .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int i) {
                                                                    return ListTile(
                                                                      title: Text(snapshot
                                                                          .data![
                                                                              index]
                                                                          .supervisorsId[i]),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context,
                                                                            snapshot.data![index].supervisorsId[i]);
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: const Icon(
                                                        Icons.list,
                                                        color: Colors.amber),
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
                      } else
                        return Center(child: CircularProgressIndicator());
                    }),
                SizedBox(height: 10),
                Text(
                  'Supervisor',
                  style: TextStyle(fontSize: 19),
                ),
                FutureBuilder(
                    future: getSupervisorBudgets(),
                    builder: (context, AsyncSnapshot<List<Budget>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            child: Card(
                              elevation: 5.0,
                              color: const Color.fromARGB(211, 186, 104, 200),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const SizedBox(width: 5.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Colors.purple[200],
                                                  foregroundColor:
                                                      Colors.purple[200],
                                                  backgroundImage: const AssetImage(
                                                      'assets/budget_icon.png'),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 50, 10),
                                                  width: 200,
                                                  child: Text(
                                                      snapshot.data![index]
                                                          .budgetName,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20.0,
                                                          letterSpacing: 1.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Text(
                                                    '${snapshot.data![index].amountUsed} / ${snapshot.data![index].totalAmount}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 50, 10),
                                                  width: w * 0.7,
                                                  child: const Text(
                                                      'Know Your Expenses',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) => ExpensesPage(
                                                                  user: widget
                                                                      .user,
                                                                  budgetID: snapshot
                                                                      .data![
                                                                          index]
                                                                      .budgetId)));
                                                    },
                                                    child: const Icon(
                                                        Icons.arrow_forward,
                                                        color: Colors.amber),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 20, 0, 10),
                                                  width: w * 0.7,
                                                  child: Text(
                                                      'Validity from ${snapshot.data![index].creationTime.day}.${snapshot.data![index].creationTime.month}.${snapshot.data![index].creationTime.year} to ${snapshot.data![index].endTime.day}.${snapshot.data![index].endTime.month}.${snapshot.data![index].endTime.year}',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 20, 0, 10),
                                                  width: w * 0.7,
                                                  child: const Text(
                                                      "Budget's User",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Users Using this Budget'),
                                                              content:
                                                                  Container(
                                                                width: double
                                                                    .minPositive,
                                                                child: ListView
                                                                    .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: snapshot
                                                                      .data![
                                                                          index]
                                                                      .membersId
                                                                      .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int i) {
                                                                    return ListTile(
                                                                      title: Text(snapshot
                                                                          .data![
                                                                              index]
                                                                          .membersId[i]),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context,
                                                                            snapshot.data![index].membersId[i]);
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: const Icon(
                                                        Icons.info_outline,
                                                        color: Colors.amber),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 20, 0, 10),
                                                  width: w * 0.7,
                                                  child: const Text(
                                                      "Budget's Supervisor",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'List of supervisor'),
                                                              content:
                                                                  Container(
                                                                width: double
                                                                    .minPositive,
                                                                child: ListView
                                                                    .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: snapshot
                                                                      .data![
                                                                          index]
                                                                      .supervisorsId
                                                                      .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int i) {
                                                                    return ListTile(
                                                                      title: Text(snapshot
                                                                          .data![
                                                                              index]
                                                                          .supervisorsId[i]),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context,
                                                                            snapshot.data![index].supervisorsId[i]);
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: const Icon(
                                                        Icons.list,
                                                        color: Colors.amber),
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
                      } else
                        return Center(child: CircularProgressIndicator());
                    })
              ]),
            ),
          ),
        ));
  }

  Future<List<Budget>> getMemberBudgets() async {
    List<Budget> budgets =
        await BudgetUtils.getBudgetsForUser(widget.user.email);
    return budgets;
  }

  Future<List<Budget>> getSupervisorBudgets() async {
    List<Budget> budgets =
        await BudgetUtils.getBudgetsForSupervisor(widget.user.email);
    return budgets;
  }
}
