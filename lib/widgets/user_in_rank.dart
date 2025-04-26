import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linearity/themes/additional_colors.dart';

class UserInRank extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final int score;
  final int rank;
  // Параметр, указывающий, на каком фоне отображается карточка
  final bool isOnBlueBackground;

  const UserInRank({
    super.key,
    required this.username,
    required this.avatarUrl,
    required this.score,
    required this.rank,
    this.isOnBlueBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final rankString = rank < 10 ? '0$rank' : '$rank';
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final additionalColors = theme.extension<AdditionalColors>()!;

    // Если фон голубой, делаем текст номера белым, иначе — используем стандартный цвет.
    final rankTextColor =
        isOnBlueBackground ? additionalColors.text : additionalColors.greetingText;

    return Padding(
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.asset(
                        avatarUrl,
                        width: 48,
                        height: 48,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Оборачиваем колонку в Expanded, чтобы текст занимал оставшееся пространство
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
    );
  }
}
