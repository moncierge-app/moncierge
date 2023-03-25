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
}
