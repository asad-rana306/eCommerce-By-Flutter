import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

Future<void> sendEmail({
  required String toEmail,
  required String subject,
  required String body,
}) async {
  // Your Gmail credentials
  const String username = 'asadcodecraft@gmail.com'; // sender
  const String password = '#### #### #### ####'; // App password

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'E-commerce@Mid_Project')
    ..recipients.add(toEmail)
    ..subject = subject
    ..text = body;

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. \n' + e.toString());
  }
}
