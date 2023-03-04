import 'dart:ffi';
enum PaymentModes {
  wallet,
  creditCard,
  debitCard,
  atmCard,
  netBanking,
  cashOnDelivery,
  giftCard,
  upi
}

class Expenses{
  String expenseId = "000000"; //
  String userId = "0000000";  // TO BE QUERIED FROM THE DATABASE
  String budgetId = "0000000";
  DateTime timeOfExpenseAddition; // captured by the app at time of addition
  DateTime timeOfPayment; // Is the user going to enter this field?
  double amount = 0.0;
  // can it be a list? [ does the user need to enter separate category for each expense or he can add multiple categories combined for 2-3 expense at a time?]
  List<String> categories; // categories where expense was done
  PaymentModes paymentMode;
  // UNCOMMENT LATER ON
  //  late User receiver;

  // setters provided by the user

  // user will enter the amount spent
  set changeAmount(double amount)
  {
    this.amount = amount;
  }

  // user will enter the category where amount was spent
  set addCategoryForExpense(String category)
  {
    categories.add(category) ;
  }

  // user will enter the mode of payment
  set setPaymentMode(PaymentModes paymentMode)
  {
    this.paymentMode = paymentMode;
  }

  // user will have to select the budget from the dropdown from which expense was made
  set budgetIdForExpense(String budgetId)
  {
    this.budgetId = budgetId;
  }

  // UNCOMMENT LATER ON
  // set setReceiver(User receiver)
  // this.receiver = receiver

  String get getUserId
  {
    return userId;
  }
  String get getBudgetId
  {
    return budgetId;
  }
  double get getAmountSpent
  {
    return amount;
  }
  PaymentModes get getPaymentMode
  {
    return paymentMode;
  }
  List<String> get getCategories
  {
    return categories;
  }
  DateTime get getDateAndTimeOfPayment
  {
    return timeOfPayment;
  }
  DateTime get getDateAndTimeOfExpenseAddition
  {
    return timeOfExpenseAddition;
  }
  // User get getReceiver
  // {
  //   return receiver;
  // }

  void updateExpenses(Expenses expense, double amount)
  {
    expense.amount = amount;
  }

  Expenses({
    required this.userId,
    required this.budgetId,
    required this.expenseId,
    required this.amount,
    required this.categories,
    required this.paymentMode,
    required this.timeOfExpenseAddition,
    required this.timeOfPayment
    // required this.receiver
  });

}

void main()
{
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