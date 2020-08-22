import 'package:bloc/bloc.dart';
import "./payment_state.dart";
import "./payment_events.dart";

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(double amountDue) : super(PaymentState(initAmountDue: amountDue));

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is AddPayment) {
      yield* _mapAddPaymentToState(event);
    }
  }

  Stream<PaymentState> _mapAddPaymentToState(AddPayment payment) async* {
    state.paymentMade = payment.amount;
    yield state;
  }

  @override
  void onChange(Change<PaymentState> change) {
    // print("there has been a change");
    // print("current: ${change.currentState.paymentMade}");
    // print("next: ${change.nextState.paymentMade}");
    super.onChange(change);
  }
}