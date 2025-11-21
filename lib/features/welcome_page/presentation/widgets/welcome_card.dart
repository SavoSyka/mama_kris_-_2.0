import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_sec.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Что вам интересно?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 36),

          CustomButtonApplicant(
            btnText: 'Ищу удаленную работу',
            onTap: () async {
              await sl<AuthLocalDataSource>().saveUserType(true);

              context.pushNamed(RouteName.loginApplicant);
            },
          ),
          const SizedBox(height: 12),

          CustomButtonSec(
            btnText: 'Ищу сотрудника на удалёнку',
            onTap: () async {
              debugPrint('button tapped');
              await sl<AuthLocalDataSource>().saveUserType(false);
              context.pushNamed(RouteName.loginEmploye);
            },
          ),
        ],
      ),
    );
  }
}
