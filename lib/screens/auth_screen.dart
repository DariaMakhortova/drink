import 'package:flutter/material.dart';
import '../state/app_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _showPassword = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _switchMode(bool isLogin) {
    setState(() {
      _isLogin = isLogin;
      _showPassword = false;
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isSubmitting = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isLogin) {
      final error = await widget.controller.login(
        email: email,
        password: password,
      );
      if (!mounted) return;
      if (error != null) {
        _showMessage(error, isError: true);
      }
    } else {
      await widget.controller.register(
        name: _nameController.text.trim(),
        email: email,
        password: password,
      );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError
            ? Colors.redAccent
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  String? _validateName(String? value) {
    if (_isLogin) return null;
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Введите имя.';
    if (text.length < 2) return 'Имя должно быть не короче 2 символов.';
    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Введите почту.';
    final pattern = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$');
    if (!pattern.hasMatch(text)) return 'Введите корректный email.';
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Введите пароль.';
    if (text.length < 6) return 'Пароль должен быть не короче 6 символов.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFCBDFEA),
              Color(0xFFDCEBF3),
              Color(0xFFF4F8FB),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 40, 16, 32 + keyboardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Круглая иконка
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_cafe_rounded,
                    color: Color(0xFF4B3935),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 18),
                // Заголовок
                const Text(
                  'Drink Flow',
                  style: TextStyle(
                    color: Color(0xFF4B3935),
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Заказ напитков в красивом и простом формате',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF5F514D),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                // Белая карточка с формой
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.98),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x1A4B3935),
                        blurRadius: 36,
                        offset: Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // Переключатель Вход / Регистрация
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F0FA),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: _ModeButton(
                                    label: 'Вход',
                                    icon: Icons.login_rounded,
                                    isActive: _isLogin,
                                    onTap: () => _switchMode(true),
                                  ),
                                ),
                                Expanded(
                                  child: _ModeButton(
                                    label: 'Регистрация',
                                    icon: Icons.person_add_alt_rounded,
                                    isActive: !_isLogin,
                                    onTap: () => _switchMode(false),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Поле имени (только для регистрации)
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: _isLogin
                                ? const SizedBox.shrink()
                                : Padding(
                                    key: const ValueKey('name'),
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: TextFormField(
                                      controller: _nameController,
                                      textInputAction: TextInputAction.next,
                                      validator: _validateName,
                                      decoration: const InputDecoration(
                                        labelText: 'Имя',
                                        hintText: 'Например, Анна',
                                        prefixIcon: Icon(
                                          Icons.person_outline_rounded,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          // Поле email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: _validateEmail,
                            decoration: const InputDecoration(
                              labelText: 'Почта',
                              hintText: 'example@mail.com',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Поле пароля
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            textInputAction: TextInputAction.done,
                            validator: _validatePassword,
                            onFieldSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              labelText: 'Пароль',
                              hintText: 'Не короче 6 символов',
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => _showPassword = !_showPassword,
                                ),
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Кнопка отправки
                          FilledButton(
                            onPressed: _isSubmitting ? null : _submit,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                _isSubmitting
                                    ? 'Подождите...'
                                    : _isLogin
                                    ? 'Войти'
                                    : 'Создать аккаунт',
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Кнопка переключения режима
                          TextButton(
                            onPressed: () => _switchMode(!_isLogin),
                            child: Text(
                              _isLogin
                                  ? 'Нет аккаунта? Зарегистрироваться'
                                  : 'Уже есть аккаунт? Войти',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Вспомогательный виджет кнопки-переключателя
class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF4B3935);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isActive ? activeColor : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : const Color(0xFF6F6E8E),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF6F6E8E),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
