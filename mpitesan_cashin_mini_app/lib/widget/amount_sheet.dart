import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EnterAmountSheet extends StatefulWidget {
  const EnterAmountSheet({
    super.key,
    required this.onSubmit,
  });

  final Function(double) onSubmit;

  @override
  State<EnterAmountSheet> createState() => _EnterAmountSheetState();
}

class _EnterAmountSheetState extends State<EnterAmountSheet> {
  final TextEditingController amountCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.close),
              ),
            ),
            Text(
              "Please enter amount"
            ),
            Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 16.0),
                    child: TextFormField(
                      controller: amountCtrl,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      // inputFormatters: [
                      //   NumberInputFormatter(negativeValue: false),
                      // ],
                      autofocus: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '0.0',
                        suffixText: 'Ks',
                      ),
                      onFieldSubmitted: (value) {
                        if (amountCtrl.text.isNotEmpty) {
                          widget.onSubmit(double.parse(
                              amountCtrl.text.replaceAll(',', '')));
                          context.pop();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
