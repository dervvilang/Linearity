import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Для SystemNavigator.pop()
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linearity/models/task_type.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/views/levels_list_view.dart';
import 'package:linearity/views/profile_view.dart';
import 'package:linearity/views/rating_view.dart';
import 'package:linearity/widgets/category_card.dart';
import 'package:linearity/widgets/rating_card.dart';

class HomeView extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final bool isDarkTheme;

  const HomeView({
    super.key,
    required this.onThemeChanged,
    required this.isDarkTheme,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  DateTime? _lastPressed;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final additionalColors = theme.extension<AdditionalColors>()!;

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_lastPressed == null ||
            now.difference(_lastPressed!) > const Duration(seconds: 2)) {
          _lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Нажмите ещё раз для выхода',
                style: TextStyle(color: additionalColors.text),
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: additionalColors.secondary,
            ),
          );
          return false;
        }
        await SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Кастомный AppBar высотой 100 пикселей.
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.helloUser,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: additionalColors.greetingText,
                          ),
                        ),
                        Text(
                          'UserName',
                          style: theme.textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Передаём актуальное состояние темы в ProfileView.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileView(
                              isDarkTheme: widget.isDarkTheme,
                              onThemeChanged: widget.onThemeChanged,
                            ),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        'lib/assets/icons/avatar_2.svg',
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Виджеты с рейтингом и баллами.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: RatingCard(
                                icon: SvgPicture.asset(
                                  'lib/assets/icons/medal.svg',
                                  width: 28,
                                  height: 28,
                                ),
                                title: "4 ${loc.placeLabel}",
                                subtitle: loc.commonRating,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RatingView(
                                        isDarkTheme: widget.isDarkTheme,
                                        onThemeChanged: widget.onThemeChanged,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: RatingCard(
                                icon: SvgPicture.asset(
                                  'lib/assets/icons/coin.svg',
                                  width: 26,
                                  height: 26,
                                ),
                                title: "680",
                                subtitle: loc.pointsLabel(680),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RatingView(
                                        isDarkTheme: widget.isDarkTheme,
                                        onThemeChanged: widget.onThemeChanged,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Виджеты с типами заданий.
                        Column(
                          children: [
                            CategoryCard(
                              icon: SvgPicture.asset(
                                'lib/assets/icons/matrix_simple.svg',
                                width: 34,
                                height: 34,
                              ),
                              title: loc.simpleTasks,
                              subtitle: loc.inverseMatrixTask,
                              color: additionalColors.primary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LevelsListView(
                                      taskType: TaskType.simple,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 4),
                            CategoryCard(
                              icon: SvgPicture.asset(
                                'lib/assets/icons/matrix_medium.svg',
                                width: 34,
                                height: 34,
                              ),
                              title: loc.middleTasks,
                              subtitle: loc.addMatrixTask,
                              color: additionalColors.secondary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LevelsListView(
                                      taskType: TaskType.medium,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 4),
                            CategoryCard(
                              icon: SvgPicture.asset(
                                'lib/assets/icons/matrix_hard.svg',
                                width: 34,
                                height: 34,
                              ),
                              title: loc.hardTasks,
                              subtitle: loc.detMatrixTask,
                              color: additionalColors.tertiary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LevelsListView(
                                      taskType: TaskType.hard,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/assets/icons/home.svg',
                  width: 24,
                  height: 24,
                  color: additionalColors.greetingText,
                ),
                label: loc.home,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/assets/icons/line_medal.svg',
                  width: 24,
                  height: 24,
                  color: additionalColors.inactiveButtons,
                ),
                label: loc.rating,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/assets/icons/profile.svg',
                  width: 24,
                  height: 24,
                  color: additionalColors.inactiveButtons,
                ),
                label: loc.profile,
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RatingView(
                      isDarkTheme: widget.isDarkTheme,
                      onThemeChanged: widget.onThemeChanged,
                    ),
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileView(
                      isDarkTheme: widget.isDarkTheme,
                      onThemeChanged: widget.onThemeChanged,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
