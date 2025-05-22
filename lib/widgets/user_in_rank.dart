// lib/widgets/user_in_rank.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/views/public_profile_view.dart';

/// Виджет строки рейтинга
class UserInRank extends StatelessWidget {
  /// ID пользователя для перехода
  final String uid;
  /// Имя пользователя
  final String username;
  /// Путь к SVG-аватару
  final String avatarAsset;
  /// Количество очков
  final int score;
  /// Место в рейтинге
  final int rank;
  /// Стилизация для топ-3
  final bool isOnBlueBackground;

  const UserInRank({
    super.key,
    required this.uid,
    required this.username,
    required this.avatarAsset,
    required this.score,
    required this.rank,
    this.isOnBlueBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    /// Две цифры для ранга (например, 01, 02)
    final rankString = rank < 10 ? '0$rank' : '$rank';
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;

    /// Цвет текста ранга
    final rankTextColor =
        isOnBlueBackground ? colors.text : colors.greetingText;

    return InkWell(
      /// Открывает публичный профиль
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PublicProfileView(uid: uid),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Row(
          children: [
            /// Отображает номер места
            Text(
              rankString,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: rankTextColor,
              ),
            ),
            const SizedBox(width: 8),
            /// Карточка с аватаром и именем
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      /// Аватарка пользователя
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.transparent,
                        child: SvgPicture.asset(
                          avatarAsset,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      /// Имя и очки
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Имя пользователя
                            Text(
                              username,
                              style: theme.textTheme.headlineSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            /// Количество очков
                            Text(
                              '$score ${loc.pointsLabel(score)}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
