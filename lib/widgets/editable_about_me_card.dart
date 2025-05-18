// lib/widgets/editable_about_me_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:linearity/view_models/auth_vm.dart';

class EditableAboutMeCard extends StatefulWidget {
  const EditableAboutMeCard({super.key});

  @override
  State<EditableAboutMeCard> createState() => _EditableAboutMeCardState();
}

class _EditableAboutMeCardState extends State<EditableAboutMeCard> {
  bool isEditing = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String savedText = '';

  @override
  void initState() {
    super.initState();
    // Загружаем текущее описание
    final appUser = context.read<AuthViewModel>().user;
    savedText = appUser?.description ?? '';
    _controller.text = savedText;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _cancelEditing() {
    if (!mounted) return;
    setState(() {
      _controller.text = savedText;
      isEditing = false;
    });
  }

  Future<void> _saveEditing() async {
    final newText = _controller.text.trim();

    // Если ничего не изменилось — просто выйти из режима редактирования
    if (newText == savedText) {
      if (!mounted) return;
      setState(() => isEditing = false);
      return;
    }

    final authVm = context.read<AuthViewModel>();

    // Сохраняем только поле description
    await authVm.updateProfile(description: newText);

    if (!mounted) return;
    setState(() {
      savedText = newText;
      isEditing = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.profileSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isEditing
                ? TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: loc.profileAbout,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      if (!mounted) return;
                      setState(() => isEditing = true);
                      _focusNode.requestFocus();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        savedText.isEmpty ? '${loc.profileAbout}:' : savedText,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
          ),
        ),
        if (isEditing)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _cancelEditing,
                  child: Text(loc.cancelButton),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveEditing,
                  child: Text(loc.saveButton),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
