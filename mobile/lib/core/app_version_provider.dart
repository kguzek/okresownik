import 'package:flutter/services.dart';

class AppVersionProvider {
  static const _channel = MethodChannel('uk.guzek.okresownik/app_info');

  static Future<String> current() async {
    try {
      return await _channel.invokeMethod<String>('getVersion') ?? '';
    } on MissingPluginException {
      return '';
    }
  }
}
