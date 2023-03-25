import 'package:moncierge/Screens/lib/SignUp.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //setup
  test('empty email returns error string', () {
    //run
    final result = EmailFieldValidator.validate('');
    //verify
    expect(result, 'Email can\'t be empty');
  });

//setup
  test('non-empty email returns null', () {
    //run
    final result = EmailFieldValidator.validate('email');
    //verify
    expect(result, null);
  });
//setup
  test('empty password returns error string', () {
    //run
    final result = PasswordFieldValidator.validate('');
    //verify
    expect(result, 'Password can\'t be empty');
  });

  test('non-empty password returns null', () {
    final result = PasswordFieldValidator.validate('password');
    expect(result, null);
  });

  test('empty First Name returns error string', () {
    //run
    final result = FirstNameFieldValidator.validate('');
    //verify
    expect(result, 'First Name can\'t be empty');
  });

//setup
  test('non-empty First Name returns null', () {
    //run
    final result = FirstNameFieldValidator.validate('First Name');
    //verify
    expect(result, null);
  });

  test('empty Last Name returns error string', () {
    //run
    final result = LastNameFieldValidator.validate('');
    //verify
    expect(result, 'Last Name can\'t be empty');
  });

//setup
  test('non-empty Last Name returns null', () {
    //run
    final result = LastNameFieldValidator.validate('Last Name');
    //verify
    expect(result, null);
  });

  test('empty Mobile Number returns error string', () {
    //run
    final result = MobileNumberFieldValidator.validate('');
    //verify
    expect(result, 'Mobile No can\'t be empty');
  });

//setup
  test('non-empty Mobile No returns null', () {
    //run
    final result = MobileNumberFieldValidator.validate('Mobile No');
    //verify
    expect(result, null);
  });


}
