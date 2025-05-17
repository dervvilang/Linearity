// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'themes/theme.dart';
import 'services/firestore_service.dart';
import 'view_models/auth_vm.dart';
import 'view_models/level_selection_vm.dart';
import 'view_models/task_vm.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Прозрачная нижняя панель
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Локальный флаг переключения темы (например, из HomeView)
  bool _isDarkTheme = false;

  void _toggleTheme(bool isDark) {
    setState(() => _isDarkTheme = isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Авторизация
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(),
        ),
        // Сервис Firestore
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
        // VM для выбора уровня
        ChangeNotifierProvider<LevelSelectionViewModel>(
          create: (ctx) =>
              LevelSelectionViewModel(ctx.read<FirestoreService>()),
        ),
        // VM для задач
        ChangeNotifierProvider<TaskViewModel>(
          create: (ctx) => TaskViewModel(ctx.read<FirestoreService>()),
        ),
        // TODO: Добавить SettingsViewModel, RatingViewModel и др.
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, auth, _) {
          // Выбираем тему: либо глобальный isDarkTheme, либо настройка пользователя
          final themeMode = auth.user?.userTheme == 'dark' || _isDarkTheme
              ? ThemeMode.dark
              : ThemeMode.light;

          return MaterialApp(
            title: 'Linearity',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru', ''),
              Locale('en', ''),
            ],

            // Если идёт загрузка или нет пользователя — показываем правильный экран
            home: auth.isLoading
                ? const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  )
                : auth.user == null
                    ? LoginView(
                        isDarkTheme: _isDarkTheme,
                        onThemeChanged: _toggleTheme,
                      )
                    : HomeView(
                        isDarkTheme: _isDarkTheme,
                        onThemeChanged: _toggleTheme,
                      ),

            // Роуты для явного перехода
            routes: {
              '/login': (_) => LoginView(
                    isDarkTheme: _isDarkTheme,
                    onThemeChanged: _toggleTheme,
                  ),
              '/register': (_) => RegisterView(
                    isDarkTheme: _isDarkTheme,
                    onThemeChanged: _toggleTheme,
                  ),
              '/home': (_) => HomeView(
                    isDarkTheme: _isDarkTheme,
                    onThemeChanged: _toggleTheme,
                  ),
              // TODO: добавить другие экраны '/profile', '/settings' и т. д.
            },
          );
        },
      ),
    );
  }
}
