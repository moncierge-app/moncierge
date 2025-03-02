import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moncierge/General/user.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final CollectionReference _userCollection = _db.collection('User');

//TODO: Add validation for email, password and phoneNumber
//TODO: Allow optional parameters for addUser() and updateUser()

// Utilities to access and manage User Collection
class UserUtils {
  //add user with given inputs
  static Future<void> addNewUser(
      String email, String password, String name, String phoneNumber) async {
    Map<String, dynamic> data = <String, dynamic>{
      "email": email,
      "password": password,
      "name": name,
      "phoneNumber": phoneNumber
    };

    await _userCollection
        .doc(email)
        .set(data)
        .whenComplete(() => print("User added to the database"))
        .catchError((e) => print(e));
  }

  // Update password
  static Future<void> forgotPassword(String email, String password) async {
    Map<String, dynamic> data = <String, dynamic>{
      "email": email,
      "password": password
    };

    await _userCollection
        .doc(email)
        .update(data)
        .whenComplete(() => print("Password updated in the database"))
        .catchError((e) => print(e));
  }

  // Add budget that user supervises
  static Future<void> addSupervisor(
      String email, String budgetID) async {
    // add budget being supervised as subcollection
    await _userCollection
        .doc(email)
        .collection('SupervisorOf')
        .doc(budgetID)
        .set({});
  }

  // Add budget that user is member of
  static Future<void> addBudgetID(String email, String budgetID) async {
    await _userCollection
        .doc(email)
        .collection('MemberOf')
        .doc(budgetID)
        .set({});
  }

  // update User details
  static Future<void> updateUserProfile(
      String email, String password, String name, String phoneNumber) async {
    DocumentReference documentReferencer = _userCollection.doc(email);

    Map<String, dynamic> data = <String, dynamic>{
      "email": email,
      "password": password,
      "name": name,
      "phoneNumber": phoneNumber
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("User updated in the database"))
        .catchError((e) => print(e));
  }

  //get updated user details whenever a document is modified
  static Stream<QuerySnapshot> readUsers() {
    return _userCollection.snapshots();
  }

  //delete a user, given their email
  static Future<void> deleteUser(String email) async {
    DocumentReference documentReferencer = _userCollection.doc(email);

    await documentReferencer
        .delete()
        .whenComplete(() => print('User item deleted from the database'))
        .catchError((e) => print(e));
  }

  // Get user details
  static Future<User> getUserWithEmail(String emailID) async {
    var userInstance =
        await FirebaseFirestore.instance.collection('User').doc(emailID).get();
    User user = User(
        name: userInstance['name'],
        email: userInstance['email'],
        password: userInstance['password'],
        phoneNumber: userInstance['phoneNumber']);
    return user;
  }
}
