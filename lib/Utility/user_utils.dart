import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moncierge/General/User.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final CollectionReference _userCollection = _db.collection('User');

//TODO: Add validation for email, password and phoneNumber
//TODO: Allow optional parameters for addUser() and updateUser()

class User_Utils {

  //add user with given inputs
  static Future<void> addUser(String email, String password, String name, String phoneNumber, List<String> supervisorOfBudgets, List<String> budgetIDs) async {
    Map<String, dynamic> data = <String, dynamic>{
      "email": email,
      "password": password,
      "name": name,
      "phoneNumber": phoneNumber
    };

    // add list of budgets supervised as subcollection 
    for (var i = 0; i < supervisorOfBudgets.length; i++) {
      await _userCollection
          .doc(email)
          .collection('Supervises')
          .doc(supervisorOfBudgets[i])
          .set({});
    }

    // add list of budgets that user is a part of
    for (var i = 0; i < budgetIDs.length; i++) {
      await _userCollection
          .doc(email)
          .collection('Budgets')
          .doc(budgetIDs[i])
          .set({});
    }

    await _userCollection.doc(email)
        .set(data)
        .whenComplete(() => print("User added to the database"))
        .catchError((e) => print(e));
  }

  // update User details
  static Future<void> updateItem(String email, String password, String name, String phoneNumber) async {
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
}