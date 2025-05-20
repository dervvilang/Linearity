import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../view_models/edit_profile_vm.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditProfileViewModel>();
    final loc = AppLocalizations.of(context)!;

    Widget _buildAvatar() {
      if (vm.avatarFile != null) {
        return CircleAvatar(
          radius: 50,
          backgroundImage: FileImage(vm.avatarFile!),
        );
      }
      if (vm.avatarUrl != null && vm.avatarUrl!.startsWith('http')) {
        return CircleAvatar(
          radius: 50,
          backgroundImage: CachedNetworkImageProvider(vm.avatarUrl!),
        );
      }
      // дефолтный SVG из assets
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset(
          'lib/assets/icons/avatar_2.svg',
          width: 100,
          height: 100,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.editProfileTitle),
        leading: BackButton(),
      ),
      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
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
                        onTap: vm.pickAvatar,
                        child: _buildAvatar(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: vm.pickAvatar,
                        child: Text(loc.changeAvatar),
                      ),
                    ),
                    const SizedBox(height: 16),

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
                    const SizedBox(height: 16),

                    // Электронная почта
                    TextFormField(
                      initialValue: vm.email,
                      decoration: InputDecoration(
                        labelText: loc.emailLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: vm.setEmail,
                      validator: (v) {
                        if (v == null || v.isEmpty) return loc.fieldRequired;
                        final emailReg =
                            RegExp(r"^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$");
                        return emailReg.hasMatch(v) ? null : loc.invalidEmail;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Новый пароль
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: loc.passwordLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      obscureText: true,
                      onChanged: vm.setNewPassword,
                      validator: (v) {
                        if (v != null && v.isNotEmpty && v.length < 6) {
                          return loc.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Сохранить
                    ElevatedButton(
                      onPressed: vm.hasChanges
                          ? () async {
                              final form = _formKey.currentState;
                              if (form == null || !form.validate()) return;
                              try {
                                await vm.saveChanges();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(loc.profileUpdated)),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(loc.saveChanges),
                    ),
                    const SizedBox(height: 12),

                    // Удалить аккаунт
                    TextButton(
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
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (_) => false);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        minimumSize: Size(double.infinity, 48),
                      ),
                      child: Text(loc.deleteAccount),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
