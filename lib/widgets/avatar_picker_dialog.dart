// lib/widgets/avatar_picker_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Диалог для выбора аватара
class AvatarPickerDialog extends StatelessWidget {
  static const _avatars = [
    'lib/assets/icons/avatar_1.svg',
    'lib/assets/icons/avatar_2.svg',
    'lib/assets/icons/avatar_3.svg',
    'lib/assets/icons/avatar_4.svg',
    'lib/assets/icons/avatar_5.svg',
    'lib/assets/icons/avatar_6.svg',
    'lib/assets/icons/avatar_7.svg',
    'lib/assets/icons/avatar_8.svg',
    'lib/assets/icons/avatar_9.svg',
  ];

  const AvatarPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Заголовок диалога
            Text(
              'Выберите аватар',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            /// Сетка из доступных SVG-аватаров
            GridView.builder(
              shrinkWrap: true,
              itemCount: _avatars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (ctx, i) {
                final asset = _avatars[i];
                return GestureDetector(
                  /// Выбирает и возвращает asset при тапе
                  onTap: () => Navigator.pop(context, asset),
                  child: SvgPicture.asset(
                    asset,
                    width: 64,
                    height: 64,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
