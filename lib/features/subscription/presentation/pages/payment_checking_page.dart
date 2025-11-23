// screens/payment_checking_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/custom_error_retry.dart';
import 'package:mama_kris/core/common/widgets/custom_iphone_loader.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/features/subscription/presentation/cubit/subscription_status_cubit.dart';

class PaymentCheckingPage extends StatefulWidget {
  const PaymentCheckingPage({super.key});

  @override
  State<PaymentCheckingPage> createState() => _PaymentCheckingPageState();
}

class _PaymentCheckingPageState extends State<PaymentCheckingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SubscriptionStatusCubit>().startPolling();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BlocConsumer<SubscriptionStatusCubit, SubscriptionStatusState>(
          listener: (context, state) {
            if (state is SubscriptionStatusSuccess && state.hasSubscription) {
              context.goNamed(RouteName.homeApplicant);
            }
          },
          builder: (context, state) {
            if (state is SubscriptionStatusError) {
              return CustomErrorRetry(
                onTap: () {
                  context.read<SubscriptionStatusCubit>().startPolling();
                },
              );
            }
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IPhoneLoader(height: 120),
                SizedBox(height: 32),
                Text(
                  "Платёж прошёл успешно!\nПроверяем подписку…",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
