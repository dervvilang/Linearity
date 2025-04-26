import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/views/setting_view.dart';
import 'package:linearity/views/rating_view.dart';
import 'package:linearity/views/home_view.dart';
import 'package:linearity/widgets/editable_about_me_card.dart';
import 'package:linearity/widgets/rating_card.dart';

class ProfileView extends StatelessWidget {
  // Удаляем isDarkTheme из конструктора, т.к. его будем получать динамически
  final ValueChanged<bool> onThemeChanged;

  const ProfileView({
    super.key,
    required this.onThemeChanged, required bool isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressed;
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final additionalColors = theme.extension<AdditionalColors>()!;

    // Получаем актуальное состояние темы из контекста:
    final bool currentIsDarkTheme = theme.brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Кнопка перехода в настройки, выровненная по правому краю.
                Align(
                  alignment: Alignment.topRight,
                  child: Material(
                    color: additionalColors.inactiveButtons,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingView(
                              // Передаём актуальное состояние темы из контекста
                              isDarkTheme: currentIsDarkTheme,
                              onThemeChanged: onThemeChanged,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'lib/assets/icons/setting.svg',
                          width: 30,
                          height: 30,
                          color: additionalColors.text,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: SvgPicture.asset(
                      'lib/assets/icons/avatar_2.svg',
                      width: 135,
                      height: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'UserName',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
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
                                      isDarkTheme: currentIsDarkTheme,
                                      onThemeChanged: onThemeChanged,
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
                                      isDarkTheme: currentIsDarkTheme,
                                      onThemeChanged: onThemeChanged,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const EditableAboutMeCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: 2,
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
                  color: additionalColors.inactiveButtons,
                ),
                label: loc.rating,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/assets/icons/profile.svg',
                  width: 24,
                  height: 24,
                  color: additionalColors.greetingText,
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
                      isDarkTheme: currentIsDarkTheme,
                      onThemeChanged: onThemeChanged,
                    ),
                  ),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RatingView(
                      isDarkTheme: currentIsDarkTheme,
                      onThemeChanged: onThemeChanged,
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
