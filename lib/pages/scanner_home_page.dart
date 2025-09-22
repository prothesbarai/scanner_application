import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanner_application/widgets/custom_appbar.dart';
import 'package:scanner_application/widgets/custom_drawer.dart';

class ScannerHomePage extends StatefulWidget {
  const ScannerHomePage({super.key});

  @override
  State<ScannerHomePage> createState() => _ScannerHomePageState();
}

class _ScannerHomePageState extends State<ScannerHomePage> {

  File? scannedImage;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appBarTitle: "Scanner Home"),
      drawer: CustomDrawer(),
    );
  }
}
