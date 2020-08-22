import 'package:cashMeOutside/bloc/payment/payment_events.dart';
import 'package:cashMeOutside/bloc/payment/payment_state.dart';
import 'package:cashMeOutside/bloc/payment_bloc.dart';
import 'package:cashMeOutside/tools/decimal_text_input_formatter.dart';
import 'package:cashMeOutside/tools/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentForm extends StatefulWidget {
  PaymentState _paymentState;
  PaymentForm(PaymentState paymentState) {
    this._paymentState = paymentState;
  }

  @override
  PaymentFormState createState() => new PaymentFormState();
}

class PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isValid = false;
  final paymentAmount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () {
        final isValid = _formKey.currentState.validate();
        if (_isValid != isValid) {
          setState(() {
            _isValid = isValid;
          });
        }
      },
      child: Expanded(
          child: Column(
        children: <Widget>[
          Expanded(
              child: Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              child: TextFormField(
                controller: paymentAmount,
                validator: (value) {
                  var payment = double.tryParse(value) ?? 0;
                  if (payment < widget._paymentState.amountDue) {
                    return 'Payment amount is too low.';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 25.0),
                decoration: InputDecoration(
                  hintText: "Payment Amount",
                  isDense: true,
                  prefixIcon: Text(
                    "R ",
                    style: TextStyle(fontSize: 30.0),
                  ),
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 0.0, minHeight: 0),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  DecimalTextInputFormatter()
                ],
              ),
            ),
          )),
          Column(children: <Widget>[
            SizedBox(
                width: double.infinity,
                height: 50.0,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      double payment = double.parse(paymentAmount.text);
                      var paymentBloc = BlocProvider.of<PaymentBloc>(context);
                      paymentBloc.add(ProcessPayment(amount: payment));
                      paymentBloc.close();
                      Navigator.pushNamed(context, "/breakdown");
                    } else {
                      showSnackBar(context, "Please correct the errors",
                          Colors.redAccent);
                    }
                  },
                  child: Text(
                    "Process",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  color: Colors.greenAccent,
                ))
          ])
        ],
      )),
    );
  }
}
