// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:linearity/themes/theme.dart';
import 'package:linearity/views/home_view.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/view_models/level_selection_vm.dart';
import 'package:linearity/view_models/task_vm.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Прозрачная нижняя панель
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkTheme = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Сервис доступа к Firestore
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
        // ViewModel экрана выбора уровня
        ChangeNotifierProvider<LevelSelectionViewModel>(
          create: (ctx) =>
              LevelSelectionViewModel(ctx.read<FirestoreService>()),
        ),
        // ViewModel экрана задач
        ChangeNotifierProvider<TaskViewModel>(
          create: (ctx) => TaskViewModel(ctx.read<FirestoreService>()),
        ),
        // TODO: Добавить AuthViewModel, SettingsViewModel и т. д.
      ],
      child: MaterialApp(
        title: 'Linearity',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        localizationsDelegates: const [
          AppLocalizations.delegate,             
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', ''), // Русский
          Locale('en', ''), // Английский
        ],
        home: HomeView(
          isDarkTheme: _isDarkTheme,
          onThemeChanged: _toggleTheme,
        ),
      ),
    );
  }
}
