// lib/views/setting_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/view_models/theme_vm.dart';
import 'package:linearity/view_models/notification_vm.dart';
import 'package:linearity/view_models/auth_vm.dart';
import 'package:linearity/views/login_view.dart';
import 'package:linearity/widgets/setting_card.dart';

import 'package:linearity/main.dart' show LocaleController;

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final loc     = AppLocalizations.of(context)!;
    final theme   = Theme.of(context);
    final colors  = theme.extension<AdditionalColors>()!;
    final themeVm = context.watch<ThemeViewModel>();
    final notifVm = context.watch<NotificationViewModel>();
    final localeCtl = context.watch<LocaleController>(); // <- контроллер языка

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
              child: Row(
                children: [
                  Material(
                    shape: const CircleBorder(),
                    color: colors.greetingText,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'lib/assets/icons/arrow_left.svg',
                        width: 26,
                        height: 26,
                        color: colors.text,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      loc.settingsTitle,
                      style: theme.textTheme.headlineMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── список настроек ─────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  // ─────────── профиль ───────────
                  SettingCard(
                    title: loc.editProfile,
                    onTap: () => Navigator.of(context).pushNamed('/editProfile'),
                    backColor: colors.ratingCard,
                    icon: SvgPicture.asset(
                      'lib/assets/icons/arrow_right_simple.svg',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ─────────── Светлая / тёмная тема ───────────
                  SettingCard(
                    title: loc.lightDarkTheme,
                    backColor: colors.ratingCard,
                    trailing: Switch(
                      value: themeVm.isDark,
                      onChanged: themeVm.toggleTheme,
                    ),
                    onTap: () {}, // необязательно
                  ),
                  const SizedBox(height: 4),

                  // ─────────── Переключатель языка ───────────
                  SettingCard(
                    // Добавьте соответствующую строку в l10n (например, "language")
                    title: loc.languageLabel,
                    backColor: colors.ratingCard,
                    trailing: Switch(
                      // true == русский, false == английский
                      value: localeCtl.locale?.languageCode == 'ru',
                      onChanged: (val) => localeCtl
                          .setLocale(Locale(val ? 'ru' : 'en')),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 4),

                  // ─────────── Уведомления ───────────
                  SettingCard(
                    title: loc.notifications,
                    backColor: colors.ratingCard,
                    trailing: Switch(
                      value: notifVm.isEnabled,
                      onChanged: (val) => notifVm.toggle(val),
                    ),
                    onTap: () {}, // или notifVm.toggle
                  ),
                  const SizedBox(height: 4),

                  // ─────────── Выход из аккаунта ───────────
                  SettingCard(
                    title: loc.exitButton,
                    onTap: () async {
                      await context.read<AuthViewModel>().logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginView()),
                        (_) => false,
                      );
                    },
                    backColor: colors.ratingCard,
                  ),
                  const SizedBox(height: 4),

                  // ─────────── Закрыть приложение ───────────
                  SettingCard(
                    title: loc.closeApp,
                    onTap: () => SystemNavigator.pop(),
                    backColor: colors.alertRed,
                    textColor: colors.errorRed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
