import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/api/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../logic/auth/auth_cubit.dart';
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
                const SizedBox(height: 16),
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
                            color: AppTheme.periodRed.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: AppTheme.periodRed,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          t.deleteDataTitle,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          t.deleteDataSubtitle,
                          style: TextStyle(color: AppTheme.onSurfaceVariant),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: AppTheme.onSurfaceVariant),
                        onTap: () => _confirmDeleteData(context),
                      ),
                      const Divider(height: 1, color: AppTheme.divider),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.periodRed.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.person_remove_outlined,
                            color: AppTheme.periodRed,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          t.deleteAccountTitle,
                          style: TextStyle(fontWeight: FontWeight.w500, color: AppTheme.periodRed),
                        ),
                        subtitle: Text(
                          t.deleteAccountSubtitle,
                          style: TextStyle(color: AppTheme.onSurfaceVariant),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: AppTheme.onSurfaceVariant),
                        onTap: () => _confirmDeleteAccount(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => context.read<AuthCubit>().logout(),
                    child: Text(
                      t.logout,
                      style: const TextStyle(color: AppTheme.periodRed),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final appVersion = snapshot.data?.version ?? '';
                      return Center(
                        child: Text(
                          '${t.appVersion}: v$appVersion',
                          style: TextStyle(
                            color: AppTheme.onSurfaceVariant.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
                  FutureBuilder<String?>(
                    future: _fetchBackendVersion(),
                    builder: (context, snapshot) {
                      final apiVersion = snapshot.data;
                      return Center(
                        child: Text(
                          '${t.apiVersion}: ${apiVersion ?? '-'}',
                          style: TextStyle(
                            color: AppTheme.onSurfaceVariant.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
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

  void _confirmDeleteData(BuildContext context) {
    final t = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.deleteDataTitle),
        content: Text(t.deleteDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().deleteData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.deleteDataSuccess),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              t.deleteDataTitle,
              style: const TextStyle(color: AppTheme.periodRed),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    final t = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.deleteAccountTitle),
        content: Text(t.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().deleteAccount();
            },
            child: Text(
              t.deleteAccountTitle,
              style: const TextStyle(color: AppTheme.periodRed),
            ),
          ),
        ],
      ),
    );
  }

  String _weekdayName(int weekday, Locale locale) {
    final mondayBasedDate = DateTime(2026, 1, 4 + weekday);
    return DateFormat.EEEE(locale.languageCode).format(mondayBasedDate);
  }
}

Future<String?> _fetchBackendVersion() async {
  final client = ApiClient();
  try {
    final response = await client.health();
    final version = response['version'] as String?;
    debugPrint('Health response: $response, version: $version');
    return version;
  } catch (e) {
    debugPrint('Health check failed: $e');
    return null;
  } finally {
    client.dispose();
  }
}
