import 'package:flutter_test/flutter_test.dart';
import 'package:moncierge/Screens/lib/sign_up.dart';

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

  test('empty Name returns error string', () {
    //run
    final result = NameFieldValidator.validate('');
    //verify
    expect(result, 'Name can\'t be empty');
  });

//setup
  test('non-empty Name returns null', () {
    //run
    final result = NameFieldValidator.validate('Name');
    //verify
    expect(result, null);
  });

  test('empty Mobile Number returns error string', () {
    //run
    final result = MobileNumberFieldValidator.validate('');
    //verify
    expect(result, 'Mobile Number can\'t be empty');
  });

//setup
  test('non-empty Mobile No returns null', () {
    //run
    final result = MobileNumberFieldValidator.validate('Mobile No');
    //verify
    expect(result, null);
  });
}
