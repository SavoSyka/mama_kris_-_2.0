import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/email_subscription/application/bloc/email_subscription_event.dart';
import 'package:mama_kris/features/email_subscription/application/bloc/email_subscription_state.dart';
import 'package:mama_kris/features/email_subscription/domain/usecases/subscribe_email_usecase.dart';
import 'package:mama_kris/features/email_subscription/domain/usecases/unsubscribe_email_usecase.dart';

class EmailSubscriptionBloc
    extends Bloc<EmailSubscriptionEvent, EmailSubscriptionState> {
  final SubscribeEmailUsecase subscribeEmailUsecase;
  final UnsubscribeEmailUsecase unsubscribeEmailUsecase;

  EmailSubscriptionBloc({
    required this.subscribeEmailUsecase,
    required this.unsubscribeEmailUsecase,
  }) : super(EmailSubscriptionInitial()) {
    on<SubscribeEmailEvent>(_onSubscribeEmail);
    on<UnsubscribeEmailEvent>(_onUnsubscribeEmail);
  }

  Future<void> _onSubscribeEmail(
    SubscribeEmailEvent event,
    Emitter<EmailSubscriptionState> emit,
  ) async {
    emit(EmailSubscriptionLoading());
    final result = await subscribeEmailUsecase(
      SubscribeEmailParams(email: event.email),
    );

    result.fold(
      (failure) => emit(EmailSubscriptionFailure(failure.message)),
      (success) => emit(
        const EmailSubscriptionSuccess('Successfully subscribed to email updates!'),
      ),
    );
  }

  Future<void> _onUnsubscribeEmail(
    UnsubscribeEmailEvent event,
    Emitter<EmailSubscriptionState> emit,
  ) async {
    emit(EmailSubscriptionLoading());
    final result = await unsubscribeEmailUsecase(
      UnsubscribeEmailParams(email: event.email),
    );

    result.fold(
      (failure) => emit(EmailSubscriptionFailure(failure.message)),
      (success) => emit(
        const EmailSubscriptionSuccess('Successfully unsubscribed from email updates!'),
      ),
    );
  }
}
