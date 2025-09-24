import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/error_login_container.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/auth/applications/auth_bloc.dart';
import 'package:mama_kris/features/auth/applications/auth_event.dart';
import 'package:mama_kris/features/auth/applications/auth_state.dart';
import 'package:pinput/pinput.dart';

class EmployeHomeBottomsheet {
  static Future<String?> loginBottomSheet(
    BuildContext context, {

    required VoidCallback onNext,
    required TextEditingController controller 
  }) async {
    String? errorMessage;

    final formKey = GlobalKey<FormState>();
    final result = await showModalBottomSheet<String>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.5),
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
    
        return StatefulBuilder(
          builder: (context, useState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 20,
                      right: 20,
                    ),
                    color: Colors.white,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: AppTextContents.login,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),

                          CustomInputText(
                            controller: controller,
                            hintText: AppTextContents.email,
                            // validator: FormValidations.validateName(value),
                          ),
                          const SizedBox(height: 20),

                   

                        

                          const SizedBox(height: 20),

                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              debugPrint(" state $state");
                              if (state is Authenticated) {
                                context.goNamed(RouteName.applicantHome);
                              }
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                              return CustomPrimaryButton(
                                btnText: AppTextContents.next,
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                 
                                    onNext();

                                    return;
                                  } else {}
                                },

                                isLoading: state is AuthLoading,
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          Visibility(
                            visible:
                                MediaQuery.of(context).viewInsets.bottom == 0,

                            child: const SizedBox(height: 200),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    return result;
  }
}
