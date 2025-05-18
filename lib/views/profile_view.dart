// lib/views/profile_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/view_models/auth_vm.dart';
import 'package:linearity/views/setting_view.dart';
import 'package:linearity/views/rating_view.dart';
import 'package:linearity/views/home_view.dart';
import 'package:linearity/widgets/editable_about_me_card.dart';
import 'package:linearity/widgets/rating_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.user;

    // 1) Если мы еще грузим состояние аутентификации — показываем спиннер
    if (authVm.isLoading && user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2) Если не залогинен — редиректим на логин
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (_) => false);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    // 3) Здесь уже точно есть user и мы не в процессе его загрузки
    DateTime? lastPressed;
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
                style: TextStyle(color: colors.text),
              ),
              backgroundColor: colors.secondary,
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
                // Кнопка «Настройки»
                Align(
                  alignment: Alignment.topRight,
                  child: Material(
                    color: colors.inactiveButtons,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingView(),
                        ),
                      ),
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'lib/assets/icons/setting.svg',
                          width: 30,
                          height: 30,
                          color: colors.text,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Аватар
                CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: user.avatarUrl.startsWith('http')
                        ? Image.network(
                            user.avatarUrl,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : SvgPicture.asset(
                            user.avatarUrl,
                            width: 135,
                            height: 135,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Никнейм
                Text(user.username, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 10),

                // Ранг, очки и «О себе»
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RatingCard(
                              icon: SvgPicture.asset(
                                'lib/assets/icons/medal.svg',
                                width: 28,
                                height: 28,
                              ),
                              title: '${user.rank} ${loc.placeLabel}',
                              subtitle: loc.commonRating,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RatingView(),
                                ),
                              ),
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
                              title: '${user.score}',
                              subtitle: loc.pointsLabel(user.score),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RatingView(),
                                ),
                              ),
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
          child: BottomNavigationBar(
            currentIndex: 2,
            selectedItemColor: colors.greetingText,
            unselectedItemColor: colors.inactiveButtons,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/assets/icons/home.svg',
                  width: 24,
                  height: 24,
                  color: colors.inactiveButtons,
                ),
                label: loc.home,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/assets/icons/line_medal.svg',
                  width: 24,
                  height: 24,
                  color: colors.inactiveButtons,
                ),
                label: loc.rating,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/assets/icons/profile.svg',
                  width: 24,
                  height: 24,
                  color: colors.greetingText,
                ),
                label: loc.profile,
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeView()),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RatingView()),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
