import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_app/Expenses.dart';
// To Be Replaced
List<String> budgets = [
  "Travel",
  "Food",
  "College_Expenses",
  "1",
  "2",
  "4",
  "4"
];

// To Be Replaced
List<String> users_supervisor = [
  "Son",
  "Daughter",
  "Student",
];

const num_item_to_be_displayed = 2;
class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  State<BudgetPage> createState() => _BudgetPage();
}

class _BudgetPage extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(children: [
        Expanded(
          flex: 0,
          child: Container(
            alignment: Alignment.center,
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.blue.shade800),
            child: Text("Welcome to Moncierge",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white)),
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildListView(),
        ),
        Expanded(
          flex: 1,
          child: _buildListViewSupervisor(users_supervisor),
        ),
        Expanded(
          flex: 0,
          child: ListView.builder(
            itemCount: 1,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) => Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              height: 100,
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(0.0),
                    color: Color.fromARGB(255, 166, 232, 229),
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            // color: Colors.blue.shade200,

                            child: Text("Create new Budget",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30.0,
                                    fontStyle: FontStyle.italic)),
                          ),
                          SizedBox(width: 5.0),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: FloatingActionButton(
                          onPressed: () {

                          },
                          backgroundColor: Color.fromARGB(255, 161, 154, 239),
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

ListView _buildListView() {
  return ListView.builder(
    itemCount: num_item_to_be_displayed,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) => Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
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
                  Container(
                    width: 55.0,
                    height: 55.0,
                    // color: Colors.blue.shade200,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.blue,
                      backgroundImage: AssetImage('assets/budget_icon.png'),
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(budgets[index],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)),
                      Text('Know your expenses',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => ExpensesPage()));
                  },
                  backgroundColor: Color.fromARGB(255, 154, 202, 239),
                  child: Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}



ListView _buildListViewSupervisor(List<String> myList) {
  return ListView.builder(
    itemCount: num_item_to_be_displayed,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) => Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
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
                  Container(
                    width: 55.0,
                    height: 55.0,
                    // color: Colors.blue.shade200,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.blue,
                      //backgroundImage: Image.asset('assets/body.jpeg')),

                      backgroundImage: AssetImage('assets/supervisor.png'),
                    ),
                  ),
                  SizedBox(width: 2.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(myList[index],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)),
                      Text('Know your expenses',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: FloatingActionButton(
                  onPressed: () {

                  },
                  backgroundColor: Color.fromARGB(255, 154, 202, 239),
                  child: Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}