// lib/views/register_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linearity/view_models/auth_vm.dart';
import 'package:linearity/themes/additional_colors.dart';
import 'package:linearity/views/login_view.dart';
import 'package:linearity/views/home_view.dart';

class RegisterView extends StatefulWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  const RegisterView({
    Key? key,
    required this.isDarkTheme,
    required this.onThemeChanged,
  }) : super(key: key);

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

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthViewModel>();
    await auth.register(
      username: _usernameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
    if (auth.error == null && auth.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(
            isDarkTheme: widget.isDarkTheme,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final theme = Theme.of(context);
    final colors = theme.extension<AdditionalColors>()!;

    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SvgPicture.asset(
                  'lib/assets/icons/profile.svg',
                  height: 120,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Имя пользователя'),
                  validator: (v) =>
                      v != null && v.isNotEmpty ? null : 'Введите имя',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v != null && v.contains('@') ? null : 'Введите email',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordCtrl,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  obscureText: _obscure,
                  validator: (v) =>
                      v != null && v.length >= 6 ? null : 'Не менее 6 символов',
                ),
                const SizedBox(height: 24),
                if (auth.error != null) ...[
                  Text(auth.error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                ],
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
                        : const Text('Зарегистрироваться'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: auth.isLoading
                      ? null
                      : () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginView(
                                isDarkTheme: widget.isDarkTheme,
                                onThemeChanged: widget.onThemeChanged,
                              ),
                            ),
                          );
                        },
                  child: const Text('Уже есть аккаунт? Войти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
