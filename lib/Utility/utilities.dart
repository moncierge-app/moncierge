// Utility class to manage all the database access operations
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class Utilities {
  // To check if a user with given userID exists or not
  Future<bool> checkIfUserExists(String userID) async {
    var data =
        await FirebaseFirestore.instance.collection('User').doc(userID).get();
    if (data.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkExpenseValid(String budgetID, DateTime timestampAdded) async {
    var budgetInfo = await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .get();
    if (timestampAdded.compareTo(budgetInfo['creationTime']) >= 0 &&
        timestampAdded.compareTo(budgetInfo['endTime']) <= 0) return true;
    return false;
  }

  // To create a budget with given inputs
  Future<bool> createBudget(
      String budgetName,
      DateTime creationTime,
      String creatorEmailID,
      DateTime endTime,
      List<String> supervisorIDs,
      List<String> memberIDs,
      List<dynamic> categories,
      int totalAmount,
      List<String> expenseList) async {
    try {
      String creationTimeString = creationTime.toString();

      // Convert datetimestamp to string and convert to second precision
      creationTimeString =
          creationTimeString.substring(0, creationTimeString.length - 7);

      String budgetID = '$creatorEmailID|$creationTimeString';
      // Create a budget document with standard datatype fields
      var budgetCollectionObject =
          FirebaseFirestore.instance.collection('Budget');
      await budgetCollectionObject.doc(budgetID).set({
        'budgetName': budgetName,
        'creationTime':
            creationTime.day + creationTime.month + creationTime.year,
        'endTime': endTime,
        'totalAmount': totalAmount,
        'amountUsed': 0
      });

      // Add Supervisor list as subcollection
      for (var i = 0; i < supervisorIDs.length; i++) {
        await budgetCollectionObject
            .doc(budgetID)
            .collection('Supervisors')
            .doc(supervisorIDs[i])
            .set({});
      }

      // Add Member list as subcollection
      for (var i = 0; i < memberIDs.length; i++) {
        await budgetCollectionObject
            .doc(budgetID)
            .collection('Members')
            .doc(memberIDs[i])
            .set({});
      }

      // Add category list as subcollection
      for (var i = 0; i < categories.length; i++) {
        await budgetCollectionObject
            .doc(budgetID)
            .collection('Categories')
            .doc(categories[i]['categoryName'])
            .set({
          'warningAmount': categories[i]['warningAmount'],
          'amount': categories[i]['amount']
        });
      }

      // Update users entries
      var userCollectionObject = FirebaseFirestore.instance.collection('User');

      // Update supervisors of the budget
      for (var i = 0; i < supervisorIDs.length; i++) {
        await userCollectionObject
            .doc(supervisorIDs[i])
            .collection('SupervisorOf')
            .doc(budgetID)
            .set({});
      }

      // Update members of the budget
      for (var i = 0; i < memberIDs.length; i++) {
        await userCollectionObject
            .doc(memberIDs[i])
            .collection('MemberOf')
            .doc(budgetID)
            .set({});
      }
      return true;
    } catch (exception) {
      return false;
    }
  }

  // To create an expense with given inputs and add to budget
  Future<bool> addExpense(
      String creatorID,
      String budgetID,
      int amount,
      String category,
      String paymentMode,
      String receiver,
      String description,
      DateTime timestampAdded,
      DateTime timestampPaymentMade) async {
    try {
      var expenseCollectionObject =
          FirebaseFirestore.instance.collection('Expense');

      // Convert datetimestamp to string and convert to second precision
      String timeStampAddedString = timestampAdded.toString();
      timeStampAddedString =
          timeStampAddedString.substring(0, timeStampAddedString.length - 7);
      String timestampPaymentMadeString = timestampPaymentMade.toString();
      timestampPaymentMadeString = timestampPaymentMadeString.substring(
          0, timestampPaymentMadeString.length - 7);

      // Create an expense document
      expenseCollectionObject.doc(creatorID + timeStampAddedString).set({
        'userID': creatorID,
        'budgetID': budgetID,
        'amount': amount,
        'category': category,
        'paymentMode': paymentMode,
        'receiver': receiver,
        'description': description,
        'timestampAdded': timeStampAddedString,
        'timestampPaymentMade': timestampPaymentMadeString
      });

      //Update budget document
      var budgetCollectionObject =
          FirebaseFirestore.instance.collection('Budget');
      budgetCollectionObject
          .doc(budgetID)
          .collection('Expenses')
          .doc(creatorID + timeStampAddedString)
          .set({});
      var budgetInfo =
          budgetCollectionObject.doc(budgetID).get().then((budgetInfo) => {
                budgetCollectionObject
                    .doc(budgetID)
                    .set({'amountUsed': amount + budgetInfo['amountUsed']})
              });
      return true;
    } catch (exception) {
      return false;
    }
  }

  Future<List> getBudgetsForUser(String userID) async {
    List budgets = [];
    var budgetIDs = await FirebaseFirestore.instance
        .collection('User')
        .doc(userID)
        .collection('MemberOf')
        .get();
    for (var budgetID in budgetIDs.docs) {
      var budgetInfo = await FirebaseFirestore.instance
          .collection('Budget')
          .doc(budgetID.id)
          .get();
      budgets.add({budgetInfo});
    }
    return budgets;
  }

  Future<List> getExpensesForBudget(String budgetID) async {
    List expenses = [];
    var expenseIDs = await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .collection('Expenses')
        .get();
    for (var expenseID in expenseIDs.docs) {
      var expenseInfo = await FirebaseFirestore.instance
          .collection('Expenses')
          .doc(expenseID.id)
          .get();
      expenses.add({expenseInfo});
    }
    return expenses;
  }
}
