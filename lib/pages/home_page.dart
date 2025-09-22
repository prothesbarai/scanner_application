import 'package:flutter/material.dart';
import 'package:scanner_application/widgets/custom_appbar.dart';
import 'package:scanner_application/widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appBarTitle: "Home"),
      drawer: CustomDrawer(),
    );
  }
}
