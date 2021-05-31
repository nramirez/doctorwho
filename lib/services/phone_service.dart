import 'dart:math';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../env.dart';

class PhoneService {
  Env env;
  TwilioFlutter twilio;

  PhoneService() {
    env = Env();
    twilio = TwilioFlutter(
        accountSid: env.twilio.accountSid,
        authToken: env.twilio.authToken,
        twilioNumber: env.twilio.twilioNumber);
  }

  Future<int> sendSignInCode(String to) async {
    var min = 1000;
    var max = 9999;
    var code = Random().nextInt(max - min) + min;
    if (env.emailDisabled) {
      return code;
    }
    try {
      await twilio.sendSMS(toNumber: to, messageBody: code.toString());
    } catch (e) {
      print(e);
      return 0;
    }
    return code;
  }
}
