import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/views/public_profile_view.dart';

/// Виджет одной строки в рейтинге. При тапе переходит на публичный профиль пользователя.
class UserInRank extends StatelessWidget {
  /// Идентификатор пользователя для перехода на его страницу.
  final String uid;
  final String username;
  final String avatarAsset;
  final int score;
  final int rank;
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
    final rankString = rank < 10 ? '0$rank' : '$rank';
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;

    final rankTextColor =
        isOnBlueBackground ? colors.text : colors.greetingText;

    return InkWell(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              rankString,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: rankTextColor,
              ),
            ),
            const SizedBox(width: 8),
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
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: SvgPicture.asset(
                            avatarAsset,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: theme.textTheme.headlineSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
