import 'package:flutter/material.dart';
import 'pass_reset_code.dart';
import 'pass_reset_new_password.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'dart:convert';
import 'package:mama_kris/screens/profile_screen.dart' as profile;
import 'package:mama_kris/constants/api_constants.dart';

class PassResetFlow extends StatefulWidget {
  final double scaleX;
  final double scaleY;

  const PassResetFlow({super.key, required this.scaleX, required this.scaleY});

  @override
  _PassResetFlowState createState() => _PassResetFlowState();
}

class _PassResetFlowState extends State<PassResetFlow> {
  int _currentStep = 1;
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onCodeNext() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? accessToken = prefs.getString('auth_token');
    int? userId = prefs.getInt('user_id');
    if (email == null || email.isEmpty) {
      if (accessToken != null && userId != null) {
        await funcs.updateUserDataInCache(
          accessToken,
          userId,
        ); // Обновляем из API
        email = prefs.getString('email'); // Пробуем снова

        if (email == null || email.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Ошибка: не удалось получить email для подтверждения",
              ),
            ),
          );
          return;
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Пользователь не найден")));
        return;
      }
    }
    final String code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Пожалуйста, введите код подтверждения")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${kBaseUrl}auth/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'verificationCode': int.parse(code)}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final resetToken = data['token'];

        await prefs.setString('reset_password_token', resetToken);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Код подтвержден. Теперь вы можете сбросить пароль."),
          ),
        );

        // Навигация к следующему шагу
        setState(() {
          _currentStep = 2;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Неверный код. Проверьте и попробуйте снова."),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка при проверке кода: $error")),
      );
    }
  }

  void _onPasswordNext() async {
    // Реализуйте сохранение нового пароля (например, вызов API)
    // print("Новый пароль: ${_passwordController.text}");
    // После успешного сохранения можно закрыть панель или показать сообщение

    final prefs = await SharedPreferences.getInstance();
    String? resetToken = prefs.getString('reset_password_token');
    if (resetToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка: Токен сброса пароля не найден.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('${kBaseUrl}auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $resetToken',
          'accept': 'application/json',
        },
        body: jsonEncode({'newPassword': _passwordController.text}),
      );

      if (response.statusCode == 201) {
        // Удаляем токен сброса пароля, так как он больше не нужен
        await prefs.remove('reset_password_token');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Пароль успешно изменен.'),
            backgroundColor: Colors.green,
          ),
        );
        await profile.onExitPressed(context);
      } else {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при изменении пароля: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildStep() {
    try {
    if (_currentStep == 1) {
      return PassResetCodePage(
        key: const ValueKey<int>(1),
        scaleX: widget.scaleX,
        scaleY: widget.scaleY,
        codeController: _codeController,
        onNext: _onCodeNext,
      );
    } else {
      return PassResetNewPasswordPage(
        key: const ValueKey<int>(2),
        scaleX: widget.scaleX,
        scaleY: widget.scaleY,
        passwordController: _passwordController,
        onNext: _onPasswordNext,
      );
    }
  }
    catch (e) {
      return Center(child: Text('Ошибка отображения: $e'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        // Определяем ключ ребенка как число (1 или 2)
        final int childStep = (child.key as ValueKey<int>).value;
        if (childStep == _currentStep) {
          // Новый элемент выезжает справа
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        } else {
          // Старый элемент уезжает влево
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }
      },
      child: _buildStep(),
    );
  }
}
