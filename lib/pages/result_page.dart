import 'package:flutter/material.dart';
import 'package:scanner_application/widgets/custom_appbar.dart';

class ResultPage extends StatelessWidget {
  final String qrResult;
  const ResultPage({super.key,required this.qrResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appBarTitle: "Result"),
      extendBody: true,
      body: Column(
        children: [
          Text(qrResult)
        ],
      ),
    );
  }
}
