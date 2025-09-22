import 'package:flutter/material.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:scanner_application/pages/result_page.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';

class ScannerHomePage extends StatefulWidget {
  const ScannerHomePage({super.key});

  @override
  State<ScannerHomePage> createState() => _ScannerHomePageState();
}

class _ScannerHomePageState extends State<ScannerHomePage> {

  int _selectedIndex = 0; // 0 For QR & 1 For Document
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // QR view ke Uniquely identify korar Jonno
  QRViewController? qrViewController;
  String? documentPath;
  bool _isNavigating = false;



  @override
  void dispose() {
    qrViewController?.disposed;
    super.dispose();
  }


  /// >>> ============ QR Scanner Start Here ============
  Widget _buildQrView(BuildContext context){
    return QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(borderColor: Colors.white,borderRadius: 10,borderLength: 30,borderWidth: 5,cutOutSize: 250,),
    );
  }
  void _onQRViewCreated(QRViewController controller){
    qrViewController = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isNavigating) return; // already navigating, ignore

      final result = scanData.code;
      if (result != null && !_isNavigating) {
        _isNavigating = true; // set flag
        await qrViewController?.pauseCamera();  // pause camera

        // navigate after frame render
        if (!mounted) return;
        await Navigator.push(context, MaterialPageRoute(builder: (_) => ResultPage(result: result)),);

        // resume camera after coming back
        await qrViewController?.resumeCamera();
        _isNavigating = false;// reset flag
      }
    });
  }
  /// <<< ============ QR Scanner End Here ==============



  /// >>> ========= Document Scanner Start Here ============
  // No Saved Internal Directory
  /*Future<void> _scanDocument() async {
    if (_isNavigating) return;

    _isNavigating = true;
    try {
      final result = await FlutterDocScanner().getScannedDocumentAsPdf(page: 4);
      if (result != null && mounted) {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => ResultPage(result: result.toString())),);
      }
    } catch (e) {
      debugPrint("Error scanning: $e");
    } finally {
      _isNavigating = false;
    }
  }*/
  // Saved Internal Directory
  Future<void> _scanDocument(BuildContext context) async {
    try {
      // Scan document
      final result = await FlutterDocScanner().getScannedDocumentAsPdf(page: 4000);

      if (result == null) return;

      // Convert result to Uint8List safely
      Uint8List pdfBytes;

      if (result is Uint8List) {
        pdfBytes = result;
      } else if (result is Map) {
        final pdfUri = result['pdfUri'] as String?;
        if (pdfUri == null) throw Exception("pdfUri not found in scanner result");
        final path = pdfUri.replaceFirst('file://', '');
        final file = File(path);
        if (!file.existsSync()) throw Exception("PDF file not found at $path");
        pdfBytes = await file.readAsBytes();
      } else if (result is String) {
        final file = File(result);
        if (!file.existsSync()) throw Exception("Scanned PDF file not found at path: $result");
        pdfBytes = await file.readAsBytes();
      } else {
        throw Exception("Unknown PDF format from scanner: $result");
      }

      // Show confirmation dialog
      if (context.mounted) {
        final shouldSave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Save Document"),
            content: const Text("Do you want to save this scanned document?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Save"),
              ),
            ],
          ),
        );

        if (shouldSave != true) return;
      }




      // Save to Downloads folder
      Directory saveDir;
      if (Platform.isAndroid && !kIsWeb) {
        saveDir = Directory('/storage/emulated/0/Download');
        if (!saveDir.existsSync()) saveDir.createSync(recursive: true);
      } else {
        // iOS or other platforms: app documents folder
        saveDir = await getApplicationDocumentsDirectory();
      }

      final fileName = 'prothes_scanned_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${saveDir.path}/$fileName';
      await File(filePath).writeAsBytes(pdfBytes);

      // Show Toast
      Fluttertoast.showToast(msg: "PDF saved at: $filePath", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM,);
    } catch (e) {
      debugPrint("Error scanning: $e");
    }
  }
  /// <<< ========= Document Scanner End Here ==============





  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          
          /// >>> Camera View QR/Document
          Positioned.fill( child: _selectedIndex == 0 ? _buildQrView(context) : const Center(child: Text("Document Scanner Ready\nClick Again", style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),) ),

          
          /// >>> Bottom Navigation Tab
          Positioned(
              bottom: 70,
              child: Row(
                children: [
                  _buildBottomTab("QR Code", 0, Icons.qr_code),
                    const SizedBox(width: 40),
                  _buildBottomTab("Document", 1, Icons.description),
                ],
              )
          ),


        ],
      ),
    );
  }
  
  
  
  
  
  /// >>> ================== Bottom Tab QR & Document Icon and Text Start Here =================
  Widget _buildBottomTab(String text, int index, IconData icon){
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: (){
        setState(() {_selectedIndex = index;});
        if(index == 1){_scanDocument(context);}
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.white70),
          SizedBox(height: 5,),
          Text(text,style: TextStyle(color: isSelected ? Colors.blue : Colors.white70, fontSize: 14,),),
        ],
      ),
    );
  }
  /// <<< ================== Bottom Tab QR & Document Icon and Text End Here ===================
  
}
