import 'package:firebase_auth/firebase_auth.dart';

// User class to store user details and manage them
class User {
  // Creating Field inside the class
  var currentUser;
  late String email;
  late String password;
  late String name;
  late String phoneNumber;
  List<String> supervisorOfBudgets =
      []; //list of budget IDs pointing to budgets that the user supervises
  List<String> budgetIDs = []; // list of budgets that the user is a member of

  // Default constructor
  User(
      {required this.name,
      required this.email,
      required this.phoneNumber,
      required this.password});

  // Manually defined constructor - using only email and password
  User.emailPassword({required this.email, required this.password});

  // Manually defined constructor - using name, email, phonenumber, budget lists (supervisor and members of)
  User.withBudgetLists(
      {required this.name,
      required this.email,
      required this.phoneNumber,
      required this.supervisorOfBudgets,
      required this.budgetIDs});

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
  Future<bool> signIn({required String email, required String password}) async {
    try {
      currentUser = email;
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
    currentUser = null;
  }
}
