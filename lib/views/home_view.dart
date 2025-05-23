// lib/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/view_models/auth_vm.dart';
import 'package:linearity/views/levels_list_view.dart';
import 'package:linearity/views/profile_view.dart';
import 'package:linearity/views/rating_view.dart';
import 'package:linearity/widgets/category_card.dart';
import 'package:linearity/widgets/rating_card.dart';
import 'package:linearity/models/task_type.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

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
    final colors = theme.extension<AdditionalColors>()!;

    final authVm = context.watch<AuthViewModel>();
    final user = authVm.user;
    if (authVm.isLoading || user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// Обрабатывает двойное нажатие назад для выхода из приложения
    Future<bool> _onWillPop() async {
      final now = DateTime.now();
      if (_lastPressed == null ||
          now.difference(_lastPressed!) > const Duration(seconds: 2)) {
        _lastPressed = now;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Нажмите ещё раз для выхода', style: TextStyle(color: colors.text)),
            backgroundColor: colors.secondary,
          ),
        );
        return false;
      }
      await SystemNavigator.pop();
      return true;
    }

    /// Строит виджет аватара пользователя
    Widget _buildAvatar() {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset(user.avatarAsset, width: 48, height: 48),
      );
    }

    /// Компонент нижней навигации
    Widget _buildBottomNav() {
      return BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: colors.greetingText,
        unselectedItemColor: colors.inactiveButtons,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/home.svg', width: 24, height: 24, color: colors.greetingText),
            label: loc.home,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/line_medal.svg', width: 24, height: 24, color: colors.inactiveButtons),
            label: loc.rating,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('lib/assets/icons/profile.svg', width: 24, height: 24, color: colors.inactiveButtons),
            label: loc.profile,
          ),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const RatingView()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileView()));
          }
        },
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // верхняя панель с приветствием и аватаром
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(loc.helloUser, style: theme.textTheme.headlineLarge?.copyWith(color: colors.greetingText)),
                        Text(user.username, style: theme.textTheme.headlineMedium),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileView())),
                      child: _buildAvatar(),
                    ),
                  ],
                ),
              ),

              // основной контент: рейтинг и категории
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 14),
                        // карточки рейтинга
                        Row(
                          children: [
                            Expanded(
                              child: RatingCard(
                                icon: SvgPicture.asset('lib/assets/icons/medal.svg', width: 28, height: 28),
                                title: '${user.rank} ${loc.placeLabel}',
                                subtitle: loc.commonRating,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RatingView())),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: RatingCard(
                                icon: SvgPicture.asset('lib/assets/icons/coin.svg', width: 26, height: 26),
                                title: '${user.score}',
                                subtitle: loc.pointsLabel(user.score),
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RatingView())),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // категории заданий
                        CategoryCard(
                          icon: SvgPicture.asset('lib/assets/icons/matrix_simple.svg', width: 34, height: 34),
                          title: loc.basicTasks,
                          subtitle: loc.addMatrixTask,
                          color: colors.primary,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LevelsListView(taskType: TaskType.basic))),
                        ),
                        const SizedBox(height: 4),
                        CategoryCard(
                          icon: SvgPicture.asset('lib/assets/icons/matrix_simple.svg', width: 34, height: 34),
                          title: loc.simpleTasks,
                          subtitle: loc.multMatrixTask,
                          color: colors.fifth,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LevelsListView(taskType: TaskType.simple))),
                        ),
                        const SizedBox(height: 4),
                        CategoryCard(
                          icon: SvgPicture.asset('lib/assets/icons/matrix_medium.svg', width: 34, height: 34),
                          title: loc.middleTasks,
                          subtitle: loc.detMatrixTask,
                          color: colors.secondary,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LevelsListView(taskType: TaskType.medium))),
                        ),
                        const SizedBox(height: 4),
                        CategoryCard(
                          icon: SvgPicture.asset('lib/assets/icons/matrix_hard.svg', width: 34, height: 34),
                          title: loc.hardTasks,
                          subtitle: loc.inverseMatrixTask,
                          color: colors.tertiary,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LevelsListView(taskType: TaskType.hard))),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(child: _buildBottomNav()),
      ),
    );
  }
}
