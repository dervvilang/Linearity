import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:linearity/models/user.dart' as linearity_user;
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/views/home_view.dart';
import 'package:linearity/views/profile_view.dart';
import 'package:linearity/widgets/user_in_rank.dart';

class RatingView extends StatefulWidget {
  const RatingView({Key? key}) : super(key: key);

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  DateTime? _lastPressed;

  final List<linearity_user.AppUser> sampleUsers = [
    // … ваш список …
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;
    const double fixedAreaHeight = 85 * 3;

    final topUsers = sampleUsers.take(3).toList();
    final bottomUsers = sampleUsers.skip(3).toList();

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_lastPressed == null ||
            now.difference(_lastPressed!) > const Duration(seconds: 2)) {
          _lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Нажмите ещё раз для выхода',
                  style: TextStyle(color: colors.text)),
              backgroundColor: colors.secondary,
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
          backgroundColor: colors.secback,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: SafeArea(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(loc.ratingTitle,
                  style: theme.textTheme.headlineLarge
                      ?.copyWith(color: colors.text)),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: fixedAreaHeight,
              decoration: BoxDecoration(
                color: colors.secback,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: topUsers.map((u) {
                  return UserInRank(
                    rank: u.rank,
                    username: u.username,
                    avatarUrl: u.avatarUrl,
                    score: u.score,
                    isOnBlueBackground: true,
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: bottomUsers.length,
                itemBuilder: (_, i) {
                  final u = bottomUsers[i];
                  return UserInRank(
                    rank: u.rank,
                    username: u.username,
                    avatarUrl: u.avatarUrl,
                    score: u.score,
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: BottomNavigationBar(
            currentIndex: 1,
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
                  color: colors.greetingText,
                ),
                label: loc.rating,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/assets/icons/profile.svg',
                  width: 24,
                  height: 24,
                  color: colors.inactiveButtons,
                ),
                label: loc.profile,
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HomeView()));
              } else if (index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileView()));
              }
            },
          ),
        ),
      ),
    );
  }
}
