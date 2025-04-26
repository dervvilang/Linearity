import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:linearity/themes/theme.dart'; // импорт светлой/тёмной темы
import 'package:linearity/views/home_view.dart'; // главный экран приложения
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Настраиваем системные оверлеи: нижняя навигационная панель прозрачная.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

/// Корневой виджет приложения.
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Флаг, определяющий текущую тему: false – светлая, true – тёмная.
  bool _isDarkTheme = false;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkTheme = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linearity',
      theme: lightTheme,       // Светлая тема
      darkTheme: darkTheme,    // Тёмная тема
      // Динамическое переключение темы.
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
      // Передаём актуальное состояние темы и callback в HomeView.
      home: HomeView(
        onThemeChanged: _toggleTheme,
        isDarkTheme: _isDarkTheme,
      ),
    );
  }
}
