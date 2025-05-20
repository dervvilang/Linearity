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
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Прозрачная навигационная панель
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );

  // Инициализируем NotificationService и SharedPreferences
  final notifSvc = NotificationService();
  await notifSvc.init();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeViewModel>(
          create: (_) => ThemeViewModel(),
        ),
        ChangeNotifierProvider<NotificationViewModel>(
          create: (_) => NotificationViewModel(notifSvc, prefs),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(),
        ),
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
        ChangeNotifierProvider<LevelSelectionViewModel>(
          create: (ctx) =>
              LevelSelectionViewModel(ctx.read<FirestoreService>()),
        ),
        ChangeNotifierProvider<TaskViewModel>(
          create: (ctx) => TaskViewModel(ctx.read<FirestoreService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeVm = context.watch<ThemeViewModel>();
    final authVm = context.watch<AuthViewModel>();

    return MaterialApp(
      title: 'Linearity',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeVm.isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ru'), Locale('en')],
      home: authVm.isLoading
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : authVm.user == null
              ? const LoginView()
              : const HomeView(),
      routes: {
        '/login': (_) => const LoginView(),
        '/register': (_) => const RegisterView(),
        '/home': (_) => const HomeView(),
      },
    );
  }
}
