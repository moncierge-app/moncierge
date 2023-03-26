// ignore: depend_on_referenced_packages
import 'package:mailer/mailer.dart';
// ignore: depend_on_referenced_packages
import 'package:mailer/smtp_server.dart';

// Send notification message
class NotificationUtils {
  static String email = 'vdesai2029@gmail.com';
  static String password = 'fbnpdyjykfsozpfz';
  //extra: vihrcuxlxgdcmxwa
  static Future<void> sendEmailNotification(
      List<String> receivers, String title, String content) async {
    SmtpServer smtp = gmail(email, password);
    final message = Message()
      ..from = Address(email, 'Moncierge')
      ..recipients = receivers
      ..subject = title
      ..text = content;
    try {
      await send(message, smtp);
      print('sent');
    } catch (e) {
      print(e);
    }
  }
}
