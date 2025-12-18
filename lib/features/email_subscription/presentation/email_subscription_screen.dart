import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/email_subscription/application/bloc/email_subscription_bloc.dart';
import 'package:mama_kris/features/email_subscription/application/bloc/email_subscription_event.dart';
import 'package:mama_kris/features/email_subscription/application/bloc/email_subscription_state.dart';

class EmailSubscriptionScreen extends StatefulWidget {
  const EmailSubscriptionScreen({super.key});

  @override
  State<EmailSubscriptionScreen> createState() =>
      _EmailSubscriptionScreenState();
}

class _EmailSubscriptionScreenState extends State<EmailSubscriptionScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Email Subscription'),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: CustomDefaultPadding(
                    child: SingleChildScrollView(
                      child: BlocListener<EmailSubscriptionBloc,
                          EmailSubscriptionState>(
                        listener: (context, state) {
                          if (state is EmailSubscriptionSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Clear the email field after successful operation
                            emailController.clear();
                          } else if (state is EmailSubscriptionFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: BlocBuilder<EmailSubscriptionBloc,
                            EmailSubscriptionState>(
                          builder: (context, state) {
                            final isLoading =
                                state is EmailSubscriptionLoading;

                            return Form(
                              key: _formKey,
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
                                          text: "Email Subscription",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const CustomText(
                                          text:
                                              "Subscribe or unsubscribe from our email updates",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        CustomInputText(
                                          hintText: 'example@email.com',
                                          labelText: "Email Address",
                                          controller: emailController,
                                          validator:
                                              FormValidations.validateEmail,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                        ),
                                        const SizedBox(height: 30),
                                        CustomButtonApplicant(
                                          btnText: 'Subscribe',
                                          isLoading: isLoading,
                                          isBtnActive: !isLoading,
                                          onTap: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context
                                                  .read<EmailSubscriptionBloc>()
                                                  .add(
                                                    SubscribeEmailEvent(
                                                      email:
                                                          emailController.text,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 15),
                                        CustomButtonApplicant(
                                          btnText: 'Unsubscribe',
                                          isLoading: isLoading,
                                          isBtnActive: !isLoading,
                                          onTap: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context
                                                  .read<EmailSubscriptionBloc>()
                                                  .add(
                                                    UnsubscribeEmailEvent(
                                                      email:
                                                          emailController.text,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
