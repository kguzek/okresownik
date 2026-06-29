import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/api/api_client.dart';
import '../../core/app_version_provider.dart';
import '../../l10n/app_localizations.dart';

Future<void> checkVersionOnStartup({
  required ApiClient apiClient,
  required BuildContext context,
}) async {
  try {
    final health = await apiClient.health();
    final apiVersion = health['version'] as String?;
    if (apiVersion == null) return;
    if (!context.mounted) return;
    await _checkAndShow(apiVersion, context);
  } catch (e) {
    debugPrint('[version] startup check failed: $e');
  }
}

Future<void> checkVersionFromSettings({
  required String apiVersion,
  required BuildContext context,
}) async {
  await _checkAndShow(apiVersion, context);
}

Future<void> _checkAndShow(String apiVersion, BuildContext context) async {
  if (!context.mounted) return;

  final appVersion = await AppVersionProvider.current();
  debugPrint('[version] app=$appVersion api=$apiVersion');

  if (appVersion.isEmpty) return;

  if (!_isUpdateNeeded(appVersion, apiVersion)) return;

  if (!context.mounted) return;
  _showUpdateDialog(context);
}

bool _isUpdateNeeded(String appVersion, String apiVersion) {
  final appParts = _parseVersion(appVersion);
  final apiParts = _parseVersion(apiVersion);

  if (apiParts.isEmpty) return false;
  if (appParts.isEmpty) return true;

  final len = appParts.length < apiParts.length
      ? appParts.length
      : apiParts.length;
  for (var i = 0; i < len; i++) {
    if (appParts[i] < apiParts[i]) return true;
    if (appParts[i] > apiParts[i]) return false;
  }

  return appParts.length < apiParts.length;
}

List<int> _parseVersion(String v) {
  final parts = <int>[];
  for (final s in v.split('.')) {
    final n = int.tryParse(s);
    if (n != null) parts.add(n);
  }
  return parts;
}

void _showUpdateDialog(BuildContext context) {
  final t = AppLocalizations.of(context);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(t.updateAvailable),
      content: Text(t.updateMessage),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t.ignore)),
        TextButton(
          onPressed: () async {
            final launched = await launchUrl(
              Uri.parse('https://okresownik.pl/#pobierz'),
              mode: LaunchMode.externalApplication,
            );
            if (launched && ctx.mounted) Navigator.pop(ctx);
          },
          child: Text(t.update),
        ),
      ],
    ),
  );
}
