import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mama_kris/constants/api_constants.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_action_button.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_sec.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/welcome_page/presentation/widgets/welcome_card.dart';
import 'package:mama_kris/screens/login_sheet.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:mama_kris/utils/login_logic.dart' as lgn;
import 'package:shared_preferences/shared_preferences.dart';

class ApplLoginScreen extends StatefulWidget {
  const ApplLoginScreen({super.key});

  @override
  State<ApplLoginScreen> createState() => _ApplLoginScreenState();
}

class _ApplLoginScreenState extends State<ApplLoginScreen> {

  @override
  void initState() {

    // TODO: implement initState

    super.initState();

  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['openid', 'email', 'profile'],
    serverClientId:
        '86099763542-a94uom1ijlqu6jp263dtc43dvgd540np.apps.googleusercontent.com',
        // '86099763542-9tgb2dqc63hj0utf8fc9mvve0fplc8e1.apps.googleusercontent.com',
  );

  Future<void> signInWithGoogle() async {
    try {
      // print('🔐 [Google Sign-In] Старт входа');
      debugPrint('signInWithGoogle');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // print('❌ [Google Sign-In] Пользователь отменил вход');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      debugPrint("idToken $idToken");

      if (idToken == null) {
        // print('❗ [Google Sign-In] Не удалось получить ID токен');
        return;
      }

      // print('👤 Пользователь: ${googleUser.displayName} (${googleUser.email})');
      // print('🔑 ID Token: ${idToken.substring(0, 30)}...');

      // Запрос на бэкенд

      final url = Uri.parse('${kBaseUrl}auth/google/login');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'provider': 'ios',
      };

      final body = jsonEncode({'idToken': idToken});

      final response = await http.post(url, headers: headers, body: body);

      // print('📡 [Бэкенд] POST ${url.path} → Статус: ${response.statusCode}');
      // print('📦 Ответ: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final userId = data['userId'];

        if (accessToken != null && refreshToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', accessToken);
          await prefs.setString('refresh_token', refreshToken);
          await prefs.setInt('user_id', userId);
          await prefs.setBool('isLogged', true);
          if (googleUser.displayName != null) {
            final name = googleUser.displayName!;
            await prefs.setString('name', name);
            await funcs.updateUserInfo(name: name);
            // print('📛 Имя пользователя сохранено: ${googleUser.displayName}');
          }

          await prefs.setString('email', googleUser.email);

          final viewedCount = await funcs.getViewedCount(accessToken, userId);
          final likedCount = await funcs.getLikedCount(accessToken, userId);
          await prefs.setInt('viewed_count', viewedCount);
          await prefs.setInt('liked_count', likedCount);

          // print(
          //     '✅ Успешный вход. UserID: $userId, Лайков: $likedCount, Просмотров: $viewedCount');

          final String? currentPage = prefs.getString('current_page');
          if (currentPage == 'choice' || currentPage == null) {
            showRoleSelectionPanel(context);
          } else {
            double scaleX = MediaQuery.of(context).size.width / 428;
            double scaleY = MediaQuery.of(context).size.height / 956;
            Widget nextPage = await lgn.determineNextPage(
              accessToken,
              userId,
              scaleX,
              scaleY,
            );

            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (_, animation, __) => nextPage,
                transitionsBuilder: (_, animation, __, child) {
                  final tween = Tween(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeInOut));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
              (route) => false,
            );
          }
        } else {
          lgn.showErrorSnackBar(context, '❗ Ошибка входа: токены отсутствуют');
        }
      } else {
        lgn.showErrorSnackBar(context, '❗ Ошибка входа через Google');
      }
    } catch (e) {


      print('🛑 Ошибка входа через Google: $e');
      // print('🔍 Stacktrace: $stacktrace');
      lgn.showErrorSnackBar(context, 'Ошибка. Попробуйте ещё раз.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Example usage of enum

    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: ''),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: CustomDefaultPadding(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: AppTheme.cardDecoration,
                      child: Column(
                        children: [
                          const CustomText(
                            text: "Вход",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 20),

                          CustomInputText(
                            hintText: 'Текст',
                            labelText: "Почта",

                            controller: TextEditingController(),
                          ),
                          const SizedBox(height: 12),

                          CustomInputText(
                            hintText: 'Текст',
                            labelText: "Почта",

                            controller: TextEditingController(),
                          ),
                          const SizedBox(height: 42),

                          const CustomButtonApplicant(btnText: 'Войти'),
                          const SizedBox(height: 20),

                          CustomButtonSec(
                            btnText: 'Войти',
                            onTap: () {
                              // debugPrint('signInWithGoogle');

                              signInWithGoogle();
                            },

                            child: const Row(
                              children: [
                                CustomImageView(
                                  imagePath: MediaRes.googleIcon,
                                  width: 24,
                                ),
                                SizedBox(width: 15),

                                CustomText(text: 'Войти через Google'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButtonSec(
                            btnText: 'Войти',
                            onTap: () {
                              debugPrint('signInWithGoogle');

                              // signInWithGoogle();
                            },
                            child: const Row(
                              children: [
                                CustomImageView(
                                  imagePath: MediaRes.appleIcon,
                                  width: 24,
                                ),

                                SizedBox(width: 15),

                                CustomText(text: 'Войти через GoogleFF'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(text: "Нет аккаунта?"),
                              CustomTextButton(
                                text: "Зарегистрироваться",
                                onPressed: () {
                                  context.pushNamed(RouteName.signupApplicant);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
