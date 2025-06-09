import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpitesan_cashin_mini_app/cubit/user_info/user_info_cubit.dart';
import 'package:mpitesan_cashin_mini_app/model/user_model.dart';
import 'package:mpitesan_cashin_mini_app/widget/amount_sheet.dart';
import 'package:mpitesan_cashin_mini_app/widget/dealer_card.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MpitesanQr extends StatefulWidget {
  const MpitesanQr({super.key});

  @override
  State<MpitesanQr> createState() => _MpitesanQrState();
}

class _MpitesanQrState extends State<MpitesanQr> {
  double amount = 0;
  bool isAmount = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<UserInfoCubit, UserInfoState>(
          builder: (BuildContext context, state) {
            if (state is UserInfoSuccess) {
              UserInfoResponse userInfo = state.userInfo;

              String phoneNo = userInfo.msisdn ?? '';
              return DealerCard(
                margin: EdgeInsets.symmetric(horizontal: 12),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: Column(
                  children: [
                    Text(
                      userInfo.name ?? '',
                      // style: KStyle.tTitleL,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'MerchantId: 0$phoneNo',
                      //style: KStyle.tBodyS,
                    ),
                    const SizedBox(height: 24),
                    QrImageView(
                      data: isAmount ? '$phoneNo|$amount' : phoneNo,
                      version: QrVersions.auto,
                      embeddedImage:
                          AssetImage('assets/images/mpitesan-logo.png'),
                      size: 287.0,
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                    ),
                    if (isAmount) ...{
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'amount:  ',
                            // style: KStyle.tTitleL.copyWith(
                            //   color: KStyle.cPrimary,
                            // ),
                          ),
                          Text(
                            'Ks $amount',
                          ),
                          // Utility.formatCurrencyRichText(
                          //   amount,
                          //   symbol: 'Ks',
                          //   wholeStyle: KStyle.tTitleL.copyWith(
                          //     color: KStyle.cPrimary,
                          //   ),
                          //   decimalStyle: KStyle.tBodyM.copyWith(
                          //     color: KStyle.cPrimary,
                          //   ),
                          // ),
                        ],
                      ),
                    }
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () {
            if (isAmount) {
              setState(() {
                isAmount = false;
                amount = 0;
              });
            } else {
              showModalBottomSheet(
                  backgroundColor: Colors.white10,
                  context: context,
                  useSafeArea: true,
                  isScrollControlled: true,
                  builder: (context) {
                    return EnterAmountSheet(
                      onSubmit: (value) {
                        setState(() {
                          amount = value;
                          isAmount = true;
                        });
                      },
                    );
                  });
            }
          },
          child: Text(isAmount ? "clear" : "add"),
        ),
      ],
    );
  }
}
