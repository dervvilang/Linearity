/// -----------------------------------------------------------------------------
/// win_view.dart
/// -----------------------------------------------------------------------------
/// Экран, который отображается после успешного прохождения уровня/задания.
/// 
/// Здесь учтены следующие моменты:
/// * Контейнер‑фон развёрнут на **всю** доступную площадь экрана с помощью
///   `BoxConstraints.expand()`. Это устраняет проблему «чёрной полосы» на
///   широких дисплеях, поскольку фон теперь неизбежно занимает 100 % ширины
///   и высоты.
/// * Добавлен `LayoutBuilder` + `SingleChildScrollView` – если высоты
///   устройства не хватит (например на устройствах с маленьким экраном или при
///   открытой клавиатуре), содержимое можно будет прокрутить, вместо того чтобы
///   вызвать переполнение.
/// * Код снабжён поясняющими `///`‑комментариями — их можно использовать
///   напрямую в отчёте по курсовой работе.
/// -----------------------------------------------------------------------------
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/views/home_view.dart';

/// Экран «Победа» (You win!)
class WinView extends StatelessWidget {
  const WinView({super.key});

  @override
  Widget build(BuildContext context) {
    /// Локализованные строки
    final loc = AppLocalizations.of(context)!;

    /// Текущая тема (для текста + выбора иконки)
    final theme = Theme.of(context);

    /// Дополнительная палитра из `AdditionalColors`
    final colors = theme.extension<AdditionalColors>()!;

    // -----------------------------------------------------------------------
    // Выбираем SVG‑иконку в зависимости от темы (тёмная / светлая)
    // -----------------------------------------------------------------------
    final fireAsset = theme.brightness == Brightness.dark
        ? 'lib/assets/icons/blue_flame.svg'
        : 'lib/assets/icons/fire.svg';

    return Scaffold(
      // ---------------------------------------------------------------------
      // `body` растягиваем на всю площадь экрана. BoxConstraints.expand()
      // выставляется через SizedBox.expand, чтобы родительский Scaffold не
      // влиял на размеры Container.
      // ---------------------------------------------------------------------
      body: SizedBox.expand(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            // Радиа́льный градиент: лёгкое свечение из центра
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [
                colors.firstLevel, // яркий центр
                colors.secback,    // более тёмная периферия
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: SafeArea(
            // LayoutBuilder позволит узнать фактическую высоту и при
            // необходимости показать скролл.
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    // Добавляем верхний отступ, но не меньше 24 dp
                    top: constraints.maxHeight < 600 ? 24 : 40,
                    bottom: 40,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      // Минимальная высота = высота экрана — обеспечиваем
                      // позиционирование элементов точно по центру даже при
                      // отсутствии прокрутки.
                      minHeight: constraints.maxHeight - 80,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // --------------------------------------------------
                        // +3 points (заголовок)
                        // --------------------------------------------------
                        Text(
                          loc.plusThreePoints,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // --------------------------------------------------
                        // SVG иконка (пламя)
                        // --------------------------------------------------
                        SvgPicture.asset(
                          fireAsset,
                          width: 260,
                          height: 260,
                        ),

                        const SizedBox(height: 48),

                        // --------------------------------------------------
                        // Заголовок «You did it!» / «Вы прошли!»
                        // --------------------------------------------------
                        Text(
                          loc.winTitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // --------------------------------------------------
                        // Подзаголовок
                        // --------------------------------------------------
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            loc.winMessage,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color:
                                  theme.colorScheme.onPrimary.withOpacity(0.9),
                            ),
                          ),
                        ),

                        const SizedBox(height: 64),

                        // --------------------------------------------------
                        // Кнопка EXIT — возвращается на HomeView и очищает стек
                        // --------------------------------------------------
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
                              // Удаляем все предыдущие маршруты и переходим
                              // на домашний экран.
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
