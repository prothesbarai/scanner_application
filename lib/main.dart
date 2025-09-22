import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanner_application/pages/scanner_home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, systemNavigationBarColor: Colors.transparent, systemNavigationBarDividerColor: Colors.transparent, statusBarIconBrightness: Brightness.light, systemNavigationBarIconBrightness: Brightness.light,),);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: AppBarThemeData(backgroundColor: Colors.blue,centerTitle: true,foregroundColor: Colors.white,iconTheme: IconThemeData(color: Colors.white)),
        drawerTheme: DrawerThemeData(backgroundColor: Colors.black26,surfaceTintColor: Colors.white),
        buttonTheme: ButtonThemeData(buttonColor: Colors.pink, textTheme:ButtonTextTheme.normal,hoverColor: Colors.blue),
      ),
      home: ScannerHomePage()
    );
  }
}

