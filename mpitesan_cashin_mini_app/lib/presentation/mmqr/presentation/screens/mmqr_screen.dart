// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:merchant_app/features/mmqr/services/push_payment_qr_service.dart';
// import 'package:merchant_app/services/my_utility.dart';
//
// import '../../../../services/localization_service.dart';
//
// class MMQRScreen extends StatefulWidget {
//   const MMQRScreen({super.key});
//
//   static const String routeName = '/generate-qr';
//
//   @override
//   State<MMQRScreen> createState() => _MMQRScreenState();
// }
//
// class _MMQRScreenState extends State<MMQRScreen> {
//   final TextEditingController _amountController = TextEditingController();
//   PushPaymentData? pushPaymentData;
//   Uint8List? qrImageData;
//   bool isLoading = false;
//
//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _generateQR() async {
//     if (_amountController.text.isEmpty) {
//       MyUtility.showToast(context, tr.pleaseEnterAmount);
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       // Create push payment data
//       final amount = _amountController.text;
//       pushPaymentData = PushPaymentData();
//
//       // Set all the required fields
//       pushPaymentData!.setPayloadFormatIndicator("01");
//       pushPaymentData!.setValue("01", "12");
//       // pushPaymentData!.setMerchantIdentifierAmex12("3400678934521469");
//
//       // Set MAID data
//       String rootTag = "26";
//       MAIData maiData = MAIData(rootTag);
//       pushPaymentData!.setDynamicMAIDTag(maiData);
//
//       // Set merchant details
//       pushPaymentData!.setMerchantCategoryCode("1434");
//       pushPaymentData!.setTransactionCurrencyCode("156");
//       pushPaymentData!.setValue("54", amount);
//       pushPaymentData!.setCountryCode("CN");
//       pushPaymentData!.setMerchantName("BEST TRANSPORT");
//       pushPaymentData!.setMerchantCity("BEIJING");
//       pushPaymentData!.setPostalCode("56748");
//
//       // Set additional data
//       AdditionalData addData = AdditionalData();
//       addData.setStoreId("A6008");
//       addData.setAdditionalDataRequest("ME");
//       addData.setValue("00", "73523647");
//       addData.setMerchantTaxId("934538746AIUW");
//       addData.setMerchantChannel("967");
//
//       String rootSubTag = "50";
//       UnrestrictedData additionalUnrestrictedData =
//           UnrestrictedData(rootSubTag);
//       additionalUnrestrictedData.setAID("GUI123");
//       additionalUnrestrictedData.setValue("01", "CONT");
//       additionalUnrestrictedData.setValue("02", "DYN6");
//       addData.setUnrestrictedDataForSubTag(
//           rootSubTag, additionalUnrestrictedData);
//       pushPaymentData!.setAdditionalData(addData);
//
//       // Set language data
//       // LanguageData langData = LanguageData();
//       // langData.setLanguagePreference("ZH");
//       // langData.setAlternateMerchantCity("北京");
//       // langData.setAlternateMerchantName("最佳运输");
//       // pushPaymentData!.setLanguageData(langData);
//
//       // Set MasterCard data
//       // MasterCardData masterCardData = MasterCardData();
//       // masterCardData.setAlias("testAlias123");
//       // masterCardData.setMAID("9384676784");
//       // masterCardData.setPFID("test@testing.com");
//       // masterCardData.setMarketSpecificAlias("AC92836723TT");
//       // pushPaymentData!.setMasterCardData(masterCardData);
//
//       // Generate QR code
//       final imageData = await pushPaymentData!.generateQRCode();
//
//       print(imageData);
//
//       setState(() {
//         qrImageData = imageData;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       MyUtility.showToast(context, "Failed to generate QR code");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(tr.generateQr),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Amount Input
//             TextFormField(
//               controller: _amountController,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//               ],
//               decoration: InputDecoration(
//                 labelText: tr.amount,
//                 hintText: tr.pleaseEnterAmount,
//                 prefixText: 'Ks ',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Generate Button
//             ElevatedButton(
//               onPressed: isLoading ? null : _generateQR,
//               child: isLoading
//                   ? SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                   : Text(tr.generateQr),
//             ),
//             SizedBox(height: 32),
//
//             // QR Display
//             if (qrImageData != null) ...[
//               Center(
//                 child: Image.memory(qrImageData!),
//               ),
//               SizedBox(height: 16),
//               OutlinedButton.icon(
//                 onPressed: () {
//                   final qrData = pushPaymentData!.generatePushPaymentString();
//                   Clipboard.setData(ClipboardData(text: qrData));
//                   MyUtility.showToast(context, tr.qrDataCopied);
//                 },
//                 icon: Icon(Icons.copy),
//                 label: Text(tr.copyQrData),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
