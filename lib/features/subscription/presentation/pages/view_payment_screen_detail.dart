import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_secondary_button.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_error_retry.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/subscription/application/cubit/subscription_status_cubit.dart';
import 'package:intl/intl.dart';

class ViewPaymentScreenDetail extends StatefulWidget {
  const ViewPaymentScreenDetail({super.key});

  @override
  State<ViewPaymentScreenDetail> createState() =>
      _ViewPaymentScreenDetailState();
}

class _ViewPaymentScreenDetailState extends State<ViewPaymentScreenDetail> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionStatusCubit>().getSubscriptionStatus();
  }

  bool _isApplicant = true; // TODO to be updated based on user type

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "Подписка"),
      body: Container(
        decoration: _isApplicant
            ? const BoxDecoration(gradient: AppTheme.primaryGradient)
            : const BoxDecoration(color: AppPalette.empBgColor),
        child: SafeArea(
          child: CustomDefaultPadding(
            child: Column(
              children: [
                Expanded(
                  child:
                      BlocBuilder<
                        SubscriptionStatusCubit,
                        SubscriptionStatusState
                      >(
                        builder: (context, state) {
                          if (state is SubscriptionStatusLoading) {
                            return const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ],
                            );
                          } else if (state is SubscriptionStatusError) {
                            return Center(
                              child: CustomErrorRetry(
                                onTap: () {
                                  context
                                      .read<SubscriptionStatusCubit>()
                                      .getSubscriptionStatus();
                                },
                              ),
                            );
                          } else if (state is GetSubscriptionStatusState) {
                            return _SubscriptionInfo(state: state);
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadUserTypeAndSetupTabs() async {
    final bool isAppl = await sl<AuthLocalDataSource>().getUserType();

    setState(() {
      _isApplicant = isAppl;
    });
  }
}

class _SubscriptionInfo extends StatelessWidget {
  final GetSubscriptionStatusState state;
  const _SubscriptionInfo({required this.state});

  @override
  Widget build(BuildContext context) {
    final hasSubscription = state.hasSubscription;
    final expiresAt = state.expiresAt;
    final startsAt = state.startsAt;

    final subscriptionType = state.type ?? "Не указано";

    return Column(
      children: [
        Center(
          child: Container(
            decoration: AppTheme.cardDecoration,
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: hasSubscription
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: "Подписка",
                        style: TextStyle(fontSize: 20),
                      ),

                      const SizedBox(height: 12),
                      Text(
                        hasSubscription ? "Подписка активна" : "Нет подписки",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hasSubscription && expiresAt != null) ...[
                        const SizedBox(height: 8),

                        Text(
                          "Тариф: $subscriptionType",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        if (startsAt != null)
                          Text(
                            "Дата приобретения подписки: ${DateFormat('dd.MM.yyyy').format(startsAt)}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        const SizedBox(height: 4),
                        Text(
                          "Дата окончания подписки:  ${DateFormat('dd.MM.yyyy').format(expiresAt)}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ), // TODO updated after api provided.
                      ],
                    ],
                  )
                : Column(
                    children: [
                      const CustomText(
                        text: "У вас нет подписки",
                        style: TextStyle(
                          color: AppPalette.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const CustomText(
                        text: "Но вы можете ее приобрести сейчас!",
                      ),
                      const SizedBox(height: 20),

                      CustomSecondaryButton(
                        btnText: "Приобрести",

                        onTap: () {
                          context.pushNamed(RouteName.subscription);
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
