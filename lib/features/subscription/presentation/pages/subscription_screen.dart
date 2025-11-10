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
}
