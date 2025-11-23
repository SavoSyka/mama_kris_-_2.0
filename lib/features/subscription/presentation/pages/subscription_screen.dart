import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_error_retry.dart';
import 'package:mama_kris/core/common/widgets/custom_iphone_loader.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/show_ios_loader.dart';
import 'package:mama_kris/core/common/widgets/show_toast.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/subscription/application/bloc/TariffsEvent.dart';
import 'package:mama_kris/features/subscription/application/bloc/TariffsState.dart';
import 'package:mama_kris/features/subscription/application/bloc/TarriffsBloc.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_payment_bloc.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_payment_event.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_paymnet_state.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';
import 'package:mama_kris/features/subscription/presentation/cubit/subscription_status_cubit.dart';
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

  bool _isApplicant = false;

  @override
  void initState() {
    _loadUserTypeAndSetupTabs();
    handleFetchTariffs();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen for PaymentInitiatedState changes
    final state = context.watch<SubscriptionPaymentBloc>().state;
    if (state is PaymentInitiatedState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToPayment(state.paymentUrl);
      });
    }
  }

  Future<void> _loadUserTypeAndSetupTabs() async {
    final bool isAppl = await sl<AuthLocalDataSource>().getUserType();

    setState(() {
      _isApplicant = isAppl;
    });
  }

  SubscriptionEntity? _subscription;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Container(
        decoration: _isApplicant
            ? const BoxDecoration(gradient: AppTheme.primaryGradient)
            : const BoxDecoration(color: AppPalette.empBgColor),

        child: CustomDefaultPadding(
          child: BlocBuilder<TarriffsBloc, Tariffsstate>(
            builder: (context, state) {
              return BlocListener<
                SubscriptionPaymentBloc,
                SubscriptionPaymentState
              >(
                listener: (context, state) {
                  if (state is PaymentLoadinState) {
                    showIOSLoader(context);
                  } else if (state is PaymentErrorState) {
                    showToast(context, message: state.message);
                  } else if (state is PaymentInitiatedState) {
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: SafeArea(
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

                              if (state is TariffsLoadingState)
                                const Center(child: IPhoneLoader(height: 200))
                              else if (state is TariffsErrorState)
                                Center(
                                  child: CustomErrorRetry(
                                    errorMessage: state.message,
                                    onTap: () => handleFetchTariffs(),
                                  ),
                                )
                              // else if (state is PaymentInitiatingState)
                              //   const Center(child: IPhoneLoader(height: 200))
                              // else if (state is PaymentErrorState)
                              //   Center(
                              //     child: CustomErrorRetry(
                              //       errorMessage: state.message,
                              //       onTap: () => _subscription != null
                              //           ? _initiatePayment(_subscription!)
                              //           : null,
                              //     ),
                              //   )
                              // else if (state is PaymentInitiatedState)
                              //   // Handle payment URL - this would be handled by navigation
                              //   Container()
                              else if (state is TariffsLoadedState)
                                // Generate list of cards dynamically
                                ...state.subscriptions.map(
                                  (subscription) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(32),
                                            ),
                                          ),
                                          builder: (BuildContext context) {
                                            return Container(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    subscription.name,
                                                    style: const TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  SubscriptionCard(
                                                    isSelected: true,
                                                    period: subscription.type,
                                                    discount: subscription.name,
                                                    price: subscription.price,
                                                    // paidContent:   subscription.paidContent
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    'Полный доступ ко всем премиум-функциям за ${subscription.price} в ${subscription.type}.',

                                                    // subscription.paidContent.replaceAll('\n', " "),
                                                    // 'Access to all premium features for ${subscription.price} per ${subscription.type}.',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFF596574),
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  const SizedBox(height: 32),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _subscription =
                                                            subscription;
                                                      });
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                      _initiatePayment(
                                                        subscription,
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          _isApplicant
                                                          ? AppPalette
                                                                .primaryColor
                                                          : AppPalette
                                                                .empPrimaryColor,

                                                      minimumSize: const Size(
                                                        double.infinity,
                                                        50,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'Subscribe and Pay',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: SubscriptionCard(
                                        isSelected: false,
                                           
                                        period: subscription.type,
                                        discount: subscription.name,
                                        price: subscription.price,
                                      ),
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // * ────────────── Helper Methods ───────────────────────

  void handleFetchTariffs() {
    context.read<TarriffsBloc>().add(const FetchTariffsEvent());
  }

  void _initiatePayment(SubscriptionEntity subscription) {
    context.read<SubscriptionPaymentBloc>().add(
      InitiatePaymentEvent(tariff: subscription),
    );
  }

  void _navigateToPayment(String paymentUrl) {
    debugPrint("✅✅✅✅✅✅ SUbscription started here");

    context.pushNamed(
      RouteName.paymentWebView,
      extra: {
        'url': paymentUrl,

        // Optional: extra actions you want to run on success/fail
        'onSuccess': () {
          debugPrint("PaymentWebView reported SUCCESS – extra action");

          // Do NOT navigate here! Let the Cubit + BlocListener do it
          // → This prevents wrong routes and duplicate screens
        },

        'onFail': () {
          debugPrint("PaymentWebView reported FAIL");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Платёж не выполнен или был отменён"),
              backgroundColor: Colors.red,
            ),
          );
        },
      },
    );
  }
}
