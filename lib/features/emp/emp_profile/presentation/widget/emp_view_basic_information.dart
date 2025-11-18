import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/emp/emp_profile/application/bloc/emp_user_bloc.dart';
import 'package:mama_kris/features/emp/emp_profile/presentation/emp_profile_edit_basic_info.dart';

class EmpViewBasicInformation extends StatelessWidget {
  EmpViewBasicInformation({super.key});

  String? name;
  String? email;
  String? dob;

  @override
  Widget build(BuildContext context) {
    final userState = context.read<EmpUserBloc>().state;

    if (userState is EmpUserLoaded) {
      name = userState.user.name;
      dob = userState.user.birthDate;
      email = userState.user.email;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Основная информация',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: 'Гордова',
            labelText: "Фамилия",
            controller: TextEditingController(text: name),
            readOnly: true,

          ),
          const SizedBox(height: 8),

     
          CustomInputText(
            hintText: '23.08.1999',
            labelText: "Дата рождения",
            controller: TextEditingController(text: dob),
            readOnly: true,

          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: 'MamaKris@gmail.com',
            labelText: "Почта",
            controller: TextEditingController(text: email),
            hasGreyBg: true,
            readOnly: true,
          ),

          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmpProfileEditBasicInfo(),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.pen, color: Colors.white, size: 18),
            label: const Text(
              "Добавить контакт",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.empPrimaryColor,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
