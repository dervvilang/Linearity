/// -----------------------------------------------------------------------------
/// lib/views/public_profile_view.dart
/// -----------------------------------------------------------------------------
/// Экран публичного профиля любого пользователя — аналог ProfileView,
/// но без возможности редактирования.
///
/// Особенности реализации:
/// * Использует ChangeNotifierProvider для PublicProfileViewModel,
///   который загружает данные по [uid].
/// * Показывает состояния загрузки, ошибки и основное содержимое:
///   аватар, имя, ранг, баллы и описание профиля.
/// * Убрана нижняя панель навигации.
/// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/view_models/public_profile_vm.dart';
import 'package:linearity/services/firestore_service.dart';
import 'package:linearity/views/home_view.dart';
import 'package:linearity/views/rating_view.dart';
import 'package:linearity/widgets/rating_card.dart';

/// Публичный профиль пользователя.
/// Не позволяет редактировать данные — только просмотр.
class PublicProfileView extends StatelessWidget {
  /// Идентификатор пользователя.
  final String uid;

  const PublicProfileView({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;

    return ChangeNotifierProvider(
      create: (_) => PublicProfileViewModel(
        firestoreService: context.read<FirestoreService>(),
        uid: uid,
      )..load(),
      child: Consumer<PublicProfileViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (vm.hasError || vm.user == null) {
            return Scaffold(
              body: Center(
                child: Text(
                  loc.loadError,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            );
          }

          final user = vm.user!;

          return Scaffold(
            appBar: AppBar(
              title: Text(user.username),
              backgroundColor: theme.scaffoldBackgroundColor,
              elevation: 0,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Аватар через локальный SVG
                    CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.asset(
                        user.avatarAsset,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Никнейм
                    Text(
                      user.username,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),

                    // Статистика: ранг и очки
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: RatingCard(
                              icon: SvgPicture.asset(
                                'lib/assets/icons/medal.svg',
                                width: 28,
                                height: 28,
                                color: colors.gold,
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
                          const SizedBox(width: 8),
                          Expanded(
                            child: RatingCard(
                              icon: SvgPicture.asset(
                                'lib/assets/icons/coin.svg',
                                width: 26,
                                height: 26,
                                color: colors.gold,
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
                    ),
                    const SizedBox(height: 24),

                    // Описание профиля в виде карточки
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              user.description.isEmpty
                                  ? ' '
                                  : user.description,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
