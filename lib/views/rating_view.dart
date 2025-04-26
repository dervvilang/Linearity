import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Для SystemNavigator.pop()
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linearity/models/user.dart' as linearity_user;
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/views/home_view.dart';
import 'package:linearity/views/profile_view.dart';
import 'package:linearity/widgets/user_in_rank.dart';

class RatingView extends StatefulWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  const RatingView({
    super.key,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  DateTime? _lastPressed;

  // Пример списка пользователей (8 элементов)
  final List<linearity_user.User> sampleUsers = [
    linearity_user.User(
      id: '1',
      username: 'Alice',
      avatarUrl: 'lib/assets/icons/avatar_2.svg',
      email: 'alice@example.com',
      score: 1200,
      rank: 1,
      description: 'Лучший пользователь по математике.',
    ),
    linearity_user.User(
      id: '2',
      username: 'Bob',
      avatarUrl: 'lib/assets/icons/avatar_2.svg',
      email: 'bob@example.com',
      score: 1100,
      rank: 2,
      description: 'Надежный и постоянный участник.',
    ),
    linearity_user.User(
      id: '3',
      username: 'Charlie',
      avatarUrl: 'lib/assets/icons/avatar_2.svg',
      email: 'charlie@example.com',
      score: 900,
      rank: 3,
      description: 'Постепенно улучшает свои результаты.',
    ),
    linearity_user.User(
      id: '4',
      username: 'Diana',
      avatarUrl: 'lib/assets/icons/avatar_2.svg',
      email: 'diana@example.com',
      score: 851,
      rank: 4,
      description: 'Активный участник, много практикуется.',
    ),
    linearity_user.User(
      id: '5',
      username: 'Eve',
      avatarUrl: 'lib/assets/icons/avatar_2.svg',
      email: 'eve@example.com',
      score: 800,
      rank: 5,
      description: 'Активный участник, много практикуется.',
    ),
    linearity_user.User(
      id: '6',
      username: 'Frank',
      avatarUrl: 'lib/assets/icons/avatar_2.svg',
      email: 'frank@example.com',
      score: 750,
      rank: 6,
      description: 'Активный участник, много практикуется.',
    ),
    linearity_user.User(
      id: '7',
      username: 'George',
      avatarUrl: 'lib/assets/icons/avatar_2.svg',
      email: 'george@example.com',
      score: 700,
      rank: 7,
      description: 'Постепенно улучшает свои результаты.',
    ),
    linearity_user.User(
      id: '8',
      username: 'DianaExtended',
      avatarUrl: 'lib/assets/icons/avatar_2.svg',
      email: 'diana@example.com',
      score: 654,
      rank: 8,
      description: 'Постепенно улучшает свои результаты.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final additionalColors = theme.extension<AdditionalColors>()!;
    const double fixedAreaHeight = 85 * 3;

    // Разбиваем список пользователей на две группы: первые 3 и остальные.
    final topUsers = sampleUsers.take(3).toList();
    final bottomUsers = sampleUsers.skip(3).toList();

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_lastPressed == null || now.difference(_lastPressed!) > const Duration(seconds: 2)) {
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: additionalColors.secback,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: SafeArea(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                loc.ratingTitle,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: additionalColors.text,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // Голубой контейнер для первых трёх пользователей.
            Container(
              width: double.infinity,
              height: fixedAreaHeight,
              decoration: BoxDecoration(
                color: additionalColors.secback,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: topUsers.map((user) {
                  return UserInRank(
                    rank: user.rank,
                    username: user.username,
                    avatarUrl: user.avatarUrl,
                    score: user.score,
                    isOnBlueBackground: true,
                  );
                }).toList(),
              ),
            ),
            // Скроллируемый список остальных пользователей.
            Expanded(
              child: ListView.builder(
                itemCount: bottomUsers.length,
                itemBuilder: (context, index) {
                  final user = bottomUsers[index];
                  return UserInRank(
                    rank: user.rank,
                    username: user.username,
                    avatarUrl: user.avatarUrl,
                    score: user.score,
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: 1,
            selectedItemColor: additionalColors.greetingText,
            unselectedItemColor: additionalColors.inactiveButtons,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/assets/icons/home.svg',
                  width: 24,
                  height: 24,
                  color: additionalColors.inactiveButtons,
                ),
                label: loc.home,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/assets/icons/line_medal.svg',
                  width: 24,
                  height: 24,
                  color: additionalColors.greetingText,
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
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeView(
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
