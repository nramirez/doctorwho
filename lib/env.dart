import 'package:flutter_dotenv/flutter_dotenv.dart';

// Remover el .example del archivo .example.env
// Y actualizar con las variables de su entorno
class Env {
  String mailgunDomain = env['MAILGUN_DOMAIN'];
  String mailgunApiKey = env['MAILGUN_API_KEY'];
  bool emailDisabled = env['EMAIL_DISABLED'] == '1';
}
