//utility class to handle data visualization on each budget page
//visualization will be done for the total spent as well as  category wise spent
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// Generates Pie Chart for categorywise split of expenses in a budget
class CategoryData {
  String category;
  int amount;
  charts.Color barColor;
  CategoryData(
      {required this.category, required this.amount, required this.barColor});
}

List<CategoryData> data = [];

Future<void> createCategoryWiseList(String budgetID) async {
  var budgetDocument =
      await FirebaseFirestore.instance.collection('Budget').doc(budgetID).get();
  // get data from budget collection
  int currentAmount1 = budgetDocument['amountUsed'];
  int totalAmount1 = budgetDocument['totalAmount'];

  //adding the overall budget status bars
  data.add(
    CategoryData(
      category: 'Total',
      amount: totalAmount1,
      barColor: charts.ColorUtil.fromDartColor(
          const Color.fromARGB(255, 101, 245, 142)),
    ),
  );

  data.add(
    CategoryData(
      category: 'Current Spent',
      amount: currentAmount1,
      barColor: charts.ColorUtil.fromDartColor(
          const Color.fromARGB(255, 241, 109, 109)),
    ),
  );

  // getting current and total amount for each category in the current budget
  //storing the above values in the dynamic list;
  List<dynamic> categories = budgetDocument['Categories'];
  for (var i = 0; i < categories.length; i++) {
    await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .collection('Categories')
        .doc(categories[i]['categoryName'])
        .get();

    data.add(
      CategoryData(
        category: categories[i]['categoryName'] + ' Limit',
        amount: categories[i]['amount'],
        barColor: charts.ColorUtil.fromDartColor(
            const Color.fromARGB(255, 101, 245, 142)),
      ),
    );

    data.add(
      CategoryData(
        category: categories[i]['categoryName'] + ' Used',
        amount: categories[i]['amountUsed'],
        barColor: charts.ColorUtil.fromDartColor(
            const Color.fromARGB(255, 241, 109, 109)),
      ),
    );
  }
}

@override
// Build the Pie Chart
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Current Status of your Budget'),
      centerTitle: true,
    ),
    body: Center(
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                const Text(
                  "Current Status of your Budget",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: charts.BarChart(
                    _getSeriesData(),
                    animate: true,
                    domainAxis: const charts.OrdinalAxisSpec(
                        renderSpec:
                            charts.SmallTickRendererSpec(labelRotation: 60)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

_getSeriesData() {
  List<charts.Series<CategoryData, String>> series = [
    charts.Series(
        id: "Amount",
        data: data,
        domainFn: (CategoryData series, _) => series.category.toString(),
        measureFn: (CategoryData series, _) => series.amount,
        colorFn: (CategoryData series, _) => series.barColor)
  ];
  return series;
}
