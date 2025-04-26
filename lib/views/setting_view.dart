import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/widgets/setting_card.dart';

class SettingView extends StatefulWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  const SettingView({
    super.key,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late bool _isDarkTheme;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = widget.isDarkTheme;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final additionalColors = theme.extension<AdditionalColors>()!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Кастомный AppBar.
            Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    shape: const CircleBorder(),
                    color: additionalColors.greetingText,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'lib/assets/icons/arrow_left.svg',
                        width: 26,
                        height: 26,
                        color: additionalColors.text,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      loc.settingsTitle,
                      style: theme.textTheme.headlineMedium,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SettingCard(
                    title: loc.editProfile,
                    onTap: () {},
                    backColor: additionalColors.ratingCard,
                    icon: SvgPicture.asset(
                      'lib/assets/icons/arrow_right_simple.svg',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SettingCard(
                    title: loc.parameters,
                    onTap: () {},
                    backColor: additionalColors.ratingCard,
                    icon: SvgPicture.asset(
                      'lib/assets/icons/arrow_right_simple.svg',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Переключатель темы.
                  SettingCard(
                    title: loc.lightDarkTheme,
                    onTap: () {},
                    backColor: additionalColors.ratingCard,
                    trailing: Switch(
                      value: _isDarkTheme,
                      onChanged: (value) {
                        setState(() {
                          _isDarkTheme = value;
                        });
                        widget.onThemeChanged(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  SettingCard(
                    title: loc.notifications,
                    onTap: () {},
                    backColor: additionalColors.ratingCard,
                    icon: SvgPicture.asset(
                      'lib/assets/icons/arrow_right_simple.svg',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SettingCard(
                    title: loc.deleteAccount,
                    onTap: () {},
                    backColor: additionalColors.alertRed,
                    textColor: additionalColors.errorRed,
                  ),
                  const SizedBox(height: 4),
                  SettingCard(
                    title: loc.closeApp,
                    onTap: () {},
                    backColor: additionalColors.ratingCard,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
