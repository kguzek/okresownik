import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../logic/locale/locale_cubit.dart';
import '../../../logic/settings/calendar_settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final currentLocale = context.watch<LocaleCubit>().state;
    final firstWeekday = context.watch<CalendarSettingsCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.language, color: AppTheme.primary, size: 22),
                  ),
                  title: Text(
                    t.language,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    currentLocale.languageCode == 'pl' ? t.polish : t.english,
                    style: TextStyle(color: AppTheme.onSurfaceVariant),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppTheme.onSurfaceVariant),
                  onTap: () => _showLanguagePicker(context),
                ),
                const Divider(height: 1, color: AppTheme.divider),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_view_week,
                      color: AppTheme.primary,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    t.firstDayOfWeek,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    _weekdayName(firstWeekday, currentLocale),
                    style: TextStyle(color: AppTheme.onSurfaceVariant),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppTheme.onSurfaceVariant),
                  onTap: () => _showFirstWeekdayPicker(context),
                ),
              ],
            ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(t.polish),
              trailing: currentLocale.languageCode == 'pl'
                  ? const Icon(Icons.check, color: AppTheme.primary)
                  : null,
              onTap: () {
                cubit.setLocale(const Locale('pl'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(t.english),
              trailing: currentLocale.languageCode == 'en'
                  ? const Icon(Icons.check, color: AppTheme.primary)
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

  void _showFirstWeekdayPicker(BuildContext context) {
    final t = AppLocalizations.of(context);
    final currentLocale = context.read<LocaleCubit>().state;
    final cubit = context.read<CalendarSettingsCubit>();
    final currentWeekday = cubit.state;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.firstDayOfWeek),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var weekday = DateTime.monday;
                weekday <= DateTime.sunday;
                weekday++)
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(_weekdayName(weekday, currentLocale)),
                trailing: currentWeekday == weekday
                    ? const Icon(Icons.check, color: AppTheme.primary)
                    : null,
                onTap: () {
                  cubit.setFirstWeekday(weekday);
                  Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    );
  }

  String _weekdayName(int weekday, Locale locale) {
    final mondayBasedDate = DateTime(2026, 1, 4 + weekday);
    return DateFormat.EEEE(locale.languageCode).format(mondayBasedDate);
  }
}
