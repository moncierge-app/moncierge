import 'package:firebase_auth/firebase_auth.dart';

class User {
  // Creating Field inside the class

  var currentUser;

  late String email = "sample@gmail.com";
  late String password = "sample";
  late String name;
  late String phoneNumber;
  late List<String> supervisorOfBudgets; //list of budget IDs pointing to budgets that the user supervises
  late List<String> budgetIDs; // list of budgets that the user is a member of

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

  set addSupervisedBudget(String id) {
    supervisorOfBudgets.add(id);
  }

  set addBudgetID(String id) {
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

  List<String> get supervisor {
    return supervisorOfBudgets;
  }

  List<String> get budgets {
    return budgetIDs;
  }

  //Authentication with Firebase
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

 //SIGN UP METHOD
  Future signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      currentUser = email;
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
    currentUser = null;
    print('signed out');
  }

}

void main() {
  User s1 = User();
  s1.email = 'kavyabhat@gmail.com';
  print(s1.email);
}
