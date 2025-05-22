// lib/views/register_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linearity/view_models/auth_vm.dart';
import 'package:linearity/views/login_view.dart';
import 'package:linearity/views/home_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  /// Выполняет регистрацию нового пользователя
  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthViewModel>();
    await auth.register(
      username: _usernameCtrl.text.trim(),
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    }
  }

  /// Строит экран регистрации
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.registration),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SvgPicture.asset('lib/assets/icons/profile.svg', height: 120),

                const SizedBox(height: 32),

                /// Поле для имени пользователя
                TextFormField(
                  controller: _usernameCtrl,
                  decoration: InputDecoration(labelText: loc.displayNameLabel),
                  validator: (v) =>
                      v != null && v.isNotEmpty ? null : loc.enterName,
                ),

                const SizedBox(height: 16),

                /// Поле для email
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v != null && v.contains('@') ? null : loc.enterEmail,
                ),

                const SizedBox(height: 16),

                /// Поле для пароля
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

                /// Кнопка регистрации
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : _onRegister,
                    child: auth.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(loc.registration2),
                  ),
                ),

                const SizedBox(height: 12),

                /// Переход на экран входа
                TextButton(
                  onPressed: auth.isLoading
                      ? null
                      : () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginView()),
                          );
                        },
                  child: Text(loc.haveAc),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
