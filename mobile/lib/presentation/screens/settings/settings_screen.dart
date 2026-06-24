import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_localizations.dart';
import '../../../logic/locale/locale_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final currentLocale = context.watch<LocaleCubit>().state;

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(t.language),
            subtitle: Text(
              currentLocale.languageCode == 'pl' ? t.polish : t.english,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cubit = context.read<LocaleCubit>();
    final currentLocale = cubit.state;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(t.polish),
              trailing: currentLocale.languageCode == 'pl'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                cubit.setLocale(const Locale('pl'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: Text(t.english),
              trailing: currentLocale.languageCode == 'en'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                cubit.setLocale(const Locale('en'));
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}
