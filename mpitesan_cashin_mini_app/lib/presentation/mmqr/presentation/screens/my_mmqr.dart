import 'dart:ui' as ui;

import 'package:core/core.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mpitesan_cashin_mini_app/cubit/user_info/user_info_cubit.dart';
import 'package:mpitesan_cashin_mini_app/di/mpitesan_cashin_module_initializer.dart';
import 'package:mpitesan_cashin_mini_app/model/user_model.dart';
import 'package:mpitesan_cashin_mini_app/presentation/mmqr/presentation/bloc/mmqr/mmqr_cubit.dart';
import 'package:mpitesan_cashin_mini_app/widget/amount_sheet.dart';
import 'package:mpitesan_cashin_mini_app/widget/dealer_card.dart';
import 'package:qr_flutter/qr_flutter.dart';


class MyMMQrScreen extends StatefulWidget {
  const MyMMQrScreen({super.key});

  @override
  State<MyMMQrScreen> createState() => _MyMMQrScreenState();
}

class _MyMMQrScreenState extends State<MyMMQrScreen> {
  bool _isLoading = true;
  late UserInfoCubit userInfoCubit;
  late MmqrCubit mmqrCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userInfoCubit = context.read<UserInfoCubit>();
      mmqrCubit = context.read<MmqrCubit>();
      _fetchUserInfo();
    });
  }

  Future<void> _fetchUserInfo() async {
    // Show progress dialog
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );
    
    // Call getUserInfo
    debugPrint("fetching user info");
    try {
      await userInfoCubit.checkUserInfo("9772661150");
    } finally {
      // Dismiss progress dialog
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserInfoCubit, UserInfoState>(
      listener: (context, state) {
        debugPrint("State changed: ${state.runtimeType}");
        if (state is UserInfoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${state.message}")),
          );
        }
      },
      builder: (BuildContext context, state) {
        if (state is UserInfoLoading) {
          debugPrint("loading ---->");
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFec1d24)),
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.1)
              ),
            ),
          );
        } else if (state is UserInfoSuccess) {
          debugPrint("success ---->");
          UserInfoResponse userInfo = state.userInfo;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mmqrCubit.generateMMQRText(amount: 0, userInfo: userInfo);
          });
          return MMQRCard(userInfo: userInfo);
        } else if (state is UserInfoError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${state.message}"),
                ElevatedButton(
                  onPressed: _fetchUserInfo,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }
        return Center(
          child: ElevatedButton(
            onPressed: _fetchUserInfo,
            child: const Text("Load User Info"),
          ),
        );
      },
    );
  }
}

class MMQRCard extends StatefulWidget {
  const MMQRCard({super.key, required this.userInfo});
  final UserInfoResponse userInfo;

  @override
  State<MMQRCard> createState() => _MMQRCardState();
}

class _MMQRCardState extends State<MMQRCard> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  Uint8List? uint8list;
  double amount = 0;
  bool isAmount = false;

  Future<void> captureWidget() async {
    try {
      final RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;

      await Future.delayed(Duration(milliseconds: 100));

      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      uint8list = byteData?.buffer.asUint8List();
    } catch (e) {
      print('Capture widget error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double cardWidth = size.width - 24;
    final double cardHeight = cardWidth * 29 / 20;

    return BlocBuilder<MmqrCubit, MmqrState>(
      builder: (BuildContext context, state) {
        if (state is MmqrDataState) {
          return Column(
            children: [
              RepaintBoundary(
                key: _repaintBoundaryKey,
                child: DealerCard(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: cardHeight * 0.185,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                color: Colors.amber,
                                height: 8,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/mmqr-logo.png',
                                width: cardHeight * 0.185,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(cardWidth * 0.15, 16, 0, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(),
                            Text(
                              widget.userInfo.merchantName ?? '',
                              //style: KStyle.tNameMMQR,
                              textAlign: TextAlign.center,
                            ),
                            Text("amount $amount")
                            // Text(
                            //   amount == 0
                            //       ? 'Scan to input amount'
                            //       : Utility.formatCurrency(amount),
                            //   style: KStyle.tAmountMMQR,
                            // ),
                          ],
                        ),
                      ),
                      DottedLine(
                        dashLength: 2,
                        dashGapLength: 2,
                        lineThickness: 2,
                        //dashColor: KStyle.cYellowMMQR,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'MMQR',
                        //style: KStyle.tNameMMQR,
                      ),
                      const SizedBox(height: 12),
                      QrImageView(
                        padding: EdgeInsets.zero,
                        data: state.mmqrText,
                        version: QrVersions.auto,
                        embeddedImage:
                            AssetImage('assets/images/mpitesan-logo.png'),
                        size: cardWidth - (cardWidth * 0.15 * 2),
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        height: 12,
                        width: size.width,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CircleIconLabelButton(
                  //   icon: 'download',
                  //   label: tr.download,
                  //   onTap: () async {
                  //     await captureWidget();
                  //     if (uint8list != null) {
                  //       MyUtility.saveImage(uint8list!, context, 'QR saved');
                  //     }
                  //   },
                  // ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      if (isAmount) {
                        setState(() {
                          isAmount = false;
                          amount = 0;
                        });
                      } else {
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            useSafeArea: true,
                            isScrollControlled: true,
                            builder: (context) {
                              return EnterAmountSheet(
                                onSubmit: (value) {
                                  setState(() {
                                    amount = value;
                                    isAmount = true;
                                    context.read<MmqrCubit>().generateMMQRText(
                                        amount: amount,
                                        userInfo: widget.userInfo);
                                  });
                                },
                              );
                            });
                      }
                    },
                    child: Text(isAmount ? "clear" : "add"),
                  ),
                  const SizedBox(width: 12),
                  
                ],
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

// '000201 | 010211 | 2650 | 0015 com.mmqrpay.www | 0115 620401000000064 | 0208 10001350 | 5204 | 5814 | 5303 | 104 | 5802 | MM | 5919 | Ngwe La Yaung Store | 6006 | Yangon | 6106 | 100001 | 6215 | 0211 | 95933060000 | 6430 | 0002 |MY | 0109 | ငွေလရောင် | 0207 | ရန်ကုန် | 6304 | 0048'
