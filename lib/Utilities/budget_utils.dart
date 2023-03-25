// Utility class to manage all the database access operations
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moncierge/General/budget.dart';
import 'package:moncierge/General/expense.dart';
import 'package:moncierge/Utilities/notification_utils.dart';

class BudgetUtils {
  // To check if a user with given userID exists or not
  static Future<bool> checkIfUserExists(String userID) async {
    final userDocument =
        await FirebaseFirestore.instance.collection('User').doc(userID).get();
    if (userDocument.exists) {
      return true;
    } else {
      return false;
    }
  }

  //Check if expense adding time is in the valid budget interval
  static Future<bool> checkExpenseValid(
      String budgetID, DateTime timestampAdded) async {
    final budgetDocument = await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .get();
    if (timestampAdded.compareTo(budgetDocument['creationTime'].toDate()) >=
            0 &&
        timestampAdded.compareTo(budgetDocument['endTime'].toDate()) <= 0)
      return true;
    return false;
  }

  // To create a budget with given inputs
  static Future<bool> createBudget(
      String budgetName,
      DateTime creationTime,
      String creatorEmailID,
      DateTime endTime,
      List<String> supervisorIDs,
      List<String> memberIDs,
      List<Category> categories,
      int totalAmount) async {
    try {
      String creationTimeString = creationTime.toString();

      // Convert datetimestamp to string and convert to second precision
      creationTimeString =
          creationTimeString.substring(0, creationTimeString.length - 7);

      String budgetID = '$creatorEmailID|$creationTimeString';

      // Create a budget document with standard datatype fields
      var budgetCollection = FirebaseFirestore.instance.collection('Budget');
      await budgetCollection.doc(budgetID).set({
        'budgetName': budgetName,
        'creationTime': creationTime,
        'endTime': endTime,
        'totalAmount': totalAmount,
        'amountUsed': 0
      });

      // Add Supervisor list as subcollection
      for (var i = 0; i < supervisorIDs.length; i++) {
        await budgetCollection
            .doc(budgetID)
            .collection('Supervisors')
            .doc(supervisorIDs[i])
            .set({});
      }

      // Add Member list as subcollection
      for (var i = 0; i < memberIDs.length; i++) {
        await budgetCollection
            .doc(budgetID)
            .collection('Members')
            .doc(memberIDs[i])
            .set({});
      }

      // Add category list as subcollection
      for (var i = 0; i < categories.length; i++) {
        await budgetCollection
            .doc(budgetID)
            .collection('Categories')
            .doc(categories[i].category)
            .set({
          'warningAmount': categories[i].warningAmount,
          'amount': categories[i].totalAmount,
          'amountUsed': 0
        });
      }

      // Update users entries
      var userCollection = FirebaseFirestore.instance.collection('User');

      // Update supervisors of the budget
      for (var i = 0; i < supervisorIDs.length; i++) {
        await userCollection
            .doc(supervisorIDs[i])
            .collection('SupervisorOf')
            .doc(budgetID)
            .set({});
      }

      // Update members of the budget
      for (var i = 0; i < memberIDs.length; i++) {
        await userCollection
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
  static Future<bool> addExpense(
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
      if (await checkExpenseValid(budgetID, timestampPaymentMade)) {
        var expenseCollection =
            FirebaseFirestore.instance.collection('Expense');

        // Convert datetimestamp to string and convert to second precision
        String timeStampAddedString = timestampAdded.toString();
        timeStampAddedString =
            timeStampAddedString.substring(0, timeStampAddedString.length - 7);
        String expenseID = '$creatorID|$timeStampAddedString';

        // Create an expense document
        expenseCollection.doc(expenseID).set({
          'userID': creatorID,
          'budgetID': budgetID,
          'amount': amount,
          'category': category,
          'paymentMode': paymentMode,
          'receiver': receiver,
          'description': description,
          'timestampAdded': timestampAdded,
          'timestampPaymentMade': timestampPaymentMade
        });

        //Update budget document
        var budgetCollection = FirebaseFirestore.instance.collection('Budget');

        // Add expense in budget
        budgetCollection
            .doc(budgetID)
            .collection('Expenses')
            .doc(expenseID)
            .set({});

        // Update used amount in budget
        var budgetDocument = await budgetCollection.doc(budgetID).get();
        budgetCollection
            .doc(budgetID)
            .update({'amountUsed': amount + budgetDocument['amountUsed']});

        // Update used amount in category
        var categoryDocument = await budgetCollection
            .doc(budgetID)
            .collection('Categories')
            .doc(category)
            .get();
        await budgetCollection
            .doc(budgetID)
            .collection('Categories')
            .doc(category)
            .update({'amountUsed': categoryDocument['amountUsed'] + amount});

        //if limit exceeded
        String msg = await checkLimitExceeded(budgetID, expenseID);
        if (msg != '') {
          Set<String> receiverList = Set<String>();
          var members =
              await budgetCollection.doc(budgetID).collection('Members').get();
          for (var member in members.docs) receiverList.add(member.id);
          List<String> receivers = [];
          for (var reciever in receiverList) receivers.add(receiver);
          NotificationUtils.sendEmailNotification(receivers, msg,
              '${creatorID} added and expense of ${amount} and the budget limit of ${budgetDocument['budgetName']} exceeded. For more details please check the Moncierge application.');
        }
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      return false;
    }
  }

  // Check if on adding a particular expense, any budget limit is exceeded, returns the excceded message corresponding to limit
  static Future<String> checkLimitExceeded(
      String budgetID, String expenseID) async {
    var budgetDocument = await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .get();
    // If overall limit of budget is exceeded
    if (budgetDocument['amountUsed'] > budgetDocument['totalAmount']) {
      return 'Total Amount of the budget exceeded!';
    }
    var expenseDocument = await FirebaseFirestore.instance
        .collection('Expense')
        .doc(expenseID)
        .get();
    var categoryDocument = await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .collection('Categories')
        .doc(expenseDocument['category'])
        .get();
    // If total limit of a category is exceeded
    if (categoryDocument['amountUsed'] > categoryDocument['amount']) {
      return 'Total amount of ${expenseDocument['category']} category exceeded!';
    }
    // If warning limit of a category is exceeded
    if (categoryDocument['amountUsed'] > categoryDocument['warningAmount']) {
      return 'Warning amount of ${expenseDocument['category']} category exceeded!';
    }
    // No limits exceeded
    return '';
  }

  static Future<Budget> getBudget(String budgetID) async {
    Budget budget;
    var budgetDocument = await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .get();
    var members = await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .collection('Members')
        .get();
    List<String> memberIds = members.docs.map((member) => member.id).toList();
    var supervisors = await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .collection('Supervisors')
        .get();
    List<String> supervisorIds =
        supervisors.docs.map((supervisor) => supervisor.id).toList();
    var expenses = await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .collection('Expenses')
        .get();
    List<String> expenseIds =
        expenses.docs.map((expense) => expense.id).toList();
    var categoriesDoc = await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .collection('Categories')
        .get();
    List<Category> categories = categoriesDoc.docs
        .map((category) => Category(
            category: category.id,
            warningAmount: category['warningAmount'],
            totalAmount: category['amount'],
            amountUsed: category['amountUsed']))
        .toList();
    budget = Budget(
      budgetDocument.id,
      budgetDocument['budgetName'],
      budgetDocument['creationTime'].toDate(),
      budgetDocument['endTime'].toDate(),
      memberIds,
      supervisorIds,
      expenseIds,
      categories,
      budgetDocument['totalAmount'],
      budgetDocument['amountUsed'],
    );
    return budget;
  }

  static Future<Expenses> getExpense(String budgetID, String expenseID) async {
    var expenseInfo = await FirebaseFirestore.instance
        .collection('Expense')
        .doc(expenseID)
        .get();
    Expenses expense = Expenses(
        userId: expenseInfo['userID'],
        budgetId: expenseInfo['budgetID'],
        amount: expenseInfo['amount'],
        category: expenseInfo['category'],
        paymentMode: expenseInfo['paymentMode'],
        description: expenseInfo['description'],
        receiver: expenseInfo['receiver'],
        timeOfExpenseAddition: expenseInfo['timestampAdded'].toDate(),
        timeOfPayment: expenseInfo['timestampPaymentMade'].toDate());
    return expense;
  }

  // Fetch all the budget info a user is member of and return as a list of objects
  static Future<List<Budget>> getBudgetsForUser(String userID) async {
    List<Budget> budgets = [];
    var budgetIDs = await FirebaseFirestore.instance
        .collection('User')
        .doc(userID)
        .collection('MemberOf')
        .get();
    for (var budgetID in budgetIDs.docs) {
      var budget = await getBudget(budgetID.id);
      budgets.add(budget);
    }
    return budgets;
  }

  // Fetch all the budget info a user is supervisor of and return as a list of objects
  static Future<List<Budget>> getBudgetsForSupervisor(String userID) async {
    List<Budget> budgets = [];
    var budgetIDs = await FirebaseFirestore.instance
        .collection('User')
        .doc(userID)
        .collection('SupervisorOf')
        .get();
    for (var budgetID in budgetIDs.docs) {
      var budget = await getBudget(budgetID.id);
      budgets.add(budget);
    }
    return budgets;
  }

  // Fetch all the expense info for a budget and return as list of objects
  Future<List> getExpensesForBudget(String budgetID) async {
    List expenses = [];
    var expenseIDs = await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .collection('Expenses')
        .get();
    for (var expenseID in expenseIDs.docs) {
      var expenseDocument = await FirebaseFirestore.instance
          .collection('Expenses')
          .doc(expenseID.id)
          .get();
      expenses.add({expenseDocument});
    }
    return expenses;
  }

  static Future<List<String>> getCategoriesForBudget(String budgetID) async {
    List<String> categories = [];
    var categoriesInfo = await FirebaseFirestore.instance
        .collection('Budget')
        .doc(budgetID)
        .collection('Categories')
        .get();
    for (var category in categoriesInfo.docs) {
      categories.add(category.id);
    }
    return categories;
  }
}
