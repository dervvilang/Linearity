// lib/views/win_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/views/home_view.dart';

/// Экран победы после решения задания
class WinView extends StatelessWidget {
  const WinView({super.key});

  /// Строит UI экрана победы
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;  
    final theme = Theme.of(context);  
    final colors = theme.extension<AdditionalColors>()!;  

    /// Выбирает иконку пламени в зависимости от темы
    final fireAsset = theme.brightness == Brightness.dark
        ? 'lib/assets/icons/blue_flame.svg'
        : 'lib/assets/icons/fire.svg';

    return Scaffold(
      /// Фон растягивается на весь экран
      body: SizedBox.expand(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            /// Радиа́льный градиент от центра к краям
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [
                colors.firstLevel,
                colors.secback,
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: SafeArea(
            /// Разрешает прокрутку на маленьких экранах
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: constraints.maxHeight < 600 ? 24 : 40,
                    bottom: 40,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 80,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Надпись о начисленных баллах
                        Text(
                          loc.plusThreePoints,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 32),

                        /// Иконка пламени
                        SvgPicture.asset(
                          fireAsset,
                          width: 260,
                          height: 260,
                        ),
                        const SizedBox(height: 48),

                        /// Заголовок «Вы прошли!»
                        Text(
                          loc.winTitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// Сообщение-поздравление
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
                        const SizedBox(height: 64),

                        /// Кнопка выхода на главный экран
                        SizedBox(
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
                                MaterialPageRoute(
                                  builder: (_) => const HomeView(),
                                ),
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
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
