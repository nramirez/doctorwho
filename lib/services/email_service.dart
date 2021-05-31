import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:mail/mail.dart';

import '../env.dart';

class EmailService {
  MailgunMailer mailgun;
  Env env;
  EmailService() {
    env = Env();
    mailgun =
        MailgunMailer(domain: env.mailgunDomain, apiKey: env.mailgunApiKey);
  }

  Future<int> sendSignInCode(String to) async {
    var min = 1000;
    var max = 9999;
    var code = Random().nextInt(max - min) + min;
    if (env.emailDisabled) {
      return code;
    }
    try {
      await mailgun.send(
          from: "DR. Soler <ram.nazaret@gmail.com>",
          to: [to],
          subject: "Codigo de autorizacion DR. Soler",
          text: code.toString());
    } catch (e) {
      return 0;
    }

    return code;
  }
}

// https://github.com/dotronglong/flutter-mailgun/blob/master/lib/src/mailgun_mailer.dart
class MailgunMailer implements Mailer {
  final String domain;
  final String apiKey;

  MailgunMailer({this.domain, this.apiKey});

  @override
  Future<SendResponse> send(
      {String from,
      List<String> to = const [],
      List<String> cc = const [],
      List<String> bcc = const [],
      List<dynamic> attachments = const [],
      String subject,
      String html,
      String text,
      String template,
      Map<String, dynamic> options}) async {
    var client = http.Client();
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri(
              userInfo: 'api:$apiKey',
              scheme: 'https',
              host: 'api.mailgun.net',
              path: '/v3/$domain/messages'));
      if (subject != null) {
        request.fields['subject'] = subject;
      }
      if (html != null) {
        request.fields['html'] = html;
      }
      if (text != null) {
        request.fields['text'] = text;
      }
      if (from != null) {
        request.fields['from'] = from;
      }
      if (to.length > 0) {
        request.fields['to'] = to.join(", ");
      }
      if (cc.length > 0) {
        request.fields['cc'] = cc.join(", ");
      }
      if (bcc.length > 0) {
        request.fields['bcc'] = bcc.join(", ");
      }
      if (template != null) {
        request.fields['template'] = template;
      }
      if (options != null) {
        if (options.containsKey('template_variables')) {
          request.fields['h:X-Mailgun-Variables'] =
              jsonEncode(options['template_variables']);
        }
      }
      if (attachments.length > 0) {
        request.headers["Content-Type"] = "multipart/form-data";
        for (var i = 0; i < attachments.length; i++) {
          var attachment = attachments[i];
          if (attachment is File) {
            request.files.add(await http.MultipartFile.fromPath(
                'attachment', attachment.path));
          }
        }
      }
      // https://stackoverflow.com/questions/50244416/how-to-pass-basic-auth-credentials-in-api-call-for-a-flutter-mobile-application
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('api:$apiKey'));
      request.headers['authorization'] = basicAuth;

      var response = await client.send(request);
      var responseBody = await response.stream.bytesToString();
      var jsonBody = jsonDecode(responseBody);
      var message = jsonBody['message'] ?? '';
      if (response.statusCode != HttpStatus.ok) {
        return SendResponse(status: SendResponseStatus.FAIL, message: message);
      }

      return SendResponse(status: SendResponseStatus.QUEUED, message: message);
    } catch (e) {
      return SendResponse(
          status: SendResponseStatus.FAIL, message: e.toString());
    } finally {
      client.close();
    }
  }
}
