import 'package:flutter_dotenv/flutter_dotenv.dart';

// Remover el .example del archivo .example.env
// Y actualizar con las variables de su entorno
class Env {
  String mailgunDomain = env['MAILGUN_DOMAIN'];
  String mailgunApiKey = env['MAILGUN_API_KEY'];
  bool emailDisabled = env['EMAIL_DISABLED'] == '1';
  String superAdmin = env['SUPER_ADMIN'];

  Twilio twilio = Twilio(
    accountSid: env['TWILIO_accountSid'],
    authToken: env['TWILIO_authToken'],
    twilioNumber: env['TWILIO_twilioNumber'],
  );
}

class Twilio {
  final String accountSid;

  final String authToken;

  final String twilioNumber;

  Twilio({this.accountSid, this.authToken, this.twilioNumber});
}
