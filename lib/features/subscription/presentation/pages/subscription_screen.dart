import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_error_retry.dart';
import 'package:mama_kris/core/common/widgets/custom_iphone_loader.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_bloc.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_event.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_state.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';
import 'package:mama_kris/features/subscription/presentation/pages/widget/subscription_card.dart';
import 'package:mama_kris/screens/payment_webview_page.dart';
import 'package:mama_kris/screens/main_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // * ────────────── Overriding methods ───────────────────────

  @override
  void initState() {
    handleFetchTariffs();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen for PaymentInitiatedState changes
    final state = context.watch<SubscriptionBloc>().state;
    if (state is PaymentInitiatedState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToPayment(state.paymentUrl);
      });
    }
  }

  SubscriptionEntity? _subscription;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: '', showLeading: false),
      body: CustomDefaultPadding(
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    width: 333,
                    child: Text(
                      'Подписка',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        height: 1.30,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  const SizedBox(
                    width: 333,
                    child: Text(
                      'Тысячи кандидатов уже ждут именно вашу удаленную вакансию!',
                      style: TextStyle(
                        color: Color(0xFF596574),
                        fontSize: 16,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        height: 1.30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const SizedBox(
                    width: 333,
                    child: Text(
                      'MamaKris объединяет десятки тысяч активных соискательниц удалённой работы. Разместите своё предложение — и кандидаты начнут писать вам напрямую в мессенджер уже сегодня.',
                      style: TextStyle(
                        color: Color(0xFF596574),
                        fontSize: 16,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        height: 1.30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const SizedBox(
                    width: 333,
                    child: Text(
                      'Оформи подписку и получай отклики в день публикации, а также доступ к десяткам тысяч исполнительниц. ',
                      style: TextStyle(
                        color: Color(0xFF596574),
                        fontSize: 16,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        height: 1.30,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  if (state is SubscriptionLoadingState)
                    const Center(child: IPhoneLoader(height: 200))
                  else if (state is SubscriptionErrorState)
                    Center(
                      child: CustomErrorRetry(
                        errorMessage: state.message,
                        onTap: () => handleFetchTariffs(),
                      ),
                    )
                  else if (state is PaymentInitiatingState)
                    const Center(child: IPhoneLoader(height: 200))
                  else if (state is PaymentErrorState)
                    Center(
                      child: CustomErrorRetry(
                        errorMessage: state.message,
                        onTap: () => _subscription != null ? _initiatePayment(_subscription!) : null,
                      ),
                    )
                  else if (state is PaymentInitiatedState)
                    // Handle payment URL - this would be handled by navigation
                    Container()
                  else if (state is SubscriptionLoadedState)
                    // Generate list of cards dynamically
                    ...state.subscriptions.map(
                      (subscription) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _subscription = subscription;
                            });
                          },
                          child: SubscriptionCard(
                            isSelected:
                                _subscription != null &&
                                _subscription?.tariffID ==
                                    subscription.tariffID,
                            period: subscription.type,
                            discount: subscription.name,
                            price: subscription.price,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),

                  if (_subscription != null && state is! PaymentInitiatingState)
                    ElevatedButton(
                      onPressed: () => _initiatePayment(_subscription!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A80E),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Оформить подписку',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // * ────────────── Helper Methods ───────────────────────

  void handleFetchTariffs() {
    context.read<SubscriptionBloc>().add(const FetchSubscriptionEvent());
  }

  void _initiatePayment(SubscriptionEntity subscription) {
    context.read<SubscriptionBloc>().add(InitiatePaymentEvent(tariff: subscription));
  }

  void _navigateToPayment(String paymentUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentWebViewPage(
          url: paymentUrl,
          callback: (WebViewRequest request) {
            if (request == WebViewRequest.success) {
              // Handle successful payment - navigate to main screen
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (_, animation, secondaryAnimation) =>
                  const MainScreen(initialIndex: 1),
                  transitionsBuilder: (_, animation, __, child) {
                    final tween = Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
                    (_) => false,
              );
            } else {
              // Handle failed payment
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Платеж не выполнен, повторите попытку позже."),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
