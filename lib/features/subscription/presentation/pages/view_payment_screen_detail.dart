import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_error_retry.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/media_res.dart';
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: "Управление подпиской"),
      body: CustomDefaultPadding(
        child: BlocBuilder<SubscriptionStatusCubit, SubscriptionStatusState>(
          builder: (context, state) {
            if (state is SubscriptionStatusLoading) {
              return const Center(child: CircularProgressIndicator());
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
    );
  }
}

class _SubscriptionInfo extends StatelessWidget {
  final GetSubscriptionStatusState state;
  const _SubscriptionInfo({required this.state});

  @override
  Widget build(BuildContext context) {
    final hasSubscription = state.hasSubscription;
    final expiresAt = state.expiresAt;
    final subscriptionType = state.type ?? "Не указано";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),

        // Subscription Status Card
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          color: const Color(0xFFF9F9F9),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomImageView(
                  imagePath: hasSubscription
                      ? MediaRes.subscribedIcon
                      : MediaRes.noSubscriptionIcon,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,

                ),
                const SizedBox(height: 12),
                Text(
                  hasSubscription ? "Подписка активна" : "Нет подписки",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (hasSubscription && expiresAt != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    "Действует до: ${DateFormat('dd.MM.yyyy').format(expiresAt)}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Тип: $subscriptionType",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}
