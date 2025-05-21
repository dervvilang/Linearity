// lib/views/rating_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/view_models/rating_vm.dart';
import 'package:linearity/widgets/user_in_rank.dart';
import 'package:linearity/views/home_view.dart';
import 'package:linearity/views/profile_view.dart';

class RatingView extends StatelessWidget {
  const RatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = RatingViewModel(context.read<FirestoreService>());
        vm.loadUsers();
        return vm;
      },
      child: const _RatingViewBody(),
    );
  }
}

class _RatingViewBody extends StatefulWidget {
  const _RatingViewBody();

  @override
  State<_RatingViewBody> createState() => _RatingViewBodyState();
}

class _RatingViewBodyState extends State<_RatingViewBody> {
  DateTime? _lastPressed;

  @override
  Widget build(BuildContext context) {
    final loc    = AppLocalizations.of(context)!;
    final theme  = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;
    final vm     = context.watch<RatingViewModel>();

    // обработка "двойного" Back-press
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colors.secback,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: SafeArea(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                loc.ratingTitle,
                style: theme.textTheme.headlineLarge
                    ?.copyWith(color: colors.text),
              ),
            ),
          ),
        ),
        body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.hasError
              ? Center(
                  child: Text(
                    loc.loadError,
                    style: theme.textTheme.bodyLarge,
                  ),
                )
              : Column(
                  children: [
                    // Топ-3
                    Container(
                      width: double.infinity,
                      height: 85 * 3.0,
                      decoration: BoxDecoration(
                        color: colors.secback,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: vm.users.take(3).map((u) {
                          return UserInRank(
                            uid: u.id,
                            rank: u.rank,
                            username: u.username,
                            avatarAsset: u.avatarAsset,
                            score: u.score,
                            isOnBlueBackground: true,
                          );
                        }).toList(),
                      ),
                    ),

                    // Остальные
                    Expanded(
                      child: ListView.builder(
                        itemCount: vm.users.length > 3 ? vm.users.length - 3 : 0,
                        itemBuilder: (_, i) {
                          final u = vm.users[i + 3];
                          return UserInRank(
                            uid: u.id,
                            rank: u.rank,
                            username: u.username,
                            avatarAsset: u.avatarAsset,
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
