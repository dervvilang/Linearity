// lib/views/edit_profile_view.dart

import 'package:flutter/material.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../view_models/edit_profile_vm.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditProfileViewModel>();
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;

    Widget buildAvatar() {
      return CircleAvatar(
        radius: 75,
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset(
          vm.avatarAsset,
          width: 150,
          height: 150,
        ),
      );
    }

    void showAvatarPicker() {
      showModalBottomSheet<String>(
        context: context,
        builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: vm.availableAvatars.map((asset) {
              return GestureDetector(
                onTap: () {
                  vm.setAvatarAsset(asset);
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset(
                  asset,
                  width: 90,
                  height: 90,
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    return Scaffold(
      // убираем стандартный appBar
      body: Column(
        children: [
          // кастомный AppBar
          SafeArea(
            child: Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
              child: Row(
                children: [
                  Material(
                    shape: const CircleBorder(),
                    color: colors.greetingText,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'lib/assets/icons/arrow_left.svg',
                        width: 26,
                        height: 26,
                        color: colors.text,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      loc.editProfileTitle,
                      style: theme.textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // основное содержимое
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Аватар
                          Center(
                            child: GestureDetector(
                              onTap: showAvatarPicker,
                              child: buildAvatar(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: TextButton(
                              onPressed: showAvatarPicker,
                              child: Text(
                                loc.changeAvatar,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Никнейм
                          TextFormField(
                            initialValue: vm.username,
                            decoration: InputDecoration(
                              labelText: loc.usernameLabel,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: vm.setUsername,
                            validator: (v) =>
                                v == null || v.isEmpty ? loc.fieldRequired : null,
                          ),
                          const SizedBox(height: 24),

                          // Кнопка Сохранить
                          ElevatedButton(
                            onPressed: vm.hasChanges
                                ? () async {
                                    if (!_formKey.currentState!.validate()) return;
                                    try {
                                      await vm.saveChanges();
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(loc.profileUpdated)),
                                      );
                                      Navigator.pop(context);
                                    } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      );
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(loc.saveChanges),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),

          // Кнопка Удалить аккаунт, закреплена снизу
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(loc.deleteAccount),
                    content: Text(loc.deleteAccountConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(loc.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(loc.deleteAccount),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  try {
                    await vm.deleteAccount();
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (_) => false);
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(loc.deleteAccount),
            ),
          ),
        ],
      ),
    );
  }
}
