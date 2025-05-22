// lib/views/login_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linearity/view_models/auth_vm.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/views/register_view.dart';
import 'package:linearity/views/home_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  /// ключ формы для валидации
  final _formKey = GlobalKey<FormState>();
  /// контроллер поля email
  final _emailCtrl = TextEditingController();
  /// контроллер поля пароля
  final _passwordCtrl = TextEditingController();
  /// флаг скрытия пароля
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  /// выполняет вход и обрабатывает ошибки
  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthViewModel>();
    await auth.login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
    if (!mounted) return;

    if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error!),
          backgroundColor: Colors.red,
        ),
      );
      auth.clearError();
      return;
    }

    if (auth.user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.signIn),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// иконка профиля сверху
                SvgPicture.asset(
                  'lib/assets/icons/profile.svg',
                  height: 120,
                  color: colors.text,
                ),
                const SizedBox(height: 32),
                /// поле для email
                TextFormField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(labelText: loc.emailLabel),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v != null && v.contains('@') ? null : loc.enterEmail,
                ),
                const SizedBox(height: 16),
                /// поле для пароля
                TextFormField(
                  controller: _passwordCtrl,
                  decoration: InputDecoration(
                    labelText: loc.passwordLabel,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  obscureText: _obscure,
                  validator: (v) =>
                      v != null && v.length >= 6 ? null : loc.moreSix,
                ),
                const SizedBox(height: 24),
                /// кнопка входа
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : _onLogin,
                    child: auth.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(loc.loginButton),
                  ),
                ),
                const SizedBox(height: 12),
                /// переход к регистрации
                TextButton(
                  onPressed: auth.isLoading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterView()),
                          );
                        },
                  child: Text(loc.register),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
