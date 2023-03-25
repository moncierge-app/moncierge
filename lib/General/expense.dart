class Expenses {
  String expenseId = "000000"; //
  String userId = "0000000"; // TO BE QUERIED FROM THE DATABASE
  String budgetId = "0000000";
  DateTime timeOfExpenseAddition; // captured by the app at time of addition
  DateTime timeOfPayment; // Is the user going to enter this field?
  int amount = 0;
  // can it be a list? [ does the user need to enter separate category for each expense or he can add multiple categories combined for 2-3 expense at a time?]
  String category; // categories where expense was done
  String paymentMode;
  late String receiver;
  String description;

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

  // UNCOMMENT LATER ON
  // set setReceiver(User receiver)
  // this.receiver = receiver

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
}

/**
 *
 *
 * Expense expense = Expense(
    addTime: DateTime.now(),
    paymentTime: DateTime.now().add(Duration(days: 1)),
    userId: 'user123',
    budgetId: 'budget456',
    description: 'Office supplies',
    );

    String getDetails() {
    return "Add Time: ${addTime.toString()}\nPayment Time: ${paymentTime.toString()}\nUser ID: $userId\nBudget ID: $budgetId\nDescription: $description\nPayment Mode: $paymentMode\nPayment Category: $paymentCategory";
    }
 */