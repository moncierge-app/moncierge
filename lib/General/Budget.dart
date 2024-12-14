class  BudgetClass {
  String budgetId="000000";
  DateTime creationTime =DateTime.now(); //current time taken at the time of creation
  DateTime? endTime;         // set by superviser 
  String userId="000000"; // superviser
  List<String>? membersId; // List of members that are going to share the budget
  Map<String,String>? expenseMembers; // this map will help us to track which expense is 
          // is going to add by which member it will map member id with expense id
  
  double budgetAmount=0.0;
  double currentAmount=0.0;
//   getter and setter method 
  set setBudgetAmount(double budgetAmount){
    this.budgetAmount=budgetAmount;
  }
  get getBudgetAmount{
    return budgetAmount;
  }
  set setEndTime(DateTime endTime){
    this.endTime=endTime;
    
  }
  
  DateTime get setEndTime{
    return endTime!;
  }
  
  set setUserId(String userId){
    this.userId=userId;
  }
  
  String get getUserId{
    return userId;
  }
  
  set setListOfMembers(List<String> membersId){
    this.membersId=membersId;
  }
  List<String> get getListOfMembers{
    return membersId!;
  }
  
  
  
  void addExpense(String memId, Expenses expense){
//     Expenses expense= Expense expense = Expense(
//     addTime: DateTime.now(),
//     paymentTime: DateTime.now().add(Duration(days: 1)),
//     userId: 'user123',
//     budgetId: 'budget456',
//     description: 'Office supplies',
//     );
    expenseMembers[expense.expenseId]=memId;
    this.currentAmount+=expense.amount;
  }
                                       
  void exceedAlert(){
    if(budgetAmount<currentAmount){
      print("Your budget is exceeding its limit");
    }
  }
  
  void warningAlert(){
    if(DateTime.now()>this.endTime){
      print(" Your budget duration is over now , you can update if you want!!!");
    }
  }
  
  void addMembers(String newMember){
      membersId.add(newMember);
 
  }
  void removeMembers(String removeMember){
    membersId.remove(removeMember);
  }
  
  void updateAmount(double newAmount){
   this.budgetAmount=newAmount;
  }
  
  void removeExpense(String memberId,String expenseId){
//     one can remove the expense only if the expense are added by member  itself or the that person is 
//     superviser
    if(memberId==this.userId || (expenseMembers[expenseId]==memberId)){
      expenseMembers.remove(expenseId);
    }
  }
  
}
