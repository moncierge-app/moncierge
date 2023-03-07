class User {
  // Creating Field inside the class

  var currentUser;

  late String email;
  late String password;
  late String name;
  late String phoneNumber;
  late User supervisorOfBudgets;
  late List<int> budgetIDs;

  // Setters
  set changeUserEmail(String email) {
    this.email = email;
    currentUser = this.email;
  }

  set changeUserPassword(String password) {
    this.password = password;
  }

  set changeUserName(String name) {
    this.name = name;
  }

  set changePhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  set addSupervisor(User supervisor) {
    supervisorOfBudgets = supervisor;
  }

  set addBudgetID(int id) {
    budgetIDs.add(id);
  }

  // Getters
  String get userEmail {
    return email;
  }

  // TODO: Unneccessary function?
  String get userPassword {
    return password;
  }

  String get userName {
    return name;
  }

  String get userPhoneNumber {
    return phoneNumber;
  }

  User get supervisor {
    return supervisorOfBudgets;
  }

  List<int> get budgets {
    return budgetIDs;
  }

  //Functions
  int login(String email, String password) {

    //TODO: compare with password obtained from Firebase?
    if(password != 'pass123') {
      currentUser = null;
      return 1;
    }

    currentUser = email;
    return 0;
  }

  void logout(String email) {
    currentUser = null;
  }
}

void main() {
  User s1 = new User();
  s1.email = 'kavyabhat@gmail.com';
  print(s1.email);
}
