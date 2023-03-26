// Class to store details of expenses and access them
class Expenses {
  late String expenseId;
  late String userId;
  late String budgetId;
  late DateTime timeOfExpenseAddition;
  late DateTime timeOfPayment;
  int amount = 0;
  late String category;
  late String paymentMode;
  late String receiver;
  late String description;

  // Default constructor
  Expenses(
      {required this.userId,
      required this.budgetId,
      required this.amount,
      required this.category,
      required this.paymentMode,
      required this.description,
      required this.timeOfExpenseAddition,
      required this.timeOfPayment,
      required this.receiver});

  // setters provided by the user

  // user will enter the amount spent
  set changeAmount(int amount) {
    this.amount = amount;
  }

  // user will enter the category where amount was spent
  set addCategoryForExpense(String category) {
    this.category = category;
  }

  // user will enter the mode of payment
  set setPaymentMode(String paymentMode) {
    this.paymentMode = paymentMode;
  }

  // user will have to select the budget from the dropdown from which expense was made
  set budgetIdForExpense(String budgetId) {
    this.budgetId = budgetId;
  }

  String get getUserId {
    return userId;
  }

  String get getBudgetId {
    return budgetId;
  }

  int get getAmountSpent {
    return amount;
  }

  String get getPaymentMode {
    return paymentMode;
  }

  String get getCategory {
    return category;
  }

  DateTime get getDateAndTimeOfPayment {
    return timeOfPayment;
  }

  DateTime get getDateAndTimeOfExpenseAddition {
    return timeOfExpenseAddition;
  }

  String get getReceiver {
    return receiver;
  }

  void updateExpenses(Expenses expense, int amount) {
    expense.amount = amount;
  }
}
