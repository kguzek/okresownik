import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/api/api_client.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/cycle_repository.dart';
import 'data/repositories/partner_repository.dart';
import 'l10n/app_localizations.dart';
import 'logic/auth/auth_cubit.dart';
import 'logic/cycle/cycle_cubit.dart';
import 'logic/locale/locale_cubit.dart';
import 'logic/partner/partner_cubit.dart';
import 'logic/settings/calendar_settings_cubit.dart';
import 'presentation/router/app_router.dart';

class OkresownikApp extends StatefulWidget {
  const OkresownikApp({super.key});

  @override
  State<OkresownikApp> createState() => _OkresownikAppState();
}

class _OkresownikAppState extends State<OkresownikApp> {
  late final ApiClient _apiClient;
  late final AuthRepository _authRepository;
  late final CycleRepository _cycleRepository;
  late final PartnerRepository _partnerRepository;
  late final AuthCubit _authCubit;
  late final CycleCubit _cycleCubit;
  late final PartnerCubit _partnerCubit;
  late final LocaleCubit _localeCubit;
  CalendarSettingsCubit? _calendarSettingsCubit;

  CalendarSettingsCubit get _settingsCubit =>
      _calendarSettingsCubit ??= CalendarSettingsCubit();

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _authRepository = AuthRepository(_apiClient);
    _cycleRepository = CycleRepository(_apiClient);
    _partnerRepository = PartnerRepository(_apiClient);
    _authCubit = AuthCubit(_authRepository);
    _cycleCubit = CycleCubit(_cycleRepository);
    _partnerCubit = PartnerCubit(_partnerRepository);
    _localeCubit = LocaleCubit();
    _calendarSettingsCubit = CalendarSettingsCubit();

    _authCubit.checkAuth();
  }

  @override
  void dispose() {
    _apiClient.dispose();
    _authCubit.close();
    _cycleCubit.close();
    _partnerCubit.close();
    _localeCubit.close();
    _calendarSettingsCubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = createRouter(_authCubit);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
        BlocProvider.value(value: _cycleCubit),
        BlocProvider.value(value: _partnerCubit),
        BlocProvider.value(value: _localeCubit),
        BlocProvider.value(value: _settingsCubit),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: 'Okresownik',
            theme: AppTheme.lightTheme,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('pl'),
              Locale('en'),
            ],
          );
        },
      ),
    );
  }
}
