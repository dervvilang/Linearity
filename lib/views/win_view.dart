// lib/views/win_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/views/home_view.dart';

class WinView extends StatelessWidget {
  const WinView({super.key});

  @override
  Widget build(BuildContext context) {
    final loc    = AppLocalizations.of(context)!;
    final theme  = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;

    // Выбираем svg-иконку под текущую тему
    final fireAsset = theme.brightness == Brightness.dark
        ? 'lib/assets/icons/blue_flame.svg'
        : 'lib/assets/icons/fire.svg';

    return Scaffold(
      // Радиальный градиент фона — сияние из центра
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [
              colors.firstLevel,
              colors.secback,
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // +3 балла
              Text(
                loc.plusThreePoints,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),

              // Иконка огня
              SvgPicture.asset(
                fireAsset,
                width: 260,
                height: 260,
              ),

              const SizedBox(height: 48),

              // «Вы прошли!»
              Text(
                loc.winTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              // Подзаголовок
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  loc.winMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary.withOpacity(0.9),
                  ),
                ),
              ),

              const Spacer(),

              // Кнопка «Выйти» — возвращаемся на HomeView, очищая стек
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: SizedBox(
                  width: 240,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.firstLevel,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeView()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      loc.exitButton,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.text2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
