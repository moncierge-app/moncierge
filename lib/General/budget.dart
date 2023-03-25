import 'package:moncierge/General/expense.dart';

class Category {
  late String category;
  late int warningAmount;
  late int totalAmount;
  int amountUsed = 0;
  Category(
      {required this.category,
      required this.warningAmount,
      required this.totalAmount, required this.amountUsed});
  void updateAmountUsed(int amount) {
    amountUsed += amount;
  }

  String checkWarning() {
    if (amountUsed > warningAmount) {
      return 'Warning amount exceeded!';
    } else if (amountUsed > totalAmount) {
      return 'Total amount exceeded!';
    } else {
      return '';
    }
  }
}

class Budget {
  late String budgetId;
  late String budgetName;
  late DateTime creationTime; //current time taken at the time of creation
  late DateTime endTime; // set by superviser
  String userId = ''; // superviser
  late List<String>
      membersId; // List of members that are going to share the budget
  late List<String> supervisorsId;
  late List<String> expenses;
  late List<Category> categories;
  int totalAmount = 0;
  int amountUsed = 0;
  Budget(
      String budgetId,
      String budgetName,
      DateTime creationTime,
      DateTime endTime,
      List<String> membersId,
      List<String> supervisorsId,
      List<String> expenses,
      List<Category> categories,
      int totalAmount,
      int amountUsed) {
    this.budgetId = budgetId;
    this.budgetName = budgetName;
    this.creationTime = creationTime;
    this.endTime = endTime;
    this.membersId = membersId;
    this.supervisorsId = supervisorsId;
    this.expenses = expenses;
    this.totalAmount = totalAmount;
    this.amountUsed = amountUsed;
  }
  Budget.withName();
//   getter and setter method
  set setBudgetAmount(int budgetAmount) {
    totalAmount = budgetAmount;
  }

  get getBudgetAmount {
    return totalAmount;
  }

  set setEndTime(DateTime endTime) {
    this.endTime = endTime;
  }

  DateTime get setEndTime {
    return endTime;
  }

  set setUserId(String userId) {
    this.userId = userId;
  }

  String get getUserId {
    return userId;
  }

  set setListOfMembers(List<String> membersId) {
    this.membersId = membersId;
  }

  List<String> get getListOfMembers {
    return membersId;
  }

  void addExpense(String memId, Expenses expense) {
//     Expenses expense= Expense expense = Expense(
//     addTime: DateTime.now(),
//     paymentTime: DateTime.now().add(Duration(days: 1)),
//     userId: 'user123',
//     budgetId: 'budget456',
//     description: 'Office supplies',
//     );
    amountUsed += expense.amount;
  }

  void exceedAlert() {
    if (totalAmount < amountUsed) {
      print("Your budget is exceeding its limit");
    }
  }

  void warningAlert() {
    if (DateTime.now().compareTo(endTime) > 0) {
      print(
          " Your budget duration is over now , you can update if you want!!!");
    }
  }

  void addMembers(String newMember) {
    membersId.add(newMember);
  }

  void removeMembers(String removeMember) {
    membersId.remove(removeMember);
  }

  void updateAmount(int newAmount) {
    totalAmount = newAmount;
  }

  void removeExpense(String memberId, String expenseId) {
//     one can remove the expense only if the expense are added by member  itself or the that person is
//     superviser
  }
}
