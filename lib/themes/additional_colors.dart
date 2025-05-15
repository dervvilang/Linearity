import 'package:flutter/material.dart';

/// Дополнительное расширение темы для хранения цветов, которые не входят в стандартный ColorScheme.
/// Эти цвета можно использовать в кастомных виджетах, и они будут автоматически меняться при переключении темы.
@immutable
class AdditionalColors extends ThemeExtension<AdditionalColors> {
  final Color scaffold;
  final Color text;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color successGreen;
  final Color errorRed;
  final Color alertRed;
  final Color gold;
  final Color primaryGrey;
  final Color inactiveButtons;
  final Color firstLevel;
  final Color secondLevel;
  final Color secback;
  final Color hint;
  final Color greetingText;
  final Color ratingCard;
  final Color fifth;

  const AdditionalColors({
    required this.scaffold,
    required this.text,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.successGreen,
    required this.errorRed,
    required this.alertRed,
    required this.gold,
    required this.primaryGrey,
    required this.inactiveButtons,
    required this.greetingText,
    required this.ratingCard,
    required this.firstLevel,
    required this.secondLevel,
    required this.secback,
    required this.hint,
    required this.fifth,
  });

  @override
  AdditionalColors copyWith({
    Color? scaffold,
    Color? text,
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? successGreen,
    Color? errorRed,
    Color? alertRed,
    Color? gold,
    Color? primaryGrey,
    Color? inactiveButtons,
    Color? greetingText,
    Color? ratingCard,
    Color? firstLevel,
    Color? secondLevel,
    Color? secback,
    Color? hint,
    Color? fifth,
  }) {
    return AdditionalColors(
      scaffold: scaffold ?? this.scaffold,
      text: text ?? this.text,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      successGreen: successGreen ?? this.successGreen,
      errorRed: errorRed ?? this.errorRed,
      alertRed: alertRed ?? this.alertRed,
      gold: gold ?? this.gold,
      primaryGrey: primaryGrey ?? this.primaryGrey,
      inactiveButtons: inactiveButtons ?? this.inactiveButtons,
      greetingText: greetingText ?? this.greetingText,
      ratingCard: ratingCard ?? this.ratingCard,
      firstLevel: firstLevel ?? this.firstLevel,
      secondLevel: secondLevel ?? this.secondLevel,
      secback: secback ?? this.secback,
      hint: hint ?? this.hint,
      fifth: fifth ?? this.fifth,
    );
  }

  @override
  AdditionalColors lerp(ThemeExtension<AdditionalColors>? other, double t) {
    if (other is! AdditionalColors) return this;
    return AdditionalColors(
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      text: Color.lerp(text, other.text, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      successGreen: Color.lerp(successGreen, other.successGreen, t)!,
      errorRed: Color.lerp(errorRed, other.errorRed, t)!,
      alertRed: Color.lerp(alertRed, other.alertRed, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      primaryGrey: Color.lerp(primaryGrey, other.primaryGrey, t)!,
      inactiveButtons: Color.lerp(inactiveButtons, other.inactiveButtons, t)!,
      greetingText: Color.lerp(greetingText, other.greetingText, t)!,
      ratingCard: Color.lerp(ratingCard, other.ratingCard, t)!,
      firstLevel: Color.lerp(firstLevel, other.firstLevel, t)!,
      secondLevel: Color.lerp(secondLevel, other.secondLevel, t)!,
      secback: Color.lerp(secback, other.secback, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      fifth: Color.lerp(fifth, other.fifth, t)!,
    );
  }
}
