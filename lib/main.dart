// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'firebase_options.dart';
import 'themes/theme.dart';
import 'services/firestore_service.dart';
import 'services/notification_service.dart';
import 'view_models/theme_vm.dart';
import 'view_models/notification_vm.dart';
import 'view_models/auth_vm.dart';
import 'view_models/level_selection_vm.dart';
import 'view_models/task_vm.dart';
import 'view_models/edit_profile_vm.dart';

import 'views/edit_profile_view.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';

/// Контроллер локали приложения
class LocaleController extends ChangeNotifier {
  Locale? _locale;
  final SharedPreferences _prefs;

  /// Загружает сохранённый код языка
  LocaleController(String? savedCode, this._prefs) {
    if (savedCode != null && savedCode.isNotEmpty) {
      _locale = Locale(savedCode);
    }
  }

  /// Текущая локаль
  Locale? get locale => _locale;

  /// Устанавливает и сохраняет новую локаль
  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    _prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }

  /// Сброс локали на системную
  void clearLocale() {
    _locale = null;
    _prefs.remove('locale');
    notifyListeners();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Делаем навигационную панель прозрачной
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );

  final notifSvc = NotificationService();
  await notifSvc.init();
  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = prefs.getString('locale');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeViewModel>(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider<NotificationViewModel>(
          create: (_) => NotificationViewModel(notifSvc, prefs),
        ),
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        ChangeNotifierProvider<LevelSelectionViewModel>(
          create: (ctx) => LevelSelectionViewModel(ctx.read<FirestoreService>()),
        ),
        ChangeNotifierProvider<TaskViewModel>(
          create: (ctx) => TaskViewModel(ctx.read<FirestoreService>()),
        ),
        ChangeNotifierProvider<LocaleController>(
          create: (_) => LocaleController(savedLocaleCode, prefs),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// Основной виджет приложения
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVm   = context.watch<ThemeViewModel>();
    final authVm    = context.watch<AuthViewModel>();
    final localeCtl = context.watch<LocaleController>();

    return MaterialApp(
      title: 'Linearity',
      debugShowCheckedModeBanner: false,

      /// Подключаем светлую и тёмную тему
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeVm.isDark ? ThemeMode.dark : ThemeMode.light,

      /// Настраиваем локализацию
      locale: localeCtl.locale,
      supportedLocales: const [Locale('ru'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supported) {
        if (localeCtl.locale != null) return localeCtl.locale;
        return supported.contains(deviceLocale) ? deviceLocale : const Locale('en');
      },

      /// Выбираем стартовый экран по статусу авторизации
      home: authVm.isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : authVm.user == null
              ? const LoginView()
              : const HomeView(),

      routes: {
        '/login'       : (_) => const LoginView(),
        '/register'    : (_) => const RegisterView(),
        '/home'        : (_) => const HomeView(),
        '/editProfile' : (ctx) => ChangeNotifierProvider<EditProfileViewModel>(
              create: (_) => EditProfileViewModel(ctx),
              child: EditProfileView(),
            ),
      },
    );
  }
}
