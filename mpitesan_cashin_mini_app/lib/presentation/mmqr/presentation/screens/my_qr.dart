import 'package:flutter/material.dart';
import 'package:mpitesan_cashin_mini_app/presentation/mmqr/presentation/screens/my_mmqr.dart';

class MyQrScreen extends StatefulWidget {
  const MyQrScreen({super.key});

  static const String routeName = '/my-qr';

  @override
  State<MyQrScreen> createState() => _MyQrScreenState();
}

class _MyQrScreenState extends State<MyQrScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('My QR'),
      ),
      body: MyMMQrScreen(), // Replace with your MMQR screen widget
    );
  }
}
